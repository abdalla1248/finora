import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../account/domain/entities/account.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/delete_transaction_dialog.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  String? _extractTargetAccountFromNote(String note) {
    final match = RegExp(r'TargetAccount:([^\s]+)').firstMatch(note);
    return match?.group(1);
  }

  String _cleanNote(String note) {
    return note.replaceAll(RegExp(r'TargetAccount:[^\s]+'), '').trim();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final txColors = Theme.of(context).extension<TransactionColors>();

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, accountState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            final matches = state.allTransactions.where(
              (t) => t.id == transactionId,
            );
            if (matches.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: Text(l10n.transactionDetailsTitle)),
                body: const ErrorState(
                  message: 'Transaction not found',
                ),
              );
            }

            final tx = matches.first;
            final category = CategoryRegistry.getCategoryById(tx.categoryId);
            final isIncome = tx.transactionType == TransactionType.income;
            final isExpense = tx.transactionType == TransactionType.expense;
            final isTransfer = tx.transactionType == TransactionType.transfer;

            final amountPrefix = isIncome ? '+' : (isExpense ? '-' : '');
            final amountColor = isIncome
                ? (txColors?.income ?? FinoraColorSchemes.incomeGreen)
                : (isExpense
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary);

            // Fetch accounts
            final sourceAccount = accountState.accounts.where((a) => a.id == tx.accountId).firstOrNull;
            final sourceAccountName = sourceAccount?.name ?? tx.accountId;
            final sourceAccountColor = sourceAccount?.colorHex != null
                ? FinoraColorSchemes.parseHexColor(sourceAccount!.colorHex!)
                : Theme.of(context).colorScheme.primary;

            final targetAccountId = _extractTargetAccountFromNote(tx.note);
            final targetAccount = targetAccountId != null
                ? accountState.accounts.where((a) => a.id == targetAccountId).firstOrNull
                : null;
            final targetAccountName = targetAccount?.name ?? targetAccountId ?? '';
            final targetAccountColor = targetAccount?.colorHex != null
                ? FinoraColorSchemes.parseHexColor(targetAccount!.colorHex!)
                : Theme.of(context).colorScheme.primary;

            final cleanedNote = _cleanNote(tx.note);
            final showLastUpdated = tx.updatedAt.difference(tx.createdAt).inSeconds.abs() > 1;

            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.transactionDetailsTitle),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.push('/transactions/edit/${tx.id}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirmed = await DeleteTransactionDialog.show(context);
                      if (confirmed == true && context.mounted) {
                        await context.read<TransactionCubit>().deleteTransaction(
                          tx.id,
                        );
                        if (context.mounted) {
                          context.pop();
                        }
                      }
                    },
                  ),
                ],
              ),
              body: ResponsiveCenteredView(
                child: ListView(
                  padding: EdgeInsets.all(24.0.r),
                  children: [
                    // Amount Overview Banner
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0.r),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32.0.r,
                              backgroundColor: category.color.withValues(alpha: 0.15),
                              child: Icon(
                                category.icon,
                                color: category.color,
                                size: 32.0.r,
                              ),
                            ),
                            SizedBox(height: 16.0.h),
                            Text(
                              tx.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0.sp),
                            ),
                            SizedBox(height: 8.0.h),
                            Text(
                              '$amountPrefix${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: amountColor,
                                    fontSize: 28.0.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0.h),

                    // Property List
                    ListTile(
                      leading: const Icon(Icons.swap_horiz),
                      title: const Text('Transaction Type'),
                      subtitle: Text(tx.transactionType.name.toUpperCase()),
                    ),
                    const Divider(height: 1.0),
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: Text(l10n.categoryLabel),
                      subtitle: Text(category.getLocalizedName(l10n)),
                    ),
                    const Divider(height: 1.0),

                    if (isTransfer) ...[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 16.0.r,
                          backgroundColor: sourceAccountColor.withValues(alpha: 0.15),
                          child: Icon(
                            _getAccountIcon(sourceAccount?.iconData, sourceAccount?.type ?? AccountType.cash),
                            color: sourceAccountColor,
                            size: 16.0.r,
                          ),
                        ),
                        title: const Text('From Account'),
                        subtitle: Text(
                          sourceAccountName,
                          style: TextStyle(
                            color: sourceAccountColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          context.push('/accounts/details/${tx.accountId}');
                        },
                      ),
                      const Divider(height: 1.0),
                      if (targetAccountId != null) ...[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 16.0.r,
                            backgroundColor: targetAccountColor.withValues(alpha: 0.15),
                            child: Icon(
                              _getAccountIcon(targetAccount?.iconData, targetAccount?.type ?? AccountType.cash),
                              color: targetAccountColor,
                              size: 16.0.r,
                            ),
                          ),
                          title: const Text('To Account'),
                          subtitle: Text(
                            targetAccountName,
                            style: TextStyle(
                              color: targetAccountColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            context.push('/accounts/details/$targetAccountId');
                          },
                        ),
                        const Divider(height: 1.0),
                      ],
                    ] else ...[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 16.0.r,
                          backgroundColor: sourceAccountColor.withValues(alpha: 0.15),
                          child: Icon(
                            _getAccountIcon(sourceAccount?.iconData, sourceAccount?.type ?? AccountType.cash),
                            color: sourceAccountColor,
                            size: 16.0.r,
                          ),
                        ),
                        title: const Text('Financial Account'),
                        subtitle: Text(
                          sourceAccountName,
                          style: TextStyle(
                            color: sourceAccountColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          context.push('/accounts/details/${tx.accountId}');
                        },
                      ),
                      const Divider(height: 1.0),
                    ],

                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.dateLabel),
                      subtitle: Text(DateFormat.yMMMMd().format(tx.transactionDate)),
                    ),
                    const Divider(height: 1.0),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text(DateFormat.jm().format(tx.transactionDate)),
                    ),
                    const Divider(height: 1.0),

                    if (cleanedNote.isNotEmpty) ...[
                      ListTile(
                        leading: const Icon(Icons.note),
                        title: Text(l10n.noteLabel),
                        subtitle: Text(cleanedNote),
                      ),
                      const Divider(height: 1.0),
                    ],

                    ListTile(
                      leading: const Icon(Icons.create),
                      title: const Text('Created At'),
                      subtitle: Text(DateFormat.yMMMd().add_jm().format(tx.createdAt)),
                    ),

                    if (showLastUpdated) ...[
                      const Divider(height: 1.0),
                      ListTile(
                        leading: const Icon(Icons.update),
                        title: const Text('Last Updated'),
                        subtitle: Text(DateFormat.yMMMd().add_jm().format(tx.updatedAt)),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
