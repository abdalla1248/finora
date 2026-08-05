import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/savings_goal.dart';
import '../cubit/savings_goal_cubit.dart';

class GoalProgressCard extends StatelessWidget {
  final SavingsGoal goal;
  final String currency;
  final VoidCallback? onTap;

  const GoalProgressCard({
    super.key,
    required this.goal,
    required this.currency,
    this.onTap,
  });

  void _showDepositDialog(BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.contributeGoalTitle),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.depositAmountLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              final deposit = double.tryParse(controller.text.trim());
              if (deposit != null && deposit > 0) {
                Navigator.of(dialogContext).pop();
                final updated = goal.copyWith(
                  currentAmount: goal.currentAmount + deposit,
                  updatedAt: DateTime.now(),
                );
                context.read<SavingsGoalCubit>().updateGoal(updated);
              }
            },
            child: Text(l10n.contributeButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Calculate remaining days using calendar dates only
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final deadlineDate = DateTime(goal.deadline.year, goal.deadline.month, goal.deadline.day);
    final remainingDays = deadlineDate.difference(todayDate).inDays;

    final progressPercent = (goal.targetAmount > 0)
        ? (goal.currentAmount / goal.targetAmount * 100.0)
        : 0.0;
    final percentage = (progressPercent / 100.0).clamp(0.0, 1.0);
    final isCompleted = goal.isCompleted || percentage >= 1.0;
    final isExpired = remainingDays < 0 && !isCompleted;

    String deadlineStatusText;
    if (isCompleted) {
      deadlineStatusText = l10n.goalStatusCompleted;
    } else if (isExpired) {
      deadlineStatusText = l10n.goalStatusExpired;
    } else if (remainingDays == 0) {
      deadlineStatusText = l10n.goalStatusToday;
    } else if (remainingDays == 1) {
      deadlineStatusText = l10n.goalStatusTomorrow;
    } else {
      deadlineStatusText = l10n.goalStatusDaysLeft(remainingDays.toString());
    }

    final remainingAmount = (goal.targetAmount - goal.currentAmount).clamp(0.0, double.infinity);

    final titleStyle = isExpired
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0.sp,
              color: Theme.of(context).colorScheme.outline,
              decoration: TextDecoration.lineThrough,
            )
        : Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0.sp,
            );

    final deadlineColor = isExpired
        ? Theme.of(context).colorScheme.error
        : (isCompleted ? const Color(0xFF10B981) : Theme.of(context).colorScheme.outline);

    return Card(
      margin: EdgeInsets.only(bottom: 12.0.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0.r),
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0.r,
                    backgroundColor: isCompleted
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : (isExpired
                            ? Theme.of(context).colorScheme.errorContainer
                            : Theme.of(context).colorScheme.primaryContainer),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : (isExpired ? Icons.warning_amber_rounded : Icons.savings),
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : (isExpired
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onPrimaryContainer),
                      size: 20.0.r,
                    ),
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: titleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Deadline: ${DateFormat.yMMMd().format(goal.deadline)} ($deadlineStatusText)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: deadlineColor,
                                fontSize: 12.0.sp,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0.w),
                  Text(
                    '${progressPercent.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0.sp,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : (isExpired ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0.h),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0.r),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 8.0.h,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted
                        ? const Color(0xFF10B981)
                        : (isExpired
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              SizedBox(height: 16.0.h),

              // Labeled Values section (Using Wrap to avoid overlays/overflows)
              Wrap(
                spacing: 12.0.w,
                runSpacing: 8.0.h,
                children: [
                  Text(
                    l10n.savedAmountLabel('$currency ${goal.currentAmount.toStringAsFixed(2)}'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.0.sp),
                  ),
                  Text(
                    l10n.remainingLabel('$currency ${remainingAmount.toStringAsFixed(2)}'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.0.sp),
                  ),
                  Text(
                    l10n.targetLabel('$currency ${goal.targetAmount.toStringAsFixed(2)}'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0.h),

              // Actions Wrap
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8.0.w,
                  runSpacing: 8.0.h,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (!isCompleted)
                      TextButton.icon(
                        onPressed: () {
                          final updated = goal.copyWith(
                            isCompleted: true,
                            currentAmount: goal.targetAmount,
                            updatedAt: DateTime.now(),
                          );
                          context.read<SavingsGoalCubit>().updateGoal(updated);
                        },
                        icon: Icon(Icons.check_circle_outline, size: 16.0.r, color: const Color(0xFF10B981)),
                        label: Text(
                          l10n.markAsCompleted,
                          style: TextStyle(fontSize: 12.0.sp, color: const Color(0xFF10B981)),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () => _showDepositDialog(context, l10n),
                      icon: Icon(Icons.add_circle_outline, size: 16.0.r),
                      label: Text(
                        l10n.contributeButton,
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
