import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/design_system/color_schemes.dart';
import '../../../../l10n/app_localizations.dart';

class AccountColorPicker extends StatelessWidget {
  final String selectedColorHex;
  final ValueChanged<String> onColorSelected;

  static const List<String> colorOptions = [
    '1E88E5', // Blue
    '43A047', // Green
    'E53935', // Red
    'FB8C00', // Orange
    '8E24AA', // Purple
    '00ACC1', // Cyan
    'FDD835', // Yellow
    '3949AB', // Indigo
  ];

  const AccountColorPicker({
    super.key,
    required this.selectedColorHex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.colorLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14.0.sp),
        ),
        SizedBox(height: 8.0.h),
        Wrap(
          spacing: 12.0.w,
          runSpacing: 12.0.h,
          children: colorOptions.map((hex) {
            final isSelected = selectedColorHex == hex;
            return GestureDetector(
              onTap: () => onColorSelected(hex),
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
      ],
    );
  }
}
