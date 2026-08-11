import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/currency_formatter.dart';

class AnalyticsSummaryCards extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netCashFlow;
  final double savingsRate;
  final String currency;

  const AnalyticsSummaryCards({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netCashFlow,
    required this.savingsRate,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: l10n.totalIncomeLabel,
                value: formatCurrency(totalIncome, currency, context),
                icon: Icons.arrow_downward,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _SummaryCard(
                title: l10n.totalExpenseLabel,
                value: formatCurrency(totalExpense, currency, context),
                icon: Icons.arrow_upward,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: l10n.netBalanceLabel,
                value: formatCurrency(netCashFlow, currency, context),
                icon: Icons.account_balance_wallet,
                color: netCashFlow >= 0
                    ? const Color(0xFF10B981)
                    : Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _SummaryCard(
                title: l10n.savingsRateLabel,
                value: '${savingsRate.toStringAsFixed(1)}%',
                icon: Icons.savings,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14.0,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 16.0),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
