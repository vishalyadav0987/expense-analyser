class AddExpenseRequest {
  final double amount;
  final String categoryId;
  final String description;
  final String paymentMode;
  final DateTime date;

  AddExpenseRequest({
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.paymentMode,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "categoryId": categoryId,
        "description": description,
        "paymentMode": paymentMode,
        "date": date.toUtc().toIso8601String(), // SDE3: Always send UTC to backend!
      };
}