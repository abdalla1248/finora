import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../budget/presentation/cubit/budget_cubit.dart';
import '../../../budget/presentation/cubit/savings_goal_cubit.dart';
import '../../../transaction/presentation/cubit/transaction_cubit.dart';
import '../cubit/backup_cubit.dart';
import '../cubit/backup_state.dart';

class BackupExportScreen extends StatelessWidget {
  const BackupExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupExportTitle)),
      body: BlocListener<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state.statusMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.statusMessage!)));
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: ResponsiveCenteredView(
          child: ListView(
            padding: EdgeInsets.all(16.0.r),
            children: [
              // Export Section
              _SectionHeader(title: l10n.exportSectionTitle),
              SizedBox(height: 8.0.h),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(l10n.exportJsonLabel),
                      subtitle: Text(l10n.exportJsonDesc),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _exportJson(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.table_chart),
                      title: Text(l10n.exportCsvLabel),
                      subtitle: Text(l10n.exportCsvDesc),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _exportCsv(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0.h),

              // Data Management Section
              _SectionHeader(title: l10n.dataManagementTitle),
              SizedBox(height: 8.0.h),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.restore),
                      title: Text(l10n.importJsonLabel),
                      subtitle: Text(l10n.importJsonDesc),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showRestoreDialog(context, l10n),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        l10n.factoryResetLabel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      subtitle: Text(l10n.factoryResetDesc),
                      onTap: () => _showFactoryResetDialog(context, l10n),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportJson(BuildContext context) {
    final transactions = context.read<TransactionCubit>().state.allTransactions;
    final budgets = context.read<BudgetCubit>().state.budgets;
    final goals = context.read<SavingsGoalCubit>().state.goals;
    final accounts = context.read<AccountCubit>().state.accounts;

    context.read<BackupCubit>().exportToJson(
      transactions: transactions,
      budgets: budgets,
      goals: goals,
      accounts: accounts,
    );
  }

  void _exportCsv(BuildContext context) {
    final transactions = context.read<TransactionCubit>().state.allTransactions;
    context.read<BackupCubit>().exportToCsv(transactions);
  }

  void _showRestoreDialog(BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.importJsonLabel),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Paste backup JSON payload here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () async {
              final jsonText = controller.text.trim();
              if (jsonText.isNotEmpty) {
                Navigator.of(dialogContext).pop();
                await context.read<BackupCubit>().importFromJson(jsonText);
                if (context.mounted) {
                  await context.read<TransactionCubit>().loadTransactions();
                }
                if (context.mounted) {
                  await context.read<AccountCubit>().loadAccounts();
                }
                if (context.mounted) {
                  await context.read<BudgetCubit>().loadBudgets();
                }
                if (context.mounted) {
                  await context.read<SavingsGoalCubit>().loadGoals();
                }
              }
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }

  void _showFactoryResetDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.factoryResetLabel),
        content: Text(l10n.factoryResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.read<BackupCubit>().factoryReset();
              if (context.mounted) {
                await context.read<TransactionCubit>().loadTransactions();
              }
              if (context.mounted) {
                await context.read<AccountCubit>().loadAccounts();
              }
              if (context.mounted) {
                await context.read<BudgetCubit>().loadBudgets();
              }
              if (context.mounted) {
                await context.read<SavingsGoalCubit>().loadGoals();
              }
            },
            child: Text(
              l10n.deleteButton,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
    );
  }
}
