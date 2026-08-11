import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/custom_category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.categoriesTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/categories/add'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.expenseCategoriesTab),
              Tab(text: l10n.incomeCategoriesTab),
            ],
          ),
        ),
        body: ResponsiveCenteredView(
          child: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const LoadingIndicator();
              }

              final expenseCategories = state.categories
                  .where((c) => c.type == TransactionType.expense)
                  .toList();
              final incomeCategories = state.categories
                  .where((c) => c.type == TransactionType.income)
                  .toList();

              return TabBarView(
                children: [
                  _CategoryList(
                    categories: expenseCategories,
                    emptyTitle: l10n.noCategoriesTitle,
                    emptyDesc: l10n.noCategoriesDesc,
                  ),
                  _CategoryList(
                    categories: incomeCategories,
                    emptyTitle: l10n.noCategoriesTitle,
                    emptyDesc: l10n.noCategoriesDesc,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<CustomCategory> categories;
  final String emptyTitle;
  final String emptyDesc;

  const _CategoryList({
    required this.categories,
    required this.emptyTitle,
    required this.emptyDesc,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: EmptyState(
          title: emptyTitle,
          description: emptyDesc,
          icon: Icons.category_outlined,
        ),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.0.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.0.r,
              backgroundColor: FinoraColorSchemes.parseHexColor(cat.colorHex),
              child: Icon(Icons.label, color: Colors.white, size: 20.0.r),
            ),
            title: Text(
              cat.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
              ),
            ),
            subtitle: Text(
              cat.type.name.toUpperCase(),
              style: TextStyle(fontSize: 12.0.sp),
            ),
            onTap: () => context.push('/categories/edit/${cat.id}'),
          ),
        );
      },
    );
  }
}
