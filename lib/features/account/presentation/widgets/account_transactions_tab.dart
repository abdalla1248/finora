import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/widgets/transaction_card.dart';

class AccountTransactionsTab extends StatelessWidget {
  final List<Transaction> transactions;

  const AccountTransactionsTab({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
}
