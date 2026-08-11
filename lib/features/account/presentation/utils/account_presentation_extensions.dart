import 'package:flutter/material.dart';
import '../../../../core/design_system/color_schemes.dart';
import '../../domain/entities/account.dart';

extension AccountPresentationExtension on Account {
  IconData get icon {
    if (iconData != null) {
      switch (iconData) {
        case 'wallet':
          return Icons.account_balance_wallet;
        case 'savings':
          return Icons.savings_outlined;
        case 'bank':
          return Icons.account_balance;
        case 'cash':
          return Icons.money;
        case 'card':
          return Icons.credit_card;
        case 'investment':
          return Icons.trending_up;
      }
    }
    switch (type) {
      case AccountType.cash:
        return Icons.money;
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.wallet:
        return Icons.account_balance_wallet;
      case AccountType.business:
        return Icons.business;
    }
  }

  Color getThemeColor(BuildContext context) {
    if (colorHex != null && colorHex!.isNotEmpty) {
      return FinoraColorSchemes.parseHexColor(colorHex!);
    }
    return Theme.of(context).colorScheme.primary;
  }
}

extension AccountTypePresentationExtension on AccountType {
  IconData get defaultIcon {
    switch (this) {
      case AccountType.cash:
        return Icons.money;
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.wallet:
        return Icons.account_balance_wallet;
      case AccountType.business:
        return Icons.business;
    }
  }
}
