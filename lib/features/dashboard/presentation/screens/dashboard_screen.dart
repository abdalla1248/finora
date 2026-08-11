import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../core/tutorial/domain/entities/tutorial_step.dart';
import '../../../../core/tutorial/presentation/cubit/tutorial_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../../budget/presentation/cubit/budget_cubit.dart';
import '../../../budget/presentation/cubit/budget_state.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../widgets/dashboard_accounts_section.dart';
import '../widgets/dashboard_budgets_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_overview_section.dart';
import '../widgets/dashboard_recent_transactions_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey _welcomeHeaderKey = GlobalKey();
  final GlobalKey _accountsSectionKey = GlobalKey();
  final GlobalKey _netBalanceKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  late final ScrollController _scrollController;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      context.read<TutorialCubit>().startTutorial(
        tutorialId: 'dashboard_tutorial',
        steps: [
          TutorialStep(
            targetKey: _welcomeHeaderKey,
            title: l10n.tutorialWelcomeTitle,
            description: l10n.tutorialWelcomeDesc,
          ),
          TutorialStep(
            targetKey: _accountsSectionKey,
            title: l10n.tutorialAccountsTitle,
            description: l10n.tutorialAccountsDesc,
          ),
          TutorialStep(
            targetKey: _netBalanceKey,
            title: l10n.tutorialOverviewTitle,
            description: l10n.tutorialOverviewDesc,
          ),
          TutorialStep(
            targetKey: _fabKey,
            title: l10n.tutorialFabTitle,
            description: l10n.tutorialFabDesc,
          ),
        ],
      );
    });
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() {
          _showFab = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final user = (userState is UserLoaded) ? userState.user : null;
          final currency = user != null ? user.preferredCurrencyCode : 'USD';

          return BlocListener<TransactionCubit, TransactionState>(
            listener: (context, state) {
              context.read<AccountCubit>().loadAccounts();
            },
            child: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, txState) {
                final transactions = txState.allTransactions;

                final now = DateTime.now();
                final thisMonthTx = transactions.where(
                  (t) =>
                      t.transactionDate.year == now.year &&
                      t.transactionDate.month == now.month,
                );

                final totalIncome = thisMonthTx
                    .where((t) => t.transactionType == TransactionType.income)
                    .fold(0.0, (sum, t) => sum + t.amount);

                final totalExpense = thisMonthTx
                    .where((t) => t.transactionType == TransactionType.expense)
                    .fold(0.0, (sum, t) => sum + t.amount);

                final netBalance = totalIncome - totalExpense;

                return ResponsiveCenteredView(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final txCubit = context.read<TransactionCubit>();
                      final accCubit = context.read<AccountCubit>();
                      await txCubit.loadTransactions();
                      await accCubit.loadAccounts();
                    },
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        DashboardHeader(
                          welcomeHeaderKey: _welcomeHeaderKey,
                          user: user,
                        ),
                        const SizedBox(height: 16.0),
                        DashboardOverviewSection(
                          netBalanceKey: _netBalanceKey,
                          totalIncome: totalIncome,
                          totalExpense: totalExpense,
                          netBalance: netBalance,
                          currency: currency,
                        ),
                        const SizedBox(height: 24.0),
                        BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, accountState) {
                            return DashboardAccountsSection(
                              accountsSectionKey: _accountsSectionKey,
                              accounts: accountState.accounts,
                            );
                          },
                        ),
                        BlocBuilder<BudgetCubit, BudgetState>(
                          builder: (context, budgetState) {
                            return DashboardBudgetsSection(
                              budgets: budgetState.budgets,
                              transactions: transactions,
                            );
                          },
                        ),
                        DashboardRecentTransactionsSection(
                          transactions: transactions,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          key: _fabKey,
          onPressed: () {
            context.push('/transactions/add');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
