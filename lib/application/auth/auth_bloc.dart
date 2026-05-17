import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/auth/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/local/storage/secure_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService secureStorage;

  AuthBloc({required this.authRepository, required this.secureStorage})
    : super(AuthInitial()) {
    // ---------------------------------------------------------
    // 1. APP STARTUP ENGINE
    // ---------------------------------------------------------
    on<AuthAppStarted>((event, emit) async {
      // Pehle thodi der Splash screen dikhao (Optional, par UX ke liye accha hai)
      emit(AuthInitial());

      try {
        // Check if user has an active session (Refresh Token exists)
        final refreshToken = await secureStorage.getRefreshToken();

        if (refreshToken == null) {
          // Naya user hai, ya completely logged out hai
          emit(AuthUnauthenticated());
          return;
        }

        // Agar token hai, toh matlab user returning hai. Usko MPIN screen dikhani hai.
        // Par MPIN API ko email chahiye! Toh local storage se user data nikalo.
        final userData = await secureStorage.getUserData();
        final email = userData?['Email'] ?? '';

        if (email.isEmpty) {
          // Security Fallback: Agar email nahi mila kisi wajah se, force re-login
          await authRepository.logout();
          emit(AuthUnauthenticated());
          return;
        }

        // Sab sahi hai! MPIN screen par bhejo.
        // (Yahan showBiometricPrompt: true kar sakte ho agar hardware checking lagai hai)
        emit(
          AuthMpinRequired(
            email: email,
            showBiometricPrompt:
                false, // Optional: Update this based on biometric settings
          ),
        );
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    // ---------------------------------------------------------
    // 2. REQUEST OTP (Login / Signup)
    // ---------------------------------------------------------
    on<AuthRequestOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        // Repo void return karta hai, so if it finishes without error, it's successful
        await authRepository.requestOtp(event.email, event.password);

        // Pass the email to the next state so the UI can show "OTP sent to..."
        emit(AuthOtpSent(email: event.email));
      } catch (e) {
        emit(AuthError(message: _handleError(e)));
        emit(AuthUnauthenticated()); // Wapas Email input screen par bhejo
      }
    });

    // ---------------------------------------------------------
    // 3. VERIFY OTP
    // ---------------------------------------------------------
    on<AuthVerifyOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        // 1. Repo OTP verify karega, 'isNewUser' storage me save karega aur token return karega
        final String otpAccessToken = await authRepository.verifyOtp(
          event.email,
          event.otp,
        );

        // 2. Storage se check karo ki kya ye naya user hai?
        final String? isNewUserStr = await secureStorage.getIsNewUser();
        final bool isNewUser = (isNewUserStr == "true");

        // 3. SDE3 Routing Logic: Smart Navigation based on User Type
        if (isNewUser) {
          // Scebario A: Naya User hai. MPIN create karne bhejo. (Needs Token)
          emit(AuthMpinSetupRequired(otpAccessToken: otpAccessToken));
        } else {
          // Scenario B: Purana User hai. MPIN enter (login) karne bhejo.
          // Note: Tere AuthMpinRequired state ko 'email' chahiye hota hai!
          emit(
            AuthMpinRequired(email: event.email, showBiometricPrompt: false),
          );
        }
      } catch (e) {
        emit(AuthError(message: _handleError(e)));
        // Failed? Wapas OTP screen par rakho taaki dubara try kar sake
        emit(AuthOtpSent(email: event.email));
      }
    });

    // ---------------------------------------------------------
    // 4. SETUP MPIN (New User)
    // ---------------------------------------------------------
    on<AuthSetupMpin>((event, emit) async {
      emit(AuthLoading());
      try {
        debugPrint("OTP ACCESS TOKEN: ${event.otpAccessToken} ${event.mpin}");
        // Temporary token pass karo Repo ko
        await authRepository.setupMpin(event.mpin, event.otpAccessToken);

        // Permanent tokens aur UserData save ho gaya! Dashboard bhejo!
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: _handleError(e)));
        // Failed? Wapas MPIN setup par rakho with the SAME temporary token
        emit(AuthMpinSetupRequired(otpAccessToken: event.otpAccessToken));
      }
    });

    // ---------------------------------------------------------
    // 5. LOGIN WITH MPIN (Returning User)
    // ---------------------------------------------------------
    on<AuthLoginMpin>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.loginMpin(event.email, event.mpin);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: _handleError(e)));
        emit(AuthMpinRequired(email: event.email, showBiometricPrompt: false));
      }
    });

    // ---------------------------------------------------------
    // 6. BIOMETRIC LOGIN
    // ---------------------------------------------------------
    on<AuthBiometricLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.biometricLogin();
        emit(AuthAuthenticated());
      } catch (e) {
        // Agar FaceID fail hua ya token rotate fail hua, toh error dikhao
        emit(AuthError(message: "Biometric login failed. Please enter MPIN."));

        // Fallback: Wapas MPIN screen par laao
        final userData = await secureStorage.getUserData();
        final email = userData?['Email'] ?? '';
        emit(AuthMpinRequired(email: email, showBiometricPrompt: false));
      }
    });

    // ---------------------------------------------------------
    // 7. LOGOUT
    // ---------------------------------------------------------
    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }

  // SDE3 Helper: To safely extract messages from DioExceptions
  String _handleError(dynamic error) {
    // Agar future mein DioException import karke message nikalna ho toh yahan customize kar sakte ho.
    return error.toString();
  }
}
