import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../domain/entities/account.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../../../../core/utils/currency_formatter.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  IconData _getIcon(String? iconName, AccountType type) {
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

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Account account) async {
    final l10n = AppLocalizations.of(context);
    final txState = context.read<TransactionCubit>().state;
    
    final hasTransactions = txState.allTransactions.any((tx) => 
        tx.accountId == account.id || 
        (tx.transactionType == TransactionType.transfer && tx.note.contains('TargetAccount:${account.id}'))
    );
    
    if (hasTransactions) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(l10n.deleteAccountTitle),
            content: Text(l10n.deleteAccountErrorHasTransactions),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.okButton),
              ),
            ],
          );
        },
      );
      return false;
    }
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteAccountConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(l10n.deleteButton),
            ),
          ],
        );
      },
    );
    
    if (confirm == true) {
      if (context.mounted) {
        await context.read<AccountCubit>().deleteAccount(account.id);
      }
      return true;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountsTitle)),
      body: ResponsiveCenteredView(
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.accounts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmptyState(
                      title: l10n.noAccountsTitle,
                      description: l10n.noAccountsDesc,
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    SizedBox(height: 16.0.h),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/accounts/add'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addAccountCta),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final accCubit = context.read<AccountCubit>();
                await accCubit.loadAccounts();
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.0.r),
                itemCount: state.accounts.length,
                itemBuilder: (context, index) {
                  final account = state.accounts[index];
                  final accountColor = account.colorHex != null
                      ? FinoraColorSchemes.parseHexColor(account.colorHex!)
                      : Theme.of(context).colorScheme.primary;

                  return Dismissible(
                    key: Key(account.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      margin: EdgeInsets.only(bottom: 12.0.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await _showDeleteConfirmDialog(context, account);
                    },
                    child: Card(
                      margin: EdgeInsets.only(bottom: 12.0.h),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20.0.r,
                          backgroundColor: accountColor.withValues(alpha: 0.15),
                          child: Icon(
                            _getIcon(account.iconData, account.type),
                            color: accountColor,
                            size: 20.0.r,
                          ),
                        ),
                        title: Text(
                          account.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0.sp,
                          ),
                        ),
                        subtitle: Text(
                          formatCurrency(account.balance, account.currencyCode, context),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 14.0.sp,
                          ),
                        ),
                        trailing: account.isDefault
                            ? Chip(
                                label: Text(
                                  l10n.defaultLabel,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10.0.sp),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer,
                              )
                            : null,
                        onTap: () => context.push('/accounts/details/${account.id}'),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/accounts/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
