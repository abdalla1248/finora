import 'package:equatable/equatable.dart';

enum BudgetType {
  daily,
  weekly,
  monthly,
  yearly,
  custom;

  String get nameString => name;
}

enum BudgetAlertLevel {
  green, // 0 - 70%
  yellow, // 70 - 90%
  red, // 90 - 100%
  exceeded, // 100%+
}

class Budget extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final BudgetType budgetType;
  final double amount;
  final String currencyCode;
  final DateTime startDate;
  final DateTime endDate;
  final double alertThreshold;
  final String? colorHex;
  final String? iconData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  const Budget({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.budgetType,
    required this.amount,
    required this.currencyCode,
    required this.startDate,
    required this.endDate,
    this.alertThreshold = 0.8,
    this.colorHex,
    this.iconData,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  BudgetAlertLevel getAlertLevel(double spentAmount) {
    if (amount <= 0) return BudgetAlertLevel.green;
    final ratio = spentAmount / amount;
    if (ratio >= 1.0) return BudgetAlertLevel.exceeded;
    if (ratio >= 0.9) return BudgetAlertLevel.red;
    if (ratio >= 0.7) return BudgetAlertLevel.yellow;
    return BudgetAlertLevel.green;
  }

  Budget copyWith({
    String? id,
    String? name,
    String? categoryId,
    BudgetType? budgetType,
    double? amount,
    String? currencyCode,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
    String? colorHex,
    String? iconData,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      budgetType: budgetType ?? this.budgetType,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      colorHex: colorHex ?? this.colorHex,
      iconData: iconData ?? this.iconData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    categoryId,
    budgetType,
    amount,
    currencyCode,
    startDate,
    endDate,
    alertThreshold,
    colorHex,
    iconData,
    createdAt,
    updatedAt,
    isArchived,
  ];
}
