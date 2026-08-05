import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../core/tutorial/domain/entities/tutorial_step.dart';
import '../../../../core/tutorial/presentation/cubit/tutorial_cubit.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../budget/presentation/cubit/budget_cubit.dart';
import '../../../budget/presentation/cubit/budget_state.dart';
import '../../../budget/presentation/widgets/budget_progress_card.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_state.dart';
import '../../../transaction/presentation/widgets/transaction_card.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey _welcomeHeaderKey = GlobalKey();
  final GlobalKey _netBalanceKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final txColors = Theme.of(context).extension<TransactionColors>();
    final incomeColor = txColors?.income ?? FinoraColorSchemes.incomeGreen;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final user = (userState is UserLoaded) ? userState.user : null;
          final userName = user != null ? user.name : 'User';
          final currency = user != null ? user.preferredCurrencyCode : 'USD';
          final imagePath = user?.profileImagePath;
          final imageFile = imagePath != null ? File(imagePath) : null;
          final hasValidImage = imageFile != null && imageFile.existsSync();

          return BlocListener<TransactionCubit, TransactionState>(
            listener: (context, state) {
              context.read<AccountCubit>().loadAccounts();
            },
            child: BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, txState) {
                final transactions = txState.allTransactions;

                // Calculate Monthly Stats
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
                      children: [
                        // User Welcome Header
                        Card(
                          key: _welcomeHeaderKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28.0,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  backgroundImage: hasValidImage ? FileImage(imageFile) : null,
                                  child: !hasValidImage
                                      ? Text(
                                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.dashboardWelcome(userName),
                                      style: Theme.of(context).textTheme.titleLarge
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      l10n.primaryCurrencyHeader(currency),
                                      style: Theme.of(context).textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Financial Overview Summary Cards - Adaptive Layout
                      if (context.isMobile) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: l10n.totalIncomeLabel,
                                amount:
                                    '$currency ${totalIncome.toStringAsFixed(2)}',
                                color: incomeColor,
                                icon: Icons.arrow_downward,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: _StatCard(
                                title: l10n.totalExpenseLabel,
                                amount:
                                    '$currency ${totalExpense.toStringAsFixed(2)}',
                                color: Theme.of(context).colorScheme.error,
                                icon: Icons.arrow_upward,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        _StatCard(
                          key: _netBalanceKey,
                          title: l10n.netBalanceLabel,
                          amount: '$currency ${netBalance.toStringAsFixed(2)}',
                          color: netBalance >= 0
                              ? incomeColor
                              : Theme.of(context).colorScheme.error,
                          icon: Icons.account_balance_wallet,
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: l10n.totalIncomeLabel,
                                amount:
                                    '$currency ${totalIncome.toStringAsFixed(2)}',
                                color: incomeColor,
                                icon: Icons.arrow_downward,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: _StatCard(
                                title: l10n.totalExpenseLabel,
                                amount:
                                    '$currency ${totalExpense.toStringAsFixed(2)}',
                                color: Theme.of(context).colorScheme.error,
                                icon: Icons.arrow_upward,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: _StatCard(
                                title: l10n.netBalanceLabel,
                                amount:
                                    '$currency ${netBalance.toStringAsFixed(2)}',
                                color: netBalance >= 0
                                    ? incomeColor
                                    : Theme.of(context).colorScheme.error,
                                icon: Icons.account_balance_wallet,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24.0),

                      // Budget Preview Section
                      BlocBuilder<BudgetCubit, BudgetState>(
                        builder: (context, budgetState) {
                          if (budgetState.budgets.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final activeBudget = budgetState.budgets.first;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.activeBudgetPreviewTitle,
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.go('/budgets');
                                    },
                                    child: Text(l10n.viewAllButton),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              BudgetProgressCard(
                                budget: activeBudget,
                                transactions: transactions,
                                onTap: () => context.go('/budgets'),
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          );
                        },
                      ),

                      // Recent Transactions Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.recentTransactionsTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
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

                      // Transactions List or Empty State
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
                        ...transactions
                            .take(5)
                            .map(
                              (tx) => TransactionCard(
                                transaction: tx,
                                onTap: () {
                                  context.push('/transactions/details/${tx.id}');
                                },
                              ),
                            ),
                      ],
                    ],
                  ),
                ),
              );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {
          context.push('/transactions/add');
        },
        child: const Icon(Icons.add),
      ),
    );
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
