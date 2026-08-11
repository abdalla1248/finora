import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../budget/domain/services/goal_allocation_service.dart';
import '../../../budget/presentation/cubit/savings_goal_cubit.dart';
import '../../../budget/presentation/cubit/savings_goal_state.dart';
import '../../domain/entities/account.dart';
import '../utils/account_presentation_extensions.dart';

class AccountOverviewTab extends StatelessWidget {
  final Account account;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final int txCount;
  final String lastActivity;

  const AccountOverviewTab({
    super.key,
    required this.account,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.txCount,
    required this.lastActivity,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = account.currencyCode;
    final accountColor = account.getThemeColor(context);

    return ListView(
      padding: EdgeInsets.all(16.0.r),
      children: [
        Card(
          color: accountColor.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28.0.r,
                  backgroundColor: accountColor.withValues(alpha: 0.15),
                  child: Icon(
                    account.icon,
                    color: accountColor,
                    size: 28.0.r,
                  ),
                ),
                SizedBox(height: 12.0.h),
                Text(
                  l10n.currentBalanceLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(height: 8.0.h),
                Text(
                  formatCurrency(account.balance, currency, context),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0.sp,
                        color: accountColor,
                      ),
                ),
                SizedBox(height: 16.0.h),
                BlocBuilder<SavingsGoalCubit, SavingsGoalState>(
                  builder: (context, goalState) {
                    final allocated = GoalAllocationService.calculateTotalAllocatedForAccount(
                      account.id,
                      goalState.goals,
                      isDefaultAccount: account.isDefault,
                    );
                    final available = GoalAllocationService.calculateUnallocatedBalance(
                      account,
                      goalState.goals,
                    );

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Allocated',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11.0.sp),
                              ),
                              SizedBox(height: 4.0.h),
                              Text(
                                formatCurrency(allocated, currency, context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0.sp,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 24.0.h,
                            width: 1.0,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          ),
                          Column(
                            children: [
                              Text(
                                'Available',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11.0.sp),
                              ),
                              SizedBox(height: 4.0.h),
                              Text(
                                formatCurrency(available, currency, context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0.sp,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
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
                          Text(l10n.incomeLabel, style: TextStyle(fontSize: 12.0.sp)),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      Text(
                        formatCurrency(totalIncome, currency, context),
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
                          Text(l10n.expensesLabel, style: TextStyle(fontSize: 12.0.sp)),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      Text(
                        formatCurrency(totalExpense, currency, context),
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
                  title: Text(l10n.netCashFlowLabel),
                  trailing: Text(
                    formatCurrency(netBalance, currency, context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0.sp,
                      color: netBalance >= 0 ? const Color(0xFF10B981) : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.tag),
                  title: Text(l10n.totalTransactionsLabel),
                  trailing: Text(
                    '$txCount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(l10n.creationDateLabel),
                  trailing: Text(
                    DateFormat.yMMMd().format(account.createdAt),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0.sp),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(l10n.lastActivityLabel),
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
}
