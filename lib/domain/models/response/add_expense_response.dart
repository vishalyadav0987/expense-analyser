class AddExpenseResponse {
  final bool success;
  final String message;
  final AddExpenseData? data;

  AddExpenseResponse({required this.success, required this.message, this.data});

  factory AddExpenseResponse.fromJson(Map<String, dynamic> json) {
    return AddExpenseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AddExpenseData.fromJson(json['data']) : null,
    );
  }
}

class AddExpenseData {
  final String transactionId;
  final TransactionRes? transaction;
  final LimitWarningRes? limitWarning; // 🚨 This can be null if under budget

  AddExpenseData({
    required this.transactionId,
    this.transaction,
    this.limitWarning,
  });

  factory AddExpenseData.fromJson(Map<String, dynamic> json) {
    return AddExpenseData(
      transactionId: json['transactionId'] ?? '',
      transaction: json['transaction'] != null
          ? TransactionRes.fromJson(json['transaction'])
          : null,
      limitWarning: json['limitWarning'] != null
          ? LimitWarningRes.fromJson(json['limitWarning'])
          : null,
    );
  }
}

class LimitWarningRes {
  final String categoryType;
  final double limit;
  final double spentThisWeek;
  final String message;

  LimitWarningRes({
    required this.categoryType,
    required this.limit,
    required this.spentThisWeek,
    required this.message,
  });

  factory LimitWarningRes.fromJson(Map<String, dynamic> json) {
    return LimitWarningRes(
      categoryType: json['categoryType'] ?? '',
      limit: (json['limit'] as num?)?.toDouble() ?? 0.0,
      spentThisWeek: (json['spentThisWeek'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] ?? '',
    );
  }
}

class TransactionRes {
  final String transactionId;
  final double amount;
  final String categoryId;
  final String description;
  final String paymentMode;
  final String date;
  final String createdAt;

  TransactionRes({
    required this.transactionId,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.paymentMode,
    required this.date,
    required this.createdAt,
  });

  factory TransactionRes.fromJson(Map<String, dynamic> json) {
    return TransactionRes(
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] ?? '',
      description: json['description'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      date: json['date'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
