import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/account/domain/entities/account.dart';

void main() {
  final now = DateTime.utc(2026, 8, 3);
  final tAccount = Account(
    id: 'account_1',
    name: 'Main Wallet',
    type: AccountType.cash,
    balance: 500.0,
    currencyCode: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  group('Account Entity', () {
    test('supports value equality', () {
      final equivalent = Account(
        id: 'account_1',
        name: 'Main Wallet',
        type: AccountType.cash,
        balance: 500.0,
        currencyCode: 'USD',
        createdAt: now,
        updatedAt: now,
      );
      expect(tAccount, equals(equivalent));
    });

    test('copyWith updates properties correctly', () {
      final updated = tAccount.copyWith(balance: 1000.0, name: 'Bank Card');
      expect(updated.balance, equals(1000.0));
      expect(updated.name, equals('Bank Card'));
    });
  });
}
