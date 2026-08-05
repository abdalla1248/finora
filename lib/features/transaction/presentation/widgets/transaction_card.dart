import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionCard({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = CategoryRegistry.getCategoryById(transaction.categoryId);
    final isExpense = transaction.transactionType == TransactionType.expense;
    final isIncome = transaction.transactionType == TransactionType.income;
    final amountPrefix = isIncome ? '+' : (isExpense ? '-' : '');
    final amountColor = isIncome
        ? context.semanticColors.income
        : (isExpense
              ? context.semanticColors.expense
              : context.semanticColors.transfer);

    final dateFormatted = DateFormat.yMMMd().format(
      transaction.transactionDate,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: category.color.withValues(alpha: 0.15),
          child: Icon(category.icon, color: category.color),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          dateFormatted,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: Text(
          '$amountPrefix${transaction.currencyCode} ${transaction.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ),
    );
  }
}
