import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/domain/entities/account.dart';
import '../../../account/presentation/utils/account_presentation_extensions.dart';

class TransactionAccountSelector extends StatelessWidget {
  final List<Account> accounts;
  final String? selectedAccountId;
  final String? selectedTargetAccountId;
  final bool isTransfer;
  final ValueChanged<String> onSourceAccountChanged;
  final ValueChanged<String> onTargetAccountChanged;

  const TransactionAccountSelector({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.selectedTargetAccountId,
    required this.isTransfer,
    required this.onSourceAccountChanged,
    required this.onTargetAccountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: selectedAccountId,
          decoration: InputDecoration(
            labelText: isTransfer ? l10n.sourceAccountLabel : l10n.accountsTitle,
            border: const OutlineInputBorder(),
          ),
          items: accounts.map((account) {
            final color = account.getThemeColor(context);
            return DropdownMenuItem<String>(
              value: account.id,
              child: Row(
                children: [
                  Icon(
                    account.icon,
                    color: color,
                    size: 20.0.r,
                  ),
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: Text(
                      '${account.name} (${formatCurrency(account.balance, account.currencyCode, context)})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              onSourceAccountChanged(val);
            }
          },
        ),
        if (isTransfer) ...[
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: selectedTargetAccountId,
            decoration: InputDecoration(
              labelText: l10n.targetAccountLabel,
              border: const OutlineInputBorder(),
            ),
            items: accounts
                .where((a) => a.id != selectedAccountId)
                .map((account) {
                  final color = account.getThemeColor(context);
                  return DropdownMenuItem<String>(
                    value: account.id,
                    child: Row(
                      children: [
                        Icon(
                          account.icon,
                          color: color,
                          size: 20.0.r,
                        ),
                        SizedBox(width: 8.0.w),
                        Expanded(
                          child: Text(
                            '${account.name} (${formatCurrency(account.balance, account.currencyCode, context)})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                })
                .toList(),
            onChanged: (val) {
              if (val != null) {
                onTargetAccountChanged(val);
              }
            },
          ),
        ],
      ],
    );
  }
}
