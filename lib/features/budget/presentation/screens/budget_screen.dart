import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../cubit/savings_goal_cubit.dart';
import '../cubit/savings_goal_state.dart';
import '../widgets/budget_progress_card.dart';
import '../widgets/goal_progress_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.budgetsTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.budgetsTab),
              Tab(text: l10n.goalsTab),
            ],
          ),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final currency = (userState is UserLoaded && userState.user != null)
                ? userState.user!.preferredCurrencyCode
                : 'USD';

            return ResponsiveCenteredView(
              child: TabBarView(
                children: [
                  // Tab 1: Budgets List
                  BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, txState) {
                      return BlocBuilder<BudgetCubit, BudgetState>(
                        builder: (context, budgetState) {
                          if (budgetState.isLoading) {
                            return const LoadingIndicator();
                          }

                          if (budgetState.budgets.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmptyState(
                                  title: l10n.noBudgetsTitle,
                                  description: l10n.noBudgetsDesc,
                                  icon: Icons.pie_chart_outline,
                                ),
                                SizedBox(height: 16.0.h),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push('/budgets/add');
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.addBudgetCta),
                                ),
                              ],
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async {
                              final bCubit = context.read<BudgetCubit>();
                              final txCubit = context.read<TransactionCubit>();
                              await bCubit.loadBudgets();
                              await txCubit.loadTransactions();
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.0.r),
                              itemCount: budgetState.budgets.length,
                              itemBuilder: (context, index) {
                                final b = budgetState.budgets[index];
                                return BudgetProgressCard(
                                  budget: b,
                                  transactions: txState.allTransactions,
                                  onTap: () {
                                    context.push('/budgets/edit/${b.id}');
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Tab 2: Savings Goals List
                  BlocBuilder<SavingsGoalCubit, SavingsGoalState>(
                    builder: (context, goalState) {
                      if (goalState.isLoading) {
                        return const LoadingIndicator();
                      }

                      if (goalState.goals.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EmptyState(
                              title: l10n.noGoalsTitle,
                              description: l10n.noGoalsDesc,
                              icon: Icons.savings_outlined,
                            ),
                            SizedBox(height: 16.0.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.push('/goals/add');
                              },
                              icon: const Icon(Icons.add),
                              label: Text(l10n.addGoalCta),
                            ),
                          ],
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          final gCubit = context.read<SavingsGoalCubit>();
                          await gCubit.loadGoals();
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.0.r),
                          itemCount: goalState.goals.length,
                          itemBuilder: (context, index) {
                            final g = goalState.goals[index];
                            return GoalProgressCard(
                              goal: g,
                              currency: currency,
                              onTap: () {
                                context.push('/goals/edit/${g.id}');
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;
                if (tabIndex == 0) {
                  context.push('/budgets/add');
                } else {
                  context.push('/goals/add');
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
