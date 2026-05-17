class InitialSetupRequest {
  final FinancialsReq financials;
  final SmartRulesReq smartRules;
  final List<CategoryReq> categories;
  final List<PaymentMethodReq> paymentMethods;

  InitialSetupRequest({
    required this.financials,
    required this.smartRules,
    required this.categories,
    required this.paymentMethods,
  });

  Map<String, dynamic> toJson() => {
    "financials": financials.toJson(),
    "smartRules": smartRules.toJson(),
    "categories": categories.map((e) => e.toJson()).toList(),
    "paymentMethods": paymentMethods.map((e) => e.toJson()).toList(),
  };
}

class FinancialsReq {
  final double monthlySalary;
  final double yearlyHikePercentage;
  final double xxWeeklyLimit;

  FinancialsReq({
    required this.monthlySalary,
    required this.yearlyHikePercentage,
    required this.xxWeeklyLimit,
  });

  Map<String, dynamic> toJson() => {
    "monthlySalary": monthlySalary,
    "yearlyHikePercentage": yearlyHikePercentage,
    "xxWeeklyLimit": xxWeeklyLimit,
  };
}

class SmartRulesReq {
  final int needsPercentage;
  final int wantsPercentage;
  final int savingsPercentage;

  SmartRulesReq({
    required this.needsPercentage,
    required this.wantsPercentage,
    required this.savingsPercentage,
  });

  Map<String, dynamic> toJson() => {
    "needsPercentage": needsPercentage,
    "wantsPercentage": wantsPercentage,
    "savingsPercentage": savingsPercentage,
  };
}

class CategoryReq {
  final String name;
  final String type;

  CategoryReq({required this.name, required this.type});

  Map<String, dynamic> toJson() => {"name": name, "type": type};
}

class PaymentMethodReq {
  final String methodName;
  final double weeklyLimit;
  final bool isActive;

  PaymentMethodReq({
    required this.methodName,
    required this.weeklyLimit,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    "methodName": methodName,
    "weeklyLimit": weeklyLimit,
    "isActive": isActive,
  };
}
