import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../domain/entities/account.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  IconData _iconForType(AccountType type) {
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
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.0.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20.0.r,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Icon(
                          _iconForType(account.type),
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                        '${account.currencyCode} ${account.balance.toStringAsFixed(2)}',
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
