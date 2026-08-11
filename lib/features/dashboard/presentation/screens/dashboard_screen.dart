import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_breakpoints.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../core/tutorial/domain/entities/tutorial_step.dart';
import '../../../../core/tutorial/presentation/cubit/tutorial_cubit.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../account/domain/entities/account.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../../budget/domain/entities/budget.dart';
import '../../../budget/presentation/cubit/budget_cubit.dart';
import '../../../budget/presentation/cubit/budget_state.dart';
import '../../../transaction/domain/entities/category.dart';
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
    final incomeColor = context.semanticColors.income;

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
                final recentTransactions = List<Transaction>.from(transactions)
                  ..sort(
                    (a, b) => b.transactionDate.compareTo(a.transactionDate),
                  );

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
                      controller: _scrollController,
                      children: [
                        // User Welcome Header
                        Card(
                          key: _welcomeHeaderKey,
                          elevation: 2.0,
                          shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28.0,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  backgroundImage: hasValidImage
                                      ? FileImage(imageFile)
                                      : null,
                                  child: !hasValidImage
                                      ? Text(
                                          userName.isNotEmpty
                                              ? userName[0].toUpperCase()
                                              : 'U',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.dashboardWelcome(userName),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        l10n.primaryCurrencyHeader(currency),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
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
                            key: _netBalanceKey,
                            title: l10n.netBalanceLabel,
                            amount: formatCurrency(
                              netBalance,
                              currency,
                              context,
                            ),
                            color: netBalance >= 0
                                ? incomeColor
                                : context.semanticColors.expense,
                            icon: Icons.account_balance_wallet,
                          ),
                        ] else ...[
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
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: _StatCard(
                                  title: l10n.netBalanceLabel,
                                  amount: formatCurrency(
                                    netBalance,
                                    currency,
                                    context,
                                  ),
                                  color: netBalance >= 0
                                      ? incomeColor
                                      : context.semanticColors.expense,
                                  icon: Icons.account_balance_wallet,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24.0),

                        // Accounts Section
                        BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, accountState) {
                            final accounts = accountState.accounts;
                            if (accounts.isEmpty)
                              return const SizedBox.shrink();
                            return Column(
                              key: _accountsSectionKey,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.accountsTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.push('/accounts');
                                      },
                                      child: Text(l10n.viewAllButton),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 85.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: accounts.length,
                                    itemBuilder: (context, index) {
                                      final account = accounts[index];
                                      final color = account.colorHex != null
                                          ? FinoraColorSchemes.parseHexColor(
                                              account.colorHex!,
                                            )
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary;
                                      return Card(
                                        elevation: 2.0,
                                        shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                              end: 12.0,
                                            ),
                                        child: InkWell(
                                          onTap: () => context.push(
                                            '/accounts/details/${account.id}',
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 12.0,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircleAvatar(
                                                  radius: 18.0,
                                                  backgroundColor: color
                                                      .withValues(alpha: 0.15),
                                                  child: Icon(
                                                    _getAccountIcon(
                                                      account.iconData,
                                                      account.type,
                                                    ),
                                                    color: color,
                                                    size: 18.0,
                                                  ),
                                                ),
                                                const SizedBox(width: 12.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          account.name,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        if (account
                                                            .isDefault) ...[
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            size: 12.0,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .tertiary,
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      formatCurrency(
                                                        account.balance,
                                                        account.currencyCode,
                                                        context,
                                                      ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .outline,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                              ],
                            );
                          },
                        ),

                        // Budget Preview Section
                        BlocBuilder<BudgetCubit, BudgetState>(
                          builder: (context, budgetState) {
                            final now = DateTime.now();
                            final activeBudgets = budgetState.budgets.where((
                              b,
                            ) {
                              final endOfDay = DateTime(
                                b.endDate.year,
                                b.endDate.month,
                                b.endDate.day,
                                23,
                                59,
                                59,
                                999,
                              );
                              return !now.isBefore(b.startDate) &&
                                  !now.isAfter(endOfDay);
                            }).toList();

                            if (activeBudgets.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.activeBudgetPreviewTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.go('/budgets');
                                      },
                                      child: Text(l10n.viewAllButton),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0.h),
                                SizedBox(
                                  height: 125.0.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: activeBudgets.length,
                                    itemBuilder: (context, index) {
                                      final budget = activeBudgets[index];
                                      final category =
                                          CategoryRegistry.getCategoryById(
                                            budget.categoryId,
                                          );

                                      // Calculate actual spending
                                      final endOfDay = DateTime(
                                        budget.endDate.year,
                                        budget.endDate.month,
                                        budget.endDate.day,
                                        23,
                                        59,
                                        59,
                                        999,
                                      );
                                      final spentAmount = transactions
                                          .where(
                                            (t) =>
                                                t.transactionType ==
                                                    TransactionType.expense &&
                                                (t.categoryId ==
                                                        budget.categoryId ||
                                                    budget.categoryId ==
                                                        'all') &&
                                                !t.transactionDate.isBefore(
                                                  budget.startDate,
                                                ) &&
                                                !t.transactionDate.isAfter(
                                                  endOfDay,
                                                ),
                                          )
                                          .fold(
                                            0.0,
                                            (sum, t) => sum + t.amount,
                                          );

                                      final alertLevel = budget.getAlertLevel(
                                        spentAmount,
                                      );
                                      final percentage = budget.amount > 0
                                          ? (spentAmount / budget.amount).clamp(
                                              0.0,
                                              1.0,
                                            )
                                          : 0.0;

                                      Color progressColor;
                                      switch (alertLevel) {
                                        case BudgetAlertLevel.green:
                                          progressColor = const Color(
                                            0xFF10B981,
                                          );
                                          break;
                                        case BudgetAlertLevel.yellow:
                                          progressColor = const Color(
                                            0xFFF59E0B,
                                          );
                                          break;
                                        case BudgetAlertLevel.red:
                                          progressColor = const Color(
                                            0xFFEF4444,
                                          );
                                          break;
                                        case BudgetAlertLevel.exceeded:
                                          progressColor = const Color(
                                            0xFFB91C1C,
                                          );
                                          break;
                                      }

                                      return Container(
                                        width: 250.0.w,
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                              end: 12.0,
                                            ),
                                        child: Card(
                                          elevation: 2.0,
                                          shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                                          margin: EdgeInsets.zero,
                                          child: InkWell(
                                            onTap: () => context.go('/budgets'),
                                            borderRadius: BorderRadius.circular(
                                              12.0.r,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0.r),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 16.0.r,
                                                        backgroundColor:
                                                            category.color
                                                                .withValues(
                                                                  alpha: 0.15,
                                                                ),
                                                        child: Icon(
                                                          category.icon,
                                                          color: category.color,
                                                          size: 16.0.r,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.0.w),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              budget.name,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0.sp,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              budget.budgetType
                                                                  .getLocalizedName(
                                                                    context,
                                                                  )
                                                                  .toUpperCase(),
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: Theme.of(
                                                                      context,
                                                                    ).colorScheme.outline,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        '${(percentage * 100).toStringAsFixed(0)}%',
                                                        style: TextStyle(
                                                          fontSize: 11.0.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: progressColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4.0.r,
                                                            ),
                                                        child: LinearProgressIndicator(
                                                          value: percentage,
                                                          minHeight: 6.0.h,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surfaceContainerHighest,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(progressColor),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.0.h),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              l10n.spentLabel(
                                                                formatCurrency(
                                                                  spentAmount,
                                                                  budget
                                                                      .currencyCode,
                                                                  context,
                                                                ),
                                                              ),
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    fontSize:
                                                                        10.0.sp,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8.0),
                                                          Flexible(
                                                            child: Text(
                                                              formatCurrency(
                                                                budget.amount,
                                                                budget
                                                                    .currencyCode,
                                                                context,
                                                              ),
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10.0.sp,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                          ...recentTransactions
                              .take(5)
                              .map(
                                (tx) => TransactionCard(
                                  transaction: tx,
                                  onTap: () {
                                    context.push(
                                      '/transactions/details/${tx.id}',
                                    );
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

  IconData _getAccountIcon(String? iconName, AccountType type) {
    if (iconName != null) {
      switch (iconName) {
        case 'wallet':
          return Icons.account_balance_wallet;
        case 'savings':
          return Icons.savings_outlined;
        case 'bank':
          return Icons.account_balance;
        case 'cash':
          return Icons.money;
        case 'card':
          return Icons.credit_card;
        case 'investment':
          return Icons.trending_up;
      }
    }
    switch (type) {
      case AccountType.cash:
        return Icons.money;
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.wallet:
        return Icons.account_balance_wallet;
      case AccountType.business:
        return Icons.business;
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
