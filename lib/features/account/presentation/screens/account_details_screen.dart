import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../../../transaction/presentation/widgets/transaction_card.dart';
import '../../../transaction/domain/entities/category.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';

class AccountDetailsScreen extends StatelessWidget {
  final String accountId;

  const AccountDetailsScreen({super.key, required this.accountId});

  String? _extractTargetAccountFromNote(String note) {
    final match = RegExp(r'TargetAccount:([^\s]+)').firstMatch(note);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, accountState) {
        final account = accountState.accounts.where((a) => a.id == accountId).firstOrNull;
        if (account == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Account Details')),
            body: const ErrorState(message: 'Account not found'),
          );
        }

        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, txState) {
            // Find all transactions that involve this account (either source or target of transfer)
            final accountTransactions = txState.allTransactions.where((t) {
              final isSource = t.accountId == accountId;
              final isTarget = t.transactionType == TransactionType.transfer &&
                  _extractTargetAccountFromNote(t.note) == accountId;
              return isSource || isTarget;
            }).toList();

            // Sort transactions by date descending
            accountTransactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

            // Calculate overview statistics
            double totalIncome = 0.0;
            double totalExpense = 0.0;

            for (final t in accountTransactions) {
              final isSource = t.accountId == accountId;
              final isTarget = t.transactionType == TransactionType.transfer &&
                  _extractTargetAccountFromNote(t.note) == accountId;

              if (isTarget) {
                totalIncome += t.amount;
              } else if (isSource) {
                if (t.transactionType == TransactionType.income) {
                  totalIncome += t.amount;
                } else if (t.transactionType == TransactionType.expense ||
                    t.transactionType == TransactionType.transfer) {
                  totalExpense += t.amount;
                }
              }
            }

            final netBalance = totalIncome - totalExpense;
            final lastActivity = accountTransactions.isNotEmpty
                ? DateFormat.yMMMd().add_jm().format(accountTransactions.first.transactionDate)
                : l10n.noTransactionsFound; // fallback string

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(account.name),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => context.push('/accounts/edit/$accountId'),
                    ),
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(text: l10n.overviewTab),
                      Tab(text: l10n.transactionsTab),
                      Tab(text: l10n.analyticsTab),
                    ],
                  ),
                ),
                body: ResponsiveCenteredView(
                  child: TabBarView(
                    children: [
                      // Overview Tab
                      _buildOverviewTab(
                        context,
                        account,
                        totalIncome,
                        totalExpense,
                        netBalance,
                        accountTransactions.length,
                        lastActivity,
                        l10n,
                      ),
                      // Transactions Tab
                      _buildTransactionsTab(
                        context,
                        accountTransactions,
                        l10n,
                      ),
                      // Analytics Tab
                      _buildAnalyticsTab(
                        context,
                        accountTransactions,
                        totalIncome,
                        totalExpense,
                        l10n,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    dynamic account,
    double totalIncome,
    double totalExpense,
    double netBalance,
    int txCount,
    String lastActivity,
    AppLocalizations l10n,
  ) {
    final currency = account.currencyCode;
    return ListView(
      padding: EdgeInsets.all(16.0.r),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                Text(
                  'Current Balance',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(height: 8.0.h),
                Text(
                  '$currency ${account.balance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0.h),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_downward, color: const Color(0xFF10B981), size: 18.0.r),
                          SizedBox(width: 4.0.w),
                          Text('Income', style: TextStyle(fontSize: 12.0.sp)),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      Text(
                        '$currency ${totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0.w),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Theme.of(context).colorScheme.error, size: 18.0.r),
                          SizedBox(width: 4.0.w),
                          Text('Expenses', style: TextStyle(fontSize: 12.0.sp)),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      Text(
                        '$currency ${totalExpense.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
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
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.compare_arrows),
                  title: const Text('Net Cash Flow'),
                  trailing: Text(
                    '$currency ${netBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0.sp,
                      color: netBalance >= 0 ? const Color(0xFF10B981) : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const Divider(height: 1.0),
                ListTile(
                  leading: const Icon(Icons.tag),
                  title: const Text('Total Transactions'),
                  trailing: Text(
                    '$txCount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                  ),
                ),
                const Divider(height: 1.0),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Creation Date'),
                  trailing: Text(
                    DateFormat.yMMMd().format(account.createdAt),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                  ),
                ),
                const Divider(height: 1.0),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Last Activity'),
                  trailing: Text(
                    lastActivity,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(
    BuildContext context,
    List<Transaction> transactions,
    AppLocalizations l10n,
  ) {
    if (transactions.isEmpty) {
      return EmptyState(
        title: l10n.noTransactionsFound,
        description: l10n.dashboardEmptyDesc,
        icon: Icons.receipt_long_outlined,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.0.r),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return TransactionCard(
          transaction: tx,
          onTap: () {
            context.push('/transactions/details/${tx.id}');
          },
        );
      },
    );
  }

  Widget _buildAnalyticsTab(
    BuildContext context,
    List<Transaction> transactions,
    double totalIncome,
    double totalExpense,
    AppLocalizations l10n,
  ) {
    if (transactions.isEmpty) {
      return EmptyState(
        title: l10n.noTransactionsFound,
        description: l10n.dashboardEmptyDesc,
        icon: Icons.analytics_outlined,
      );
    }

    // Group expenses by category
    final categoryTotals = <String, double>{};
    double totalCategoryExpenses = 0.0;

    for (final t in transactions) {
      final isSource = t.accountId == accountId;
      if (isSource && (t.transactionType == TransactionType.expense || t.transactionType == TransactionType.transfer)) {
        final categoryId = t.categoryId;
        categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0.0) + t.amount;
        totalCategoryExpenses += t.amount;
      }
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final incomeExpenseTotal = totalIncome + totalExpense;
    final incomeRatio = incomeExpenseTotal > 0 ? totalIncome / incomeExpenseTotal : 0.5;
    final expenseRatio = incomeExpenseTotal > 0 ? totalExpense / incomeExpenseTotal : 0.5;

    return ListView(
      padding: EdgeInsets.all(16.0.r),
      children: [
        // Income vs Expense Ratio Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Flow Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
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
                            right: Radius.circular(expenseRatio == 0 ? 4.0 : 0.0),
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
                        Container(width: 8.0.w, height: 8.0.h, color: const Color(0xFF10B981)),
                        SizedBox(width: 4.0.w),
                        Text(
                          'Income: ${(incomeRatio * 100).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(width: 8.0.w, height: 8.0.h, color: Theme.of(context).colorScheme.error),
                        SizedBox(width: 4.0.w),
                        Text(
                          'Expense: ${(expenseRatio * 100).toStringAsFixed(0)}%',
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

        // Expense by Category Section
        Text(
          'Expenses by Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
        ),
        SizedBox(height: 8.0.h),
        if (sortedCategories.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Center(
                child: Text(
                  'No expense records found for this account.',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 14.0.sp),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8.0.r),
              itemCount: sortedCategories.length,
              separatorBuilder: (context, index) => const Divider(height: 1.0),
              itemBuilder: (context, index) {
                final entry = sortedCategories[index];
                final category = CategoryRegistry.getCategoryById(entry.key);
                final localizedName = category.getLocalizedName(l10n);
                final catExpenseRatio = totalCategoryExpenses > 0 ? entry.value / totalCategoryExpenses : 0.0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.color.withValues(alpha: 0.15),
                    child: Icon(category.icon, color: category.color, size: 20.0.r),
                  ),
                  title: Text(localizedName, style: TextStyle(fontSize: 14.0.sp)),
                  subtitle: ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child: LinearProgressIndicator(
                      value: catExpenseRatio,
                      minHeight: 4.0.h,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(category.color),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(catExpenseRatio * 100).toStringAsFixed(0)}%',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                      ),
                      Text(
                        entry.value.toStringAsFixed(2),
                        style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 11.0.sp),
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
