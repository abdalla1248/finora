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
    final remainingDays = goal.deadline.difference(DateTime.now()).inDays;
    final percentage = (goal.progressPercentage / 100.0).clamp(0.0, 1.0);
    final isCompleted = goal.isCompleted || percentage >= 1.0;

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
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.savings,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : Theme.of(context).colorScheme.onPrimaryContainer,
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                        ),
                        Text(
                          'Deadline: ${DateFormat.yMMMd().format(goal.deadline)} (${remainingDays > 0 ? "$remainingDays days left" : "Passed"})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 12.0.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${goal.progressPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0.sp,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : Theme.of(context).colorScheme.primary,
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
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 12.0.h),

              // Goal Details Row & Deposit Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved: $currency ${goal.currentAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.0.sp),
                  ),
                  Text(
                    'Target: $currency ${goal.targetAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0.sp,
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
            ],
          ),
        ),
      ),
    );
  }
}
