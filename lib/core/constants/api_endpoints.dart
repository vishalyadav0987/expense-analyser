class ApiEndpoints {
  // Base URL (In production, this comes from .env file)
  static const String baseUrl = 'http://169.254.4.189:8080/api/v1';

  // Auth Routes
  static const String requestOtp = '$baseUrl/auth/request-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String setupMpin = '$baseUrl/auth/set-mpin';
  static const String loginMpin = '$baseUrl/auth/mpin-login';
  static const String biometricLogin = '$baseUrl/auth/biometric-login';

  // Initial Setup
  static const String initialSetup = '$baseUrl/user/setup';

  // Expense Routes
  static const String expenses = '$baseUrl/expenses';

  // Analyzer Routes
  static const String weeklyAnalyzer = '$baseUrl/analyzer/weekly';
}
