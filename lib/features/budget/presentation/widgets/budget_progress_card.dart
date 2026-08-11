import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../transaction/domain/entities/category.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/budget.dart';

class BudgetProgressCard extends StatelessWidget {
  final Budget budget;
  final List<Transaction> transactions;
  final VoidCallback? onTap;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    required this.transactions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final category = CategoryRegistry.getCategoryById(budget.categoryId);

    final endOfDay = DateTime(
      budget.endDate.year,
      budget.endDate.month,
      budget.endDate.day,
      23,
      59,
      59,
      999,
    );

    // Calculate actual spending for this budget category & date range
    final spentAmount = transactions
        .where(
          (t) =>
              t.transactionType == TransactionType.expense &&
              (t.categoryId == budget.categoryId ||
                  budget.categoryId == 'all') &&
              !t.transactionDate.isBefore(budget.startDate) &&
              !t.transactionDate.isAfter(endOfDay),
        )
        .fold(0.0, (sum, t) => sum + t.amount);

    final alertLevel = budget.getAlertLevel(spentAmount);
    final remainingAmount = budget.amount - spentAmount;
    final percentage = budget.amount > 0
        ? (spentAmount / budget.amount).clamp(0.0, 1.0)
        : 0.0;

    Color progressColor;
    String statusBadge;
    switch (alertLevel) {
      case BudgetAlertLevel.green:
        progressColor = const Color(0xFF10B981);
        statusBadge = l10n.statusOnTrack;
        break;
      case BudgetAlertLevel.yellow:
        progressColor = const Color(0xFFF59E0B);
        statusBadge = l10n.statusWarning;
        break;
      case BudgetAlertLevel.red:
        progressColor = const Color(0xFFEF4444);
        statusBadge = l10n.statusCritical;
        break;
      case BudgetAlertLevel.exceeded:
        progressColor = const Color(0xFFB91C1C);
        statusBadge = l10n.statusExceeded;
        break;
    }

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
                    backgroundColor: category.color.withValues(alpha: 0.15),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 20.0.r,
                    ),
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0.sp,
                                decoration: spentAmount >= budget.amount
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                        Text(
                          budget.budgetType
                              .getLocalizedName(context)
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 12.0.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 4.0.h,
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6.0.r),
                    ),
                    child: Text(
                      statusBadge,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
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
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              SizedBox(height: 12.0.h),

              // Budget Details Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.spentLabel(
                        formatCurrency(spentAmount, budget.currencyCode, context),
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12.0.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      l10n.remainingLabel(
                        formatCurrency(
                          remainingAmount,
                          budget.currencyCode,
                          context,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0.sp,
                        color: remainingAmount < 0
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
