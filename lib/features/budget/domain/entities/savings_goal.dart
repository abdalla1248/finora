import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String? colorHex;
  final String? iconData;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.deadline,
    this.colorHex,
    this.iconData,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = false,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    final ratio = currentAmount / targetAmount;
    return ratio > 1.0 ? 100.0 : ratio * 100.0;
  }

  SavingsGoal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? colorHex,
    String? iconData,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      colorHex: colorHex ?? this.colorHex,
      iconData: iconData ?? this.iconData,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted:
          isCompleted ??
          (currentAmount != null && targetAmount != null
              ? (currentAmount >= targetAmount)
              : this.isCompleted),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    targetAmount,
    currentAmount,
    deadline,
    colorHex,
    iconData,
    notes,
    createdAt,
    updatedAt,
    isCompleted,
  ];
}
