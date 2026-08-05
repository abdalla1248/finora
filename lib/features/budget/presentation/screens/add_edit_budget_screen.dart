import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../transaction/domain/entities/category.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../../domain/entities/budget.dart';
import '../cubit/budget_cubit.dart';

class AddEditBudgetScreen extends StatefulWidget {
  final Budget? initialBudget;

  const AddEditBudgetScreen({super.key, this.initialBudget});

  @override
  State<AddEditBudgetScreen> createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends State<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  late String _selectedCategoryId;
  late BudgetType _selectedType;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final b = widget.initialBudget;
    _nameController = TextEditingController(text: b?.name ?? '');
    _amountController = TextEditingController(
      text: b != null ? b.amount.toString() : '',
    );

    _selectedCategoryId = b?.categoryId ?? 'food';
    _selectedType = b?.budgetType ?? BudgetType.monthly;

    final now = DateTime.now();
    _startDate = b?.startDate ?? DateTime(now.year, now.month, 1);
    _endDate = b?.endDate ?? DateTime(now.year, now.month + 1, 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialBudget != null;
    final categories = CategoryRegistry.getCategoriesForType(
      TransactionType.expense,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editBudgetTitle : l10n.addBudgetTitle),
      ),
      body: ResponsiveCenteredView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.budgetNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.budgetNameRequiredError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.amountLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.amountRequiredError;
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return l10n.amountPositiveError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id,
                      child: Row(
                        children: [
                          Icon(cat.icon, color: cat.color, size: 20.0.r),
                          SizedBox(width: 8.0.w),
                          Text(cat.id),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategoryId = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 16.0.h),
                DropdownButtonFormField<BudgetType>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Budget Cycle',
                    border: OutlineInputBorder(),
                  ),
                  items: BudgetType.values.map((type) {
                    return DropdownMenuItem<BudgetType>(
                      value: type,
                      child: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedType = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 32.0.h),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    final currency =
                        (userState is UserLoaded && userState.user != null)
                        ? userState.user!.preferredCurrencyCode
                        : 'USD';

                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(
                            _amountController.text.trim(),
                          );
                          final now = DateTime.now();

                          final budget = Budget(
                            id: widget.initialBudget?.id ??
                                now.millisecondsSinceEpoch.toString(),
                            name: _nameController.text.trim(),
                            categoryId: _selectedCategoryId,
                            budgetType: _selectedType,
                            amount: amount,
                            currencyCode: currency,
                            startDate: _startDate,
                            endDate: _endDate,
                            createdAt: widget.initialBudget?.createdAt ?? now,
                            updatedAt: now,
                          );

                          // Check if a budget already exists for this category (excluding the one being edited)
                          final existingBudgets = context.read<BudgetCubit>().state.budgets;
                          final duplicate = existingBudgets.where(
                            (b) => b.categoryId == _selectedCategoryId && b.id != widget.initialBudget?.id,
                          ).firstOrNull;

                          if (duplicate != null) {
                            // Show warning dialog with options
                            final choice = await showDialog<String>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: Text(l10n.duplicateBudgetTitle),
                                content: Text(l10n.duplicateBudgetMessage),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop('cancel'),
                                    child: Text(l10n.cancelButton),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop('replace'),
                                    child: Text(l10n.btnUpdateBudget),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop('increase'),
                                    child: Text(l10n.btnIncreaseBudget),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop('decrease'),
                                    child: Text(l10n.btnDecreaseBudget),
                                  ),
                                ],
                              ),
                            );

                            if (choice == null || choice == 'cancel' || !context.mounted) {
                              return;
                            }

                            Budget updatedBudget;
                            if (choice == 'replace') {
                              updatedBudget = duplicate.copyWith(
                                amount: amount,
                                updatedAt: DateTime.now(),
                              );
                            } else if (choice == 'increase') {
                              updatedBudget = duplicate.copyWith(
                                amount: duplicate.amount + amount,
                                updatedAt: DateTime.now(),
                              );
                            } else {
                              updatedBudget = duplicate.copyWith(
                                amount: (duplicate.amount - amount).clamp(0.0, double.infinity),
                                updatedAt: DateTime.now(),
                              );
                            }

                            await context.read<BudgetCubit>().updateBudget(updatedBudget);
                          } else {
                            if (isEditing) {
                              await context.read<BudgetCubit>().updateBudget(budget);
                            } else {
                              await context.read<BudgetCubit>().addBudget(budget);
                            }
                          }

                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0.h),
                      ),
                      child: Text(l10n.saveButton),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
