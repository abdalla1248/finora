import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finora/core/error/failures.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';
import 'package:finora/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:finora/features/transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finora/features/transaction/presentation/cubit/transaction_state.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late TransactionRepository mockRepository;
  late TransactionCubit transactionCubit;

  final now = DateTime.utc(2026, 8, 3);
  final tTx1 = Transaction(
    id: 'tx_1',
    title: 'Salary Deposit',
    amount: 3000.0,
    transactionType: TransactionType.income,
    categoryId: 'salary',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final tTx2 = Transaction(
    id: 'tx_2',
    title: 'Coffee',
    amount: 4.5,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now.subtract(const Duration(days: 1)),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepository = MockTransactionRepository();
    transactionCubit = TransactionCubit(mockRepository);
  });

  tearDown(() {
    transactionCubit.close();
  });

  test('initial state has empty transactions list', () {
    expect(transactionCubit.state, const TransactionState());
  });

  group('loadTransactions', () {
    test('emits state with loaded and filtered transactions', () async {
      when(
        () => mockRepository.getTransactions(),
      ).thenAnswer((_) async => Right([tTx1, tTx2]));

      final future = expectLater(
        transactionCubit.stream,
        emitsInOrder([
          const TransactionState(isLoading: true),
          TransactionState(
            allTransactions: [tTx1, tTx2],
            filteredTransactions: [tTx1, tTx2],
            isLoading: false,
          ),
        ]),
      );

      await transactionCubit.loadTransactions();
      await future;
    });

    test('emits error message when loading fails', () async {
      when(
        () => mockRepository.getTransactions(),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Storage Error')));

      final future = expectLater(
        transactionCubit.stream,
        emitsInOrder([
          const TransactionState(isLoading: true),
          const TransactionState(
            isLoading: false,
            errorMessage: 'Storage Error',
          ),
        ]),
      );

      await transactionCubit.loadTransactions();
      await future;
    });
  });

  group('search and filter', () {
    test('filters transactions instantly by search query', () async {
      when(
        () => mockRepository.getTransactions(),
      ).thenAnswer((_) async => Right([tTx1, tTx2]));

      await transactionCubit.loadTransactions();
      transactionCubit.setSearchQuery('Coffee');

      expect(transactionCubit.state.filteredTransactions, equals([tTx2]));
    });

    test('filters transactions by type', () async {
      when(
        () => mockRepository.getTransactions(),
      ).thenAnswer((_) async => Right([tTx1, tTx2]));

      await transactionCubit.loadTransactions();
      transactionCubit.setTypeFilter(TransactionType.income);

      expect(transactionCubit.state.filteredTransactions, equals([tTx1]));
    });
  });
}
