abstract class AuthRepository {
  Future<void> requestOtp(String email, String password);
  Future<String> verifyOtp(
    String email,
    String otp,
  ); // Returns true if setup is complete
  Future<void> setupMpin(String mpin, String otpAccessToken);
  Future<void> loginMpin(String email, String mpin);
  Future<void> biometricLogin();
  Future<void> logout();
}
