import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/auth/auth_state.dart';
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
        final hasBiometricEnabled = await secureStorage.isBiometricEnabled();

        emit(
          AuthMpinRequired(
            email: email,
            showBiometricPrompt:
                hasBiometricEnabled, // Optional: Update this based on biometric settings
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
    // 4. SETUP MPIN (Interception Logic Added)
    // ---------------------------------------------------------
    on<AuthSetupMpin>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.setupMpin(event.mpin, event.otpAccessToken);

        // 🚨 SDE3 INTERCEPTION: Dashboard bhejne se pehle check karo 🚨
        final hasOptedOut = await secureStorage.hasBiometricOptedOut();
        final hasEnabled = await secureStorage.isBiometricEnabled();

        // Use your biometric service to check if phone has fingerprint/FaceID
        // (Assuming you have a biometricService class. If not, just use local_auth here)
        final isHardwareSupported =
            true; // Replace with: await biometricService.isHardwareSupported();

        if (!hasOptedOut && !hasEnabled && isHardwareSupported) {
          // Hardware hai, par abhi tak na enable kiya hai, na mana kiya hai.
          // Bhejo setup screen par!
          emit(AuthBiometricSetupRequired());
        } else {
          // Ya toh phone purana hai, ya user pehle mana kar chuka hai.
          // Seedha Dashboard bhej do!
          emit(AuthAuthenticated());
        }
      } catch (e) {
        emit(AuthError(message: _handleError(e)));
        emit(AuthMpinSetupRequired(otpAccessToken: event.otpAccessToken));
      }
    });

    // ---------------------------------------------------------
    // NEW: HANDLE "DO IT LATER"
    // ---------------------------------------------------------
    on<AuthSkipBiometricSetup>((event, emit) async {
      emit(AuthLoading()); // Thodi der spinner dikhao
      // Flag save karo taaki zindagi mein dobara ye screen na aaye
      await secureStorage.setBiometricOptOut(true);
      emit(AuthAuthenticated()); // Chalo Dashboard!
    });

    // ---------------------------------------------------------
    // NEW: HANDLE "ENABLE BIOMETRIC"
    // ---------------------------------------------------------
    on<AuthEnableBiometricSetup>((event, emit) async {
      // Logic: Biometric success UI handle karega (taaki green tick animation chal sake).
      // BLoC ko bas flag save karna hai.
      emit(AuthLoading());
      await secureStorage.setBiometricEnabled(true);
      emit(AuthAuthenticated());
    });

    // ---------------------------------------------------------
    // 5. LOGIN WITH MPIN (Returning User)
    // ---------------------------------------------------------
    on<AuthLoginMpin>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.loginMpin(event.email, event.mpin);
        // 🚨 SDE3 INTERCEPTION: Dashboard bhejne se pehle check karo 🚨
        final hasOptedOut = await secureStorage.hasBiometricOptedOut();
        final hasEnabled = await secureStorage.isBiometricEnabled();

        // Use your biometric service to check if phone has fingerprint/FaceID
        // (Assuming you have a biometricService class. If not, just use local_auth here)
        final isHardwareSupported =
            true; // Replace with: await biometricService.isHardwareSupported();

        if (!hasOptedOut && !hasEnabled && isHardwareSupported) {
          // Hardware hai, par abhi tak na enable kiya hai, na mana kiya hai.
          // Bhejo setup screen par!
          emit(AuthBiometricSetupRequired());
        } else {
          // Ya toh phone purana hai, ya user pehle mana kar chuka hai.
          // Seedha Dashboard bhej do!
          emit(AuthAuthenticated());
        }
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
