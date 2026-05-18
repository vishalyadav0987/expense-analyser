class ApiEndpoints {
  // Base URL (In production, this comes from .env file)
  // static const String baseUrl = 'http://192.168.1.10:8080/api/v1';  // ## Home 1
  // static const String baseUrl = 'http://169.254.4.189:8080/api/v1';  // ## Home 2
  static const String baseUrl =
      'http://169.254.133.199:8080/api/v1'; // ## office

  // Auth Routes
  static const String requestOtp = '$baseUrl/auth/request-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String setupMpin = '$baseUrl/auth/set-mpin';
  static const String loginMpin = '$baseUrl/auth/mpin-login';
  static const String biometricLogin = '$baseUrl/auth/biometric-login';

  // Initial Routes
  static const String initialSetup = '$baseUrl/user/setup';

  // Expense Routes
  static const String createExpense = '$baseUrl/expense/create-expense';
  static const String getCategories = '$baseUrl/expense/categories';
  static const String createCategory = '$baseUrl/expense/create-category';

  // Dashboard
  static const String dashboardSummary = '$baseUrl/dashboard/summary';

  // Analyzer Routes
  static const String weeklyAnalyzer = '$baseUrl/analyzer/weekly';
}
