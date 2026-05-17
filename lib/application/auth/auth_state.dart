import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthUnauthenticated extends AuthState {}

/// 4. OTP Sent (Show OTP Verification Screen)
final class AuthOtpSent extends AuthState {
  final String email; 
  
  const AuthOtpSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// 5. OTP Verified -> Show Create MPIN Screen
final class AuthMpinSetupRequired extends AuthState {
  // SDE3 Catch: Tera setupMpin API otpAccessToken maangta hai. 
  // Isliye State ko ye token UI tak carry karna padega, taaki UI wapas isko Event mein bhej sake.
  final String otpAccessToken; 
  
  const AuthMpinSetupRequired({required this.otpAccessToken});

  @override
  List<Object?> get props => [otpAccessToken];
}

/// 6. Returning User -> Show Enter MPIN Screen
final class AuthMpinRequired extends AuthState {
  final bool showBiometricPrompt;
  // SDE3 Catch: Tera loginMpin API ko 'email' chahiye. 
  // Isliye ye state email carry karegi taaki UI ko pata ho kis email ke liye MPIN daalna hai.
  final String email; 
  
  const AuthMpinRequired({
    required this.showBiometricPrompt, 
    required this.email,
  });

  @override
  List<Object?> get props => [showBiometricPrompt, email];
}

/// 7. Success! (Navigate to Dashboard)
final class AuthAuthenticated extends AuthState {}

/// 8. Something went wrong (Show Snackbar/Dialog)
final class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}