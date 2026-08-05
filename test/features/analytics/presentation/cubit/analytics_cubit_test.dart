import 'package:flutter_test/flutter_test.dart';
import 'package:finora/features/analytics/domain/services/analytics_service.dart';
import 'package:finora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:finora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:finora/features/transaction/domain/entities/transaction.dart';

void main() {
  late AnalyticsService service;
  late AnalyticsCubit cubit;

  final now = DateTime.now();
  final tIncome = Transaction(
    id: 'tx_1',
    title: 'Salary Deposit',
    amount: 4000.0,
    transactionType: TransactionType.income,
    categoryId: 'salary',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final tExpense = Transaction(
    id: 'tx_2',
    title: 'Dinner',
    amount: 100.0,
    transactionType: TransactionType.expense,
    categoryId: 'food',
    accountId: 'default',
    currencyCode: 'USD',
    transactionDate: now,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    service = const AnalyticsService();
    cubit = AnalyticsCubit(service);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default monthly period and zero balance', () {
    expect(cubit.state, const AnalyticsState());
  });

  test(
    'computeAnalytics calculates total income, expense, and net balance',
    () {
      cubit.computeAnalytics([tIncome, tExpense], currencyCode: 'USD');

      expect(cubit.state.totalIncome, equals(4000.0));
      expect(cubit.state.totalExpense, equals(100.0));
      expect(cubit.state.netCashFlow, equals(3900.0));
      expect(cubit.state.savingsRate, equals(97.5));
    },
  );

  test('setPeriod updates selected period and recalculates metrics', () {
    cubit.setPeriod(AnalyticsPeriod.today, [
      tIncome,
      tExpense,
    ], currencyCode: 'USD');

    expect(cubit.state.period, equals(AnalyticsPeriod.today));
    expect(cubit.state.totalIncome, equals(4000.0));
  });
}
