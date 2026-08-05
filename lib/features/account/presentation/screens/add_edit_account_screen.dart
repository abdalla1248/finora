import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../../domain/entities/account.dart';
import '../cubit/account_cubit.dart';

class AddEditAccountScreen extends StatefulWidget {
  final Account? initialAccount;

  const AddEditAccountScreen({super.key, this.initialAccount});

  @override
  State<AddEditAccountScreen> createState() => _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountType _selectedType;
  late String _selectedIconName;
  late String _selectedColorHex;
  late bool _isDefault;

  static const List<String> _colorOptions = [
    '1E88E5', // Blue
    '43A047', // Green
    'E53935', // Red
    'FB8C00', // Orange
    '8E24AA', // Purple
    '00ACC1', // Cyan
    'FDD835', // Yellow
    '3949AB', // Indigo
  ];

  static const Map<String, IconData> _iconOptions = {
    'wallet': Icons.account_balance_wallet,
    'savings': Icons.savings_outlined,
    'bank': Icons.account_balance,
    'cash': Icons.money,
    'card': Icons.credit_card,
    'investment': Icons.trending_up,
  };

  @override
  void initState() {
    super.initState();
    final a = widget.initialAccount;
    _nameController = TextEditingController(text: a?.name ?? '');
    _balanceController = TextEditingController(
      text: a != null ? a.balance.toString() : '0.00',
    );
    _selectedType = a?.type ?? AccountType.cash;
    _selectedIconName = a?.iconData ?? 'wallet';
    _selectedColorHex = a?.colorHex ?? _colorOptions.first;
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialAccount != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editAccountTitle : l10n.addAccountTitle),
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
                    labelText: l10n.accountNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.accountNameRequiredError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _balanceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.balanceLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.amountRequiredError;
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return l10n.amountPositiveError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                DropdownButtonFormField<AccountType>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.accountTypeLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: AccountType.values.map((type) {
                    return DropdownMenuItem<AccountType>(
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
                SizedBox(height: 24.0.h),

                // Icon Picker Section
                Text(
                  'Account Icon',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14.0.sp),
                ),
                SizedBox(height: 8.0.h),
                Wrap(
                  spacing: 12.0.w,
                  runSpacing: 12.0.h,
                  children: _iconOptions.entries.map((entry) {
                    final isSelected = _selectedIconName == entry.key;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIconName = entry.key;
                        });
                      },
                      child: CircleAvatar(
                        radius: 24.0.r,
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          entry.value,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24.0.r,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.0.h),

                // Color Picker Section
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
                          color: FinoraColorSchemes.parseHexColor(hex),
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
                SizedBox(height: 16.0.h),

                // Default Switch
                SwitchListTile(
                  title: const Text('Default Account'),
                  subtitle: const Text('Use this account as the default for new transactions'),
                  value: _isDefault,
                  onChanged: (val) {
                    setState(() {
                      _isDefault = val;
                    });
                  },
                ),
                SizedBox(height: 24.0.h),

                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    final currency =
                        (userState is UserLoaded && userState.user != null)
                        ? userState.user!.preferredCurrencyCode
                        : 'USD';

                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final balance = double.parse(
                            _balanceController.text.trim(),
                          );
                          final now = DateTime.now();

                          final account = Account(
                            id:
                                widget.initialAccount?.id ??
                                now.millisecondsSinceEpoch.toString(),
                            name: _nameController.text.trim(),
                            type: _selectedType,
                            balance: balance,
                            currencyCode: currency,
                            colorHex: _selectedColorHex,
                            iconData: _selectedIconName,
                            createdAt: widget.initialAccount?.createdAt ?? now,
                            updatedAt: now,
                            isDefault: _isDefault,
                          );

                          await context.read<AccountCubit>().addAccount(account);
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

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.read<AccountCubit>().deleteAccount(
                widget.initialAccount!.id,
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
