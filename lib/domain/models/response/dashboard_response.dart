import 'dart:convert';

class DashboardData {
  final TopCard topCard;
  final int financialScore;
  final RuleProgress ruleProgress;
  final List<RecentTransaction> recentTransactions;

  DashboardData({
    required this.topCard,
    required this.financialScore,
    required this.ruleProgress,
    required this.recentTransactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      topCard: TopCard.fromJson(json['topCard'] ?? {}),
      financialScore: json['financialScore'] ?? 0,
      ruleProgress: RuleProgress.fromJson(json['ruleProgress'] ?? {}),
      recentTransactions:
          (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => RecentTransaction.fromJson(e))
              .toList() ??
          [],
    );
  }

  // SDE3: Needed to save raw JSON string to SQLite
  String toJsonString() => jsonEncode({
    'topCard': topCard.toJson(),
    'financialScore': financialScore,
    'ruleProgress': ruleProgress.toJson(),
    'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
  });
}

class TopCard {
  final double totalSalary;
  final double budgetPending;
  final double savingTarget;
  final double currentSavingRate;

  TopCard({
    required this.totalSalary,
    required this.budgetPending,
    required this.savingTarget,
    required this.currentSavingRate,
  });

  factory TopCard.fromJson(Map<String, dynamic> json) => TopCard(
    totalSalary: (json['totalSalary'] ?? 0.0).toDouble(),
    budgetPending: (json['budgetPending'] ?? 0.0).toDouble(),
    savingTarget: (json['savingTarget'] ?? 0.0).toDouble(),
    currentSavingRate: (json['currentSavingRate'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'totalSalary': totalSalary,
    'budgetPending': budgetPending,
    'savingTarget': savingTarget,
    'currentSavingRate': currentSavingRate,
  };
}

class RuleProgress {
  final CategoryProgress needs;
  final CategoryProgress wants;
  final SavingsProgress savings;

  RuleProgress({
    required this.needs,
    required this.wants,
    required this.savings,
  });

  factory RuleProgress.fromJson(Map<String, dynamic> json) => RuleProgress(
    needs: CategoryProgress.fromJson(json['needs'] ?? {}),
    wants: CategoryProgress.fromJson(json['wants'] ?? {}),
    savings: SavingsProgress.fromJson(json['savings'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'needs': needs.toJson(),
    'wants': wants.toJson(),
    'savings': savings.toJson(),
  };
}

class CategoryProgress {
  final double spent;
  final double limit;
  final double percentageConsumed;

  CategoryProgress({
    required this.spent,
    required this.limit,
    required this.percentageConsumed,
  });

  factory CategoryProgress.fromJson(Map<String, dynamic> json) =>
      CategoryProgress(
        spent: (json['spent'] ?? 0.0).toDouble(),
        limit: (json['limit'] ?? 0.0).toDouble(),
        percentageConsumed: (json['percentageConsumed'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'spent': spent,
    'limit': limit,
    'percentageConsumed': percentageConsumed,
  };
}

class SavingsProgress {
  final double invested;
  final double target;
  final double percentageAchieved;

  SavingsProgress({
    required this.invested,
    required this.target,
    required this.percentageAchieved,
  });

  factory SavingsProgress.fromJson(Map<String, dynamic> json) =>
      SavingsProgress(
        invested: (json['invested'] ?? 0.0).toDouble(),
        target: (json['target'] ?? 0.0).toDouble(),
        percentageAchieved: (json['percentageAchieved'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'invested': invested,
    'target': target,
    'percentageAchieved': percentageAchieved,
  };
}

class RecentTransaction {
  final String id;
  final DateTime date;
  final String description;
  final String category;
  final double amount;
  final String paymentMode;
  final String type;

  RecentTransaction({
    required this.id,
    required this.date,
    required this.description,
    required this.category,
    required this.amount,
    required this.paymentMode,
    required this.type,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
        id: json['id'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        amount: (json['amount'] ?? 0.0).toDouble(),
        paymentMode: json['paymentMode'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'description': description,
    'category': category,
    'amount': amount,
    'paymentMode': paymentMode,
    'type': type,
  };
}
