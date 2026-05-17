import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// 1. Fired by App Startup
final class AuthAppStarted extends AuthEvent {
  const AuthAppStarted();
}

/// 2. Fired when user taps "Send OTP"
final class AuthRequestOtp extends AuthEvent {
  final String email;
  final String password; // Updated based on your API

  const AuthRequestOtp({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// 3. Fired when user taps "Verify"
final class AuthVerifyOtp extends AuthEvent {
  final String email;
  final String otp;

  const AuthVerifyOtp({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

/// 4. Fired when new user sets up their MPIN
final class AuthSetupMpin extends AuthEvent {
  final String mpin;
  final String otpAccessToken; // Updated based on your API

  const AuthSetupMpin({required this.mpin, required this.otpAccessToken});

  @override
  List<Object?> get props => [mpin, otpAccessToken];
}

/// 5. Fired when existing user logs in with MPIN
final class AuthLoginMpin extends AuthEvent {
  final String email; // Updated based on your API
  final String mpin;

  const AuthLoginMpin({required this.email, required this.mpin});

  @override
  List<Object?> get props => [email, mpin];
}

/// 6. Fired for Biometric trigger
final class AuthBiometricLoginRequested extends AuthEvent {
  const AuthBiometricLoginRequested();
}

/// 7. Fired for Logout
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Fired when user taps "Do it later"
final class AuthSkipBiometricSetup extends AuthEvent {
  const AuthSkipBiometricSetup();
}

/// Fired when user taps "Enable" and successfully scans fingerprint
final class AuthEnableBiometricSetup extends AuthEvent {
  const AuthEnableBiometricSetup();
}
