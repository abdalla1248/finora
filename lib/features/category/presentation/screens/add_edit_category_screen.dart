import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/custom_category.dart';
import '../cubit/category_cubit.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final CustomCategory? initialCategory;

  const AddEditCategoryScreen({super.key, this.initialCategory});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late TransactionType _selectedType;
  late String _selectedColorHex;

  static const List<String> _colorOptions = [
    'E53935',
    '8E24AA',
    '3949AB',
    '1E88E5',
    '00897B',
    '43A047',
    'FDD835',
    'FB8C00',
    '6D4C41',
    '546E7A',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.initialCategory;
    _nameController = TextEditingController(text: c?.name ?? '');
    _selectedType = c?.type ?? TransactionType.expense;
    _selectedColorHex = c?.colorHex ?? _colorOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialCategory != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editCategoryTitle : l10n.addCategoryTitle),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteDialog(context, l10n),
            ),
        ],
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
                    labelText: l10n.categoryNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.categoryNameRequiredError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                DropdownButtonFormField<TransactionType>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.categoryTypeLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: TransactionType.expense,
                      child: Text(l10n.typeExpense),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.income,
                      child: Text(l10n.typeIncome),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedType = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 24.0.h),
                Text(
                  l10n.colorLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14.0.sp),
                ),
                SizedBox(height: 8.0.h),
                Wrap(
                  spacing: 12.0.w,
                  runSpacing: 12.0.h,
                  children: _colorOptions.map((hex) {
                    final isSelected = _selectedColorHex == hex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorHex = hex;
                        });
                      },
                      child: Container(
                        width: 40.0.w,
                        height: 40.0.h,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF$hex')),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  width: 3.0.r,
                                )
                              : null,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20.0.r,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 32.0.h),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final category = CustomCategory(
                        id:
                            widget.initialCategory?.id ??
                            now.millisecondsSinceEpoch.toString(),
                        name: _nameController.text.trim(),
                        type: _selectedType,
                        iconData: 'label',
                        colorHex: _selectedColorHex,
                      );

                      await context.read<CategoryCubit>().addCategory(category);
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  ),
                  child: Text(l10n.saveButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteCategoryTitle),
        content: Text(l10n.deleteCategoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.read<CategoryCubit>().deleteCategory(
                widget.initialCategory!.id,
              );
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text(
              l10n.deleteButton,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
