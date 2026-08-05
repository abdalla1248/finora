import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';
import 'package:finora/features/transaction/presentation/widgets/transaction_card.dart';

void main() {
  final now = DateTime.utc(2026, 8, 3);
  final tTransaction = Transaction(
    id: 'tx_1',
    title: 'Dinner at Italian Restaurant',
    amount: 45.0,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  testWidgets('TransactionCard renders title and formatted amount', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TransactionCard(transaction: tTransaction)),
      ),
    );

    expect(find.text('Dinner at Italian Restaurant'), findsOneWidget);
    expect(find.text('-USD 45.00'), findsOneWidget);
  });
}
