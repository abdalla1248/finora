import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../l10n/app_localizations.dart';

class AccountIconPicker extends StatelessWidget {
  final String selectedIconName;
  final ValueChanged<String> onIconSelected;

  static const Map<String, IconData> _iconOptions = {
    'wallet': Icons.account_balance_wallet,
    'savings': Icons.savings_outlined,
    'bank': Icons.account_balance,
    'cash': Icons.money,
    'card': Icons.credit_card,
    'investment': Icons.trending_up,
  };

  const AccountIconPicker({
    super.key,
    required this.selectedIconName,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountIconLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14.0.sp),
        ),
        SizedBox(height: 8.0.h),
        Wrap(
          spacing: 12.0.w,
          runSpacing: 12.0.h,
          children: _iconOptions.entries.map((entry) {
            final isSelected = selectedIconName == entry.key;
            return GestureDetector(
              onTap: () => onIconSelected(entry.key),
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
      ],
    );
  }
}
