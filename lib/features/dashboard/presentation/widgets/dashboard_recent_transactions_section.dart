import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/widgets/transaction_card.dart';

class DashboardRecentTransactionsSection extends StatelessWidget {
  final List<Transaction> transactions;

  const DashboardRecentTransactionsSection({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recentTransactions = List<Transaction>.from(transactions)
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentTransactionsTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (transactions.isNotEmpty)
              TextButton(
                onPressed: () {
                  context.push('/transactions/add');
                },
                child: Text(l10n.addTransactionTitle),
              ),
          ],
        ),
        const SizedBox(height: 8.0),
        if (transactions.isEmpty) ...[
          EmptyState(
            title: l10n.dashboardEmptyTitle,
            description: l10n.dashboardEmptyDesc,
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/transactions/add');
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addTransactionCta),
            ),
          ),
        ] else ...[
          ...recentTransactions.take(5).map(
                (tx) => TransactionCard(
                  transaction: tx,
                  onTap: () {
                    context.push('/transactions/details/${tx.id}');
                  },
                ),
              ),
        ],
      ],
    );
  }
}
