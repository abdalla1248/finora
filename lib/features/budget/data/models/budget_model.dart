import 'package:hive/hive.dart';
import '../../domain/entities/budget.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String budgetType;

  @HiveField(4)
  final double amount;

  @HiveField(5)
  final String currencyCode;

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime endDate;

  @HiveField(8)
  final double alertThreshold;

  @HiveField(9)
  final String? colorHex;

  @HiveField(10)
  final String? iconData;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final bool isArchived;

  BudgetModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.budgetType,
    required this.amount,
    required this.currencyCode,
    required this.startDate,
    required this.endDate,
    required this.alertThreshold,
    this.colorHex,
    this.iconData,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
  });

  factory BudgetModel.fromEntity(Budget entity) {
    return BudgetModel(
      id: entity.id,
      name: entity.name,
      categoryId: entity.categoryId,
      budgetType: entity.budgetType.name,
      amount: entity.amount,
      currencyCode: entity.currencyCode,
      startDate: entity.startDate,
      endDate: entity.endDate,
      alertThreshold: entity.alertThreshold,
      colorHex: entity.colorHex,
      iconData: entity.iconData,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isArchived: entity.isArchived,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      name: name,
      categoryId: categoryId,
      budgetType: BudgetType.values.firstWhere(
        (b) => b.name == budgetType,
        orElse: () => BudgetType.monthly,
      ),
      amount: amount,
      currencyCode: currencyCode,
      startDate: startDate,
      endDate: endDate,
      alertThreshold: alertThreshold,
      colorHex: colorHex,
      iconData: iconData,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isArchived: isArchived,
    );
  }
}
