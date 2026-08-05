import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/transaction.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final transactionCubit = context.read<TransactionCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: transactionCubit,
        child: const FilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final cubit = context.read<TransactionCubit>();

        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filterTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        cubit.clearFilters();
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.clearFiltersButton),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12.0),

                // Transaction Type Filter
                Text(
                  l10n.typeExpense,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: Text(l10n.filterAllDates),
                      selected: state.selectedTypeFilter == null,
                      onSelected: (_) => cubit.setTypeFilter(null),
                    ),
                    FilterChip(
                      label: Text(l10n.typeExpense),
                      selected:
                          state.selectedTypeFilter == TransactionType.expense,
                      onSelected: (_) =>
                          cubit.setTypeFilter(TransactionType.expense),
                    ),
                    FilterChip(
                      label: Text(l10n.typeIncome),
                      selected:
                          state.selectedTypeFilter == TransactionType.income,
                      onSelected: (_) =>
                          cubit.setTypeFilter(TransactionType.income),
                    ),
                    FilterChip(
                      label: Text(l10n.typeTransfer),
                      selected:
                          state.selectedTypeFilter == TransactionType.transfer,
                      onSelected: (_) =>
                          cubit.setTypeFilter(TransactionType.transfer),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Date Range Filter
                Text(
                  l10n.dateLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: Text(l10n.filterAllDates),
                      selected: state.dateRangeFilter == DateRangeFilter.all,
                      onSelected: (_) =>
                          cubit.setDateRangeFilter(DateRangeFilter.all),
                    ),
                    FilterChip(
                      label: Text(l10n.filterToday),
                      selected: state.dateRangeFilter == DateRangeFilter.today,
                      onSelected: (_) =>
                          cubit.setDateRangeFilter(DateRangeFilter.today),
                    ),
                    FilterChip(
                      label: Text(l10n.filterYesterday),
                      selected:
                          state.dateRangeFilter == DateRangeFilter.yesterday,
                      onSelected: (_) =>
                          cubit.setDateRangeFilter(DateRangeFilter.yesterday),
                    ),
                    FilterChip(
                      label: Text(l10n.filterThisWeek),
                      selected:
                          state.dateRangeFilter == DateRangeFilter.thisWeek,
                      onSelected: (_) =>
                          cubit.setDateRangeFilter(DateRangeFilter.thisWeek),
                    ),
                    FilterChip(
                      label: Text(l10n.filterThisMonth),
                      selected:
                          state.dateRangeFilter == DateRangeFilter.thisMonth,
                      onSelected: (_) =>
                          cubit.setDateRangeFilter(DateRangeFilter.thisMonth),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Sort Options
                Text('Sort By', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.sortNewest),
                      selected:
                          state.sortOption == TransactionSortOption.newest,
                      onSelected: (_) =>
                          cubit.setSortOption(TransactionSortOption.newest),
                    ),
                    ChoiceChip(
                      label: Text(l10n.sortOldest),
                      selected:
                          state.sortOption == TransactionSortOption.oldest,
                      onSelected: (_) =>
                          cubit.setSortOption(TransactionSortOption.oldest),
                    ),
                    ChoiceChip(
                      label: Text(l10n.sortHighestAmount),
                      selected:
                          state.sortOption ==
                          TransactionSortOption.highestAmount,
                      onSelected: (_) => cubit.setSortOption(
                        TransactionSortOption.highestAmount,
                      ),
                    ),
                    ChoiceChip(
                      label: Text(l10n.sortLowestAmount),
                      selected:
                          state.sortOption ==
                          TransactionSortOption.lowestAmount,
                      onSelected: (_) => cubit.setSortOption(
                        TransactionSortOption.lowestAmount,
                      ),
                    ),
                    ChoiceChip(
                      label: Text(l10n.sortAlphabetical),
                      selected:
                          state.sortOption ==
                          TransactionSortOption.alphabetical,
                      onSelected: (_) => cubit.setSortOption(
                        TransactionSortOption.alphabetical,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
