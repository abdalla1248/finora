import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../transaction/domain/entities/category.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/account.dart';

class AccountAnalyticsTab extends StatelessWidget {
  final String accountId;
  final Account account;
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpense;

  const AccountAnalyticsTab({
    super.key,
    required this.accountId,
    required this.account,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (transactions.isEmpty) {
      return EmptyState(
        title: l10n.noTransactionsFound,
        description: l10n.dashboardEmptyDesc,
        icon: Icons.analytics_outlined,
      );
    }

    final now = DateTime.now();
    final monthlySpending = transactions.where((t) {
      final isSource = t.accountId == accountId;
      final isExpense = t.transactionType == TransactionType.expense ||
          t.transactionType == TransactionType.transfer;
      final isThisMonth = t.transactionDate.year == now.year &&
          t.transactionDate.month == now.month;
      return isSource && isExpense && isThisMonth;
    }).fold(0.0, (sum, t) => sum + t.amount);

    final totalExpensesAllTime = transactions.where((t) {
      final isSource = t.accountId == accountId;
      final isExpense = t.transactionType == TransactionType.expense ||
          t.transactionType == TransactionType.transfer;
      return isSource && isExpense;
    }).fold(0.0, (sum, t) => sum + t.amount);

    final activeDays = now.difference(account.createdAt).inDays;
    final days = activeDays <= 0 ? 1 : activeDays;
    final averageDailySpending = totalExpensesAllTime / days;

    final largestTx = transactions.isEmpty
        ? null
        : transactions.reduce((a, b) => a.amount > b.amount ? a : b);

    final categoryTotals = <String, double>{};
    double totalCategoryExpenses = 0.0;

    for (final t in transactions) {
      final isSource = t.accountId == accountId;
      if (isSource &&
          (t.transactionType == TransactionType.expense ||
              t.transactionType == TransactionType.transfer)) {
        final categoryId = t.categoryId;
        categoryTotals[categoryId] =
            (categoryTotals[categoryId] ?? 0.0) + t.amount;
        totalCategoryExpenses += t.amount;
      }
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final incomeExpenseTotal = totalIncome + totalExpense;
    final incomeRatio =
        incomeExpenseTotal > 0 ? totalIncome / incomeExpenseTotal : 0.5;
    final expenseRatio =
        incomeExpenseTotal > 0 ? totalExpense / incomeExpenseTotal : 0.5;

    return ListView(
      padding: EdgeInsets.all(16.0.r),
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.monthlySpendLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11.0.sp),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        formatCurrency(
                            monthlySpending, account.currencyCode, context),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0.sp,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0.w),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyAvgSpendLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11.0.sp),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        formatCurrency(averageDailySpending,
                            account.currencyCode, context),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0.sp,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0.w),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.largestTxLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11.0.sp),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        largestTx != null
                            ? formatCurrency(largestTx.amount,
                                largestTx.currencyCode, context)
                            : 'N/A',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0.sp,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cashFlowBreakdownLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                ),
                SizedBox(height: 16.0.h),
                Row(
                  children: [
                    Expanded(
                      flex: (incomeRatio * 100).round().clamp(1, 99),
                      child: Container(
                        height: 8.0.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.horizontal(
                            left: const Radius.circular(4.0),
                            right:
                                Radius.circular(expenseRatio == 0 ? 4.0 : 0.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: (expenseRatio * 100).round().clamp(1, 99),
                      child: Container(
                        height: 8.0.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.horizontal(
                            right: const Radius.circular(4.0),
                            left: Radius.circular(incomeRatio == 0 ? 4.0 : 0.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 8.0.w,
                            height: 8.0.h,
                            color: const Color(0xFF10B981)),
                        SizedBox(width: 4.0.w),
                        Text(
                          '${l10n.incomeLabel}: ${(incomeRatio * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            width: 8.0.w,
                            height: 8.0.h,
                            color: Theme.of(context).colorScheme.error),
                        SizedBox(width: 4.0.w),
                        Text(
                          '${l10n.expensesLabel}: ${(expenseRatio * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0.h),
        Text(
          l10n.expensesByCategoryLabel,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
        ),
        SizedBox(height: 8.0.h),
        if (sortedCategories.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Center(
                child: Text(
                  l10n.noExpenseRecordsLabel,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 14.0.sp),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8.0.r),
              itemCount: sortedCategories.length,
              itemBuilder: (context, index) {
                final entry = sortedCategories[index];
                final category = CategoryRegistry.getCategoryById(entry.key);
                final localizedName = category.getLocalizedName(l10n);
                final catExpenseRatio = totalCategoryExpenses > 0
                    ? entry.value / totalCategoryExpenses
                    : 0.0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.color.withValues(alpha: 0.15),
                    child: Icon(category.icon,
                        color: category.color, size: 20.0.r),
                  ),
                  title:
                      Text(localizedName, style: TextStyle(fontSize: 14.0.sp)),
                  subtitle: ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child: LinearProgressIndicator(
                      value: catExpenseRatio,
                      minHeight: 4.0.h,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(category.color),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(catExpenseRatio * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                      ),
                      Text(
                        entry.value.toStringAsFixed(2),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 11.0.sp),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
