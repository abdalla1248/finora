import 'package:hive/hive.dart';
import '../../domain/entities/savings_goal.dart';

part 'savings_goal_model.g.dart';

@HiveType(typeId: 3)
class SavingsGoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double currentAmount;

  @HiveField(4)
  final DateTime deadline;

  @HiveField(5)
  final String? colorHex;

  @HiveField(6)
  final String? iconData;

  @HiveField(7)
  final String notes;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  @HiveField(10)
  final bool isCompleted;

  @HiveField(11)
  final double? allocatedAmount;

  @HiveField(12)
  final String? linkedAccountId;

  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.colorHex,
    this.iconData,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
    this.allocatedAmount,
    this.linkedAccountId,
  });

  factory SavingsGoalModel.fromEntity(SavingsGoal entity) {
    return SavingsGoalModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      currentAmount: entity.allocatedAmount,
      deadline: entity.deadline,
      colorHex: entity.colorHex,
      iconData: entity.iconData,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isCompleted: entity.isCompleted,
      allocatedAmount: entity.allocatedAmount,
      linkedAccountId: entity.linkedAccountId,
    );
  }

  SavingsGoal toEntity() {
    final effectiveAllocated = allocatedAmount ?? currentAmount;
    return SavingsGoal(
      id: id,
      title: title,
      targetAmount: targetAmount,
      allocatedAmount: effectiveAllocated,
      linkedAccountId: linkedAccountId,
      deadline: deadline,
      colorHex: colorHex,
      iconData: iconData,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isCompleted: isCompleted,
    );
  }
}
