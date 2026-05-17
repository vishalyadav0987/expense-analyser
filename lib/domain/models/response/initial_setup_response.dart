class InitialSetupResponse {
  final bool success;
  final String message;
  final InitialSetupData? data;

  InitialSetupResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory InitialSetupResponse.fromJson(Map<String, dynamic> json) {
    return InitialSetupResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? InitialSetupData.fromJson(json['data'])
          : null,
    );
  }
}

class InitialSetupData {
  final FinancialInfoRes? financialInfo;
  final List<SavedCategoryRes> savedCategories;
  final List<SavedPaymentMethodRes> savedPaymentMethods;
  final SmartRulesRes? smartRules;
  final SetupUserRes? user;

  InitialSetupData({
    this.financialInfo,
    required this.savedCategories,
    required this.savedPaymentMethods,
    this.smartRules,
    this.user,
  });

  factory InitialSetupData.fromJson(Map<String, dynamic> json) {
    return InitialSetupData(
      financialInfo: json['financialInfo'] != null
          ? FinancialInfoRes.fromJson(json['financialInfo'])
          : null,
      savedCategories:
          (json['savedCategories'] as List<dynamic>?)
              ?.map((e) => SavedCategoryRes.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      savedPaymentMethods:
          (json['savedPaymentMethods'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SavedPaymentMethodRes.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      smartRules: json['smartRules'] != null
          ? SmartRulesRes.fromJson(json['smartRules'])
          : null,
      user: json['user'] != null ? SetupUserRes.fromJson(json['user']) : null,
    );
  }
}

class FinancialInfoRes {
  final double monthlySalary;
  final double yearlyHikePercentage;
  final double xxWeeklyLimit;

  FinancialInfoRes({
    required this.monthlySalary,
    required this.yearlyHikePercentage,
    required this.xxWeeklyLimit,
  });

  factory FinancialInfoRes.fromJson(Map<String, dynamic> json) {
    return FinancialInfoRes(
      monthlySalary: (json['MonthlySalary'] as num?)?.toDouble() ?? 0.0,
      yearlyHikePercentage:
          (json['YearlyHikePercentage'] as num?)?.toDouble() ?? 0.0,
      xxWeeklyLimit: (json['XXWeeklyLimit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SavedCategoryRes {
  final String id;
  final String userId;
  final String name;
  final String type;

  SavedCategoryRes({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
  });

  factory SavedCategoryRes.fromJson(Map<String, dynamic> json) {
    return SavedCategoryRes(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      name: json['Name'] ?? '',
      type: json['Type'] ?? '',
    );
  }
}

class SavedPaymentMethodRes {
  final String id;
  final String userId;
  final String methodName;
  final double weeklyLimit;
  final bool isActive;

  SavedPaymentMethodRes({
    required this.id,
    required this.userId,
    required this.methodName,
    required this.weeklyLimit,
    required this.isActive,
  });

  factory SavedPaymentMethodRes.fromJson(Map<String, dynamic> json) {
    return SavedPaymentMethodRes(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      methodName: json['MethodName'] ?? '',
      weeklyLimit: (json['WeeklyLimit'] as num?)?.toDouble() ?? 0.0,
      isActive: json['IsActive'] ?? false,
    );
  }
}

class SmartRulesRes {
  final int needsPercentage;
  final int wantsPercentage;
  final int savingsPercentage;

  SmartRulesRes({
    required this.needsPercentage,
    required this.wantsPercentage,
    required this.savingsPercentage,
  });

  factory SmartRulesRes.fromJson(Map<String, dynamic> json) {
    return SmartRulesRes(
      needsPercentage: (json['NeedsPercentage'] as num?)?.toInt() ?? 0,
      wantsPercentage: (json['WantsPercentage'] as num?)?.toInt() ?? 0,
      savingsPercentage: (json['SavingsPercentage'] as num?)?.toInt() ?? 0,
    );
  }
}

class SetupUserRes {
  final String id;
  final bool setupCompleted;

  SetupUserRes({required this.id, required this.setupCompleted});

  factory SetupUserRes.fromJson(Map<String, dynamic> json) {
    return SetupUserRes(
      id: json['id'] ?? '',
      setupCompleted: json['setupCompleted'] ?? false,
    );
  }
}
