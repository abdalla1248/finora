import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/delete_transaction_dialog.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final txColors = Theme.of(context).extension<TransactionColors>();

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

        final amountPrefix = isIncome ? '+' : (isExpense ? '-' : '');
        final amountColor = isIncome
            ? (txColors?.income ?? FinoraColorSchemes.incomeGreen)
            : (isExpense
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary);

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
                  leading: const Icon(Icons.category),
                  title: Text(l10n.categoryLabel),
                  subtitle: Text(category.id),
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: const Text('Type'),
                  subtitle: Text(tx.transactionType.name.toUpperCase()),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(l10n.dateLabel),
                  subtitle: Text(DateFormat.yMMMMd().format(tx.transactionDate)),
                ),
                if (tx.note.isNotEmpty) ...[
                  ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(l10n.noteLabel),
                    subtitle: Text(tx.note),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
