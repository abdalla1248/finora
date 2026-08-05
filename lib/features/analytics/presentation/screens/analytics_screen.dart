import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/analytics_empty_state.dart';
import '../widgets/analytics_summary_cards.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/financial_insights_card.dart';
import '../widgets/income_expense_bar_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAnalytics();
    });
  }

  void _refreshAnalytics() {
    final txs = context.read<TransactionCubit>().state.allTransactions;
    final userState = context.read<UserCubit>().state;
    final currency = (userState is UserLoaded && userState.user != null)
        ? userState.user!.preferredCurrencyCode
        : 'USD';
    context.read<AnalyticsCubit>().computeAnalytics(
          txs,
          currencyCode: currency,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.analyticsTitle)),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final currency = (userState is UserLoaded && userState.user != null)
              ? userState.user!.preferredCurrencyCode
              : 'USD';

          return BlocListener<TransactionCubit, TransactionState>(
            listener: (context, txState) {
              context.read<AnalyticsCubit>().computeAnalytics(
                    txState.allTransactions,
                    currencyCode: currency,
                  );
            },
            child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
              builder: (context, analyticsState) {
                final txs =
                    context.watch<TransactionCubit>().state.allTransactions;

                if (txs.isEmpty) {
                  return const AnalyticsEmptyState();
                }

                return ResponsiveCenteredView(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final txCubit = context.read<TransactionCubit>();
                      await txCubit.loadTransactions();
                      _refreshAnalytics();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                      // Period Selection Dropdown
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.dateLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              DropdownButton<AnalyticsPeriod>(
                                value: analyticsState.period,
                                underline: const SizedBox.shrink(),
                                items: [
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.today,
                                    child: Text(l10n.periodToday),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.yesterday,
                                    child: Text(l10n.periodYesterday),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.thisWeek,
                                    child: Text(l10n.periodThisWeek),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.thisMonth,
                                    child: Text(l10n.periodThisMonth),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.lastMonth,
                                    child: Text(l10n.periodLastMonth),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.thisYear,
                                    child: Text(l10n.periodThisYear),
                                  ),
                                  DropdownMenuItem(
                                    value: AnalyticsPeriod.allTime,
                                    child: Text(l10n.periodAllTime),
                                  ),
                                ],
                                onChanged: (period) {
                                  if (period != null) {
                                    context.read<AnalyticsCubit>().setPeriod(
                                          period,
                                          txs,
                                          currencyCode: currency,
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Financial Summary Cards
                      AnalyticsSummaryCards(
                        totalIncome: analyticsState.totalIncome,
                        totalExpense: analyticsState.totalExpense,
                        netCashFlow: analyticsState.netCashFlow,
                        savingsRate: analyticsState.savingsRate,
                        currency: currency,
                      ),
                      const SizedBox(height: 16.0),

                      // Charts: Side-by-Side on Tablet/Desktop, Stacked on Mobile
                      if (context.isMobile) ...[
                        IncomeExpenseBarChart(
                          totalIncome: analyticsState.totalIncome,
                          totalExpense: analyticsState.totalExpense,
                          currency: currency,
                        ),
                        const SizedBox(height: 16.0),
                        CategoryPieChart(
                          categoryExpenses: analyticsState.categoryExpenses,
                          currency: currency,
                        ),
                      ] else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: IncomeExpenseBarChart(
                                totalIncome: analyticsState.totalIncome,
                                totalExpense: analyticsState.totalExpense,
                                currency: currency,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: CategoryPieChart(
                                categoryExpenses: analyticsState.categoryExpenses,
                                currency: currency,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16.0),

                      // Financial Insights Card
                      FinancialInsightsCard(insights: analyticsState.insights),
                    ],
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }
}
