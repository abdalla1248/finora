import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../widgets/account_analytics_tab.dart';
import '../widgets/account_overview_tab.dart';
import '../widgets/account_transactions_tab.dart';

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
            appBar: AppBar(title: Text(l10n.accountDetailsTitle)),
            body: ErrorState(message: l10n.accountNotFoundError),
          );
        }

        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, txState) {
            final accountTransactions = txState.allTransactions.where((t) {
              final isSource = t.accountId == accountId;
              final isTarget = t.transactionType == TransactionType.transfer &&
                  _extractTargetAccountFromNote(t.note) == accountId;
              return isSource || isTarget;
            }).toList();

            accountTransactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

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
                : l10n.noTransactionsFound;

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
                      AccountOverviewTab(
                        account: account,
                        totalIncome: totalIncome,
                        totalExpense: totalExpense,
                        netBalance: netBalance,
                        txCount: accountTransactions.length,
                        lastActivity: lastActivity,
                      ),
                      AccountTransactionsTab(
                        transactions: accountTransactions,
                      ),
                      AccountAnalyticsTab(
                        accountId: accountId,
                        account: account,
                        transactions: accountTransactions,
                        totalIncome: totalIncome,
                        totalExpense: totalExpense,
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
}
