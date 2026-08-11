import 'package:equatable/equatable.dart';

enum SavingsGoalStatus {
  active,
  completed,
  overdue;

  String get nameString => name;
}

class SavingsGoal extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double allocatedAmount;
  final String? linkedAccountId;
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
    this.allocatedAmount = 0.0,
    this.linkedAccountId,
    required this.deadline,
    this.colorHex,
    this.iconData,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
    this.isCompleted = false,
  });

  /// Alias for backward compatibility
  double get currentAmount => allocatedAmount;

  /// Progress percentage strictly clamped between 0 and 100%
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    final ratio = (allocatedAmount / targetAmount) * 100.0;
    return ratio.clamp(0.0, 100.0);
  }

  /// Remaining amount toward target (never negative)
  double get remainingAmount {
    final rem = targetAmount - allocatedAmount;
    return rem < 0 ? 0.0 : rem;
  }

  /// Whether the goal is completed either by explicit flag or allocation
  bool get isGoalCompleted => isCompleted || (targetAmount > 0 && allocatedAmount >= targetAmount);

  /// Whether the goal is overdue (deadline in past and not completed)
  bool get isExpired {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineDate.isBefore(todayDate) && !isGoalCompleted;
  }

  /// Priority status: Completed -> Overdue -> Active
  SavingsGoalStatus get status {
    if (isGoalCompleted) return SavingsGoalStatus.completed;
    if (isExpired) return SavingsGoalStatus.overdue;
    return SavingsGoalStatus.active;
  }

  SavingsGoal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? allocatedAmount,
    double? currentAmount,
    String? linkedAccountId,
    DateTime? deadline,
    String? colorHex,
    String? iconData,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    final effectiveAllocated = allocatedAmount ?? currentAmount ?? this.allocatedAmount;
    final effectiveTarget = targetAmount ?? this.targetAmount;
    final effectiveIsCompleted = isCompleted ??
        (effectiveTarget > 0 ? effectiveAllocated >= effectiveTarget : this.isCompleted);

    return SavingsGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: effectiveTarget,
      allocatedAmount: effectiveAllocated,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      deadline: deadline ?? this.deadline,
      colorHex: colorHex ?? this.colorHex,
      iconData: iconData ?? this.iconData,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: effectiveIsCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    targetAmount,
    allocatedAmount,
    linkedAccountId,
    deadline,
    colorHex,
    iconData,
    notes,
    createdAt,
    updatedAt,
    isCompleted,
  ];
}
