import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/color_schemes.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../../category/presentation/cubit/category_cubit.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../cubit/transaction_cubit.dart';
import '../widgets/transaction_account_selector.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final Transaction? initialTransaction;

  const AddEditTransactionScreen({super.key, this.initialTransaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  late TransactionType _selectedType;
  late String _selectedCategoryId;
  String? _selectedAccountId;
  String? _selectedTargetAccountId;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toString() : '',
    );
    _noteController = TextEditingController(text: _cleanNote(tx?.note ?? ''));

    _selectedType = tx?.transactionType ?? TransactionType.expense;
    _selectedCategoryId = tx?.categoryId ?? 'food';
    _selectedAccountId = tx?.accountId;
    _selectedTargetAccountId = _extractTargetAccountFromNote(tx?.note ?? '');
    _selectedDate = tx?.transactionDate ?? DateTime.now();
  }

  String _cleanNote(String note) {
    return note.replaceAll(RegExp(r'TargetAccount:[^\s]+'), '').trim();
  }

  String? _extractTargetAccountFromNote(String note) {
    final match = RegExp(r'TargetAccount:([^\s]+)').firstMatch(note);
    return match?.group(1);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialTransaction != null;
    final incomeColor = context.semanticColors.income;
    final expenseColor = context.semanticColors.expense;

    final builtInCategories = CategoryRegistry.getCategoriesForType(
      _selectedType,
    );
    final customCategoriesState = context.watch<CategoryCubit>().state;
    final customCategories = customCategoriesState.categories
        .where((c) => c.type == _selectedType)
        .map(
          (c) => Category(
            id: c.id,
            nameKey: c.name,
            type: c.type,
            icon: Icons.category_outlined,
            color: FinoraColorSchemes.parseHexColor(c.colorHex),
          ),
        )
        .toList();

    final allCategories = [...builtInCategories, ...customCategories];
    if (!allCategories.any((c) => c.id == _selectedCategoryId)) {
      if (allCategories.isNotEmpty) {
        _selectedCategoryId = allCategories.first.id;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.editTransactionTitle : l10n.addTransactionTitle,
        ),
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, accountState) {
          final accounts = accountState.accounts;
          if (accounts.isNotEmpty) {
            _selectedAccountId ??= accounts
                .firstWhere((a) => a.isDefault, orElse: () => accounts.first)
                .id;
            if (_selectedType == TransactionType.transfer) {
              final otherAccounts = accounts
                  .where((a) => a.id != _selectedAccountId)
                  .toList();
              if (otherAccounts.isNotEmpty &&
                  (_selectedTargetAccountId == null ||
                      !otherAccounts.any(
                        (a) => a.id == _selectedTargetAccountId,
                      ))) {
                _selectedTargetAccountId = otherAccounts.first.id;
              }
            }
          }

          return ResponsiveCenteredView(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<TransactionType>(
                      segments: [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text(l10n.typeExpense),
                          icon: Icon(
                            Icons.arrow_downward,
                            color: expenseColor,
                          ),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text(l10n.typeIncome),
                          icon: Icon(Icons.arrow_upward, color: incomeColor),
                        ),
                        ButtonSegment(
                          value: TransactionType.transfer,
                          label: Text(l10n.typeTransfer),
                          icon: const Icon(Icons.swap_horiz),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                          final available =
                              CategoryRegistry.getCategoriesForType(
                                _selectedType,
                              );
                          if (available.isNotEmpty) {
                            _selectedCategoryId = available.first.id;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 24.0),

                    TransactionAccountSelector(
                      accounts: accounts,
                      selectedAccountId: _selectedAccountId,
                      selectedTargetAccountId: _selectedTargetAccountId,
                      isTransfer: _selectedType == TransactionType.transfer,
                      onSourceAccountChanged: (val) {
                        setState(() {
                          _selectedAccountId = val;
                          if (_selectedTargetAccountId == val) {
                            final other = accounts
                                .where((a) => a.id != val)
                                .firstOrNull;
                            _selectedTargetAccountId = other?.id;
                          }
                        });
                      },
                      onTargetAccountChanged: (val) {
                        setState(() {
                          _selectedTargetAccountId = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Title Field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.titleLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Amount Field
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
                    const SizedBox(height: 16.0),

                    // Category Selector
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      decoration: InputDecoration(
                        labelText: l10n.categoryLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: allCategories.map((category) {
                        final localizedName = category.getLocalizedName(l10n);
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Row(
                            children: [
                              Icon(
                                category.icon,
                                color: category.color,
                                size: 20.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(localizedName),
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
                    const SizedBox(height: 16.0),

                    // Date Picker Field
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.dateLabel,
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(DateFormat.yMMMd().format(_selectedDate)),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Note Field
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.noteLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Submit Button
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        final currency =
                            (userState is UserLoaded &&
                                userState.user != null)
                            ? userState.user!.preferredCurrencyCode
                            : 'USD';

                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final amount = double.parse(
                                _amountController.text.trim(),
                              );
                              final now = DateTime.now();
                              String finalNote = _noteController.text.trim();
                              if (_selectedType == TransactionType.transfer &&
                                  _selectedTargetAccountId != null) {
                                finalNote =
                                    '$finalNote TargetAccount:$_selectedTargetAccountId'
                                        .trim();
                              }

                              final categoryName = allCategories
                                  .firstWhere(
                                    (c) => c.id == _selectedCategoryId,
                                    orElse: () => allCategories.first,
                                  )
                                  .getLocalizedName(l10n);
                              final title =
                                  _titleController.text.trim().isEmpty
                                  ? categoryName
                                  : _titleController.text.trim();

                              final transaction = Transaction(
                                id:
                                    widget.initialTransaction?.id ??
                                    now.millisecondsSinceEpoch.toString(),
                                title: title,
                                amount: amount,
                                transactionType: _selectedType,
                                categoryId: _selectedCategoryId,
                                accountId:
                                    _selectedAccountId ??
                                    'default_cash_account',
                                currencyCode: currency,
                                transactionDate: _selectedDate,
                                createdAt:
                                    widget.initialTransaction?.createdAt ??
                                    now,
                                updatedAt: now,
                                note: finalNote,
                              );

                              if (isEditing) {
                                context
                                    .read<TransactionCubit>()
                                    .updateTransaction(transaction);
                              } else {
                                context
                                    .read<TransactionCubit>()
                                    .addTransaction(transaction);
                              }

                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                          ),
                          child: Text(l10n.saveButton),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
