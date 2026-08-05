import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/transaction_card.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recentTransactionsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => FilterBottomSheet.show(context),
          ),
        ],
      ),
      body: ResponsiveCenteredView(
        child: Column(
          children: [
            // Instant Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 8.0.h,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchTransactionsHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<TransactionCubit>().setSearchQuery('');
                          },
                        )
                      : null,
                ),
                onChanged: (query) {
                  context.read<TransactionCubit>().setSearchQuery(query);
                },
              ),
            ),

            // Transaction Cards List
            Expanded(
              child: BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingIndicator();
                  }

                  if (state.filteredTransactions.isEmpty) {
                    return EmptyState(
                      title: l10n.noTransactionsFound,
                      description: l10n.dashboardEmptyDesc,
                      icon: Icons.receipt_long_outlined,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final txCubit = context.read<TransactionCubit>();
                      await txCubit.loadTransactions();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w,
                        vertical: 8.0.h,
                      ),
                      itemCount: state.filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = state.filteredTransactions[index];
                        return TransactionCard(
                          transaction: tx,
                          onTap: () {
                            context.push('/transactions/details/${tx.id}');
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/transactions/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
