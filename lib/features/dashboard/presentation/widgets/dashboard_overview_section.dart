import 'package:flutter/material.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardOverviewSection extends StatelessWidget {
  final GlobalKey netBalanceKey;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final String currency;

  const DashboardOverviewSection({
    super.key,
    required this.netBalanceKey,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final incomeColor = context.semanticColors.income;

    if (context.isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: l10n.totalIncomeLabel,
                  amount: formatCurrency(
                    totalIncome,
                    currency,
                    context,
                  ),
                  color: incomeColor,
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _StatCard(
                  title: l10n.totalExpenseLabel,
                  amount: formatCurrency(
                    totalExpense,
                    currency,
                    context,
                  ),
                  color: context.semanticColors.expense,
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _StatCard(
            key: netBalanceKey,
            title: l10n.netBalanceLabel,
            amount: formatCurrency(
              netBalance,
              currency,
              context,
            ),
            color: netBalance >= 0 ? incomeColor : context.semanticColors.expense,
            icon: Icons.account_balance_wallet,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _StatCard(
              title: l10n.totalIncomeLabel,
              amount: formatCurrency(
                totalIncome,
                currency,
                context,
              ),
              color: incomeColor,
              icon: Icons.arrow_downward,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: _StatCard(
              title: l10n.totalExpenseLabel,
              amount: formatCurrency(
                totalExpense,
                currency,
                context,
              ),
              color: context.semanticColors.expense,
              icon: Icons.arrow_upward,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: _StatCard(
              key: netBalanceKey,
              title: l10n.netBalanceLabel,
              amount: formatCurrency(
                netBalance,
                currency,
                context,
              ),
              color: netBalance >= 0 ? incomeColor : context.semanticColors.expense,
              icon: Icons.account_balance_wallet,
            ),
          ),
        ],
      );
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
      color: context.semanticColors.dashboardCard,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20.0),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    amount,
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
          ],
        ),
      ),
    );
  }
}
