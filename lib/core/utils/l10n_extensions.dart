import 'package:flutter/material.dart';
import '../../features/account/domain/entities/account.dart';
import '../../features/budget/domain/entities/budget.dart';
import '../../l10n/app_localizations.dart';

extension AccountTypeL10n on AccountType {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case AccountType.cash:
        return l10n.accountTypeCash;
      case AccountType.bank:
        return l10n.accountTypeBank;
      case AccountType.savings:
        return l10n.accountTypeSavings;
      case AccountType.creditCard:
        return l10n.accountTypeCreditCard;
      case AccountType.wallet:
        return l10n.accountTypeWallet;
      case AccountType.business:
        return l10n.accountTypeBusiness;
    }
  }
}

extension BudgetTypeL10n on BudgetType {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case BudgetType.daily:
        return l10n.budgetTypeDaily;
      case BudgetType.weekly:
        return l10n.budgetTypeWeekly;
      case BudgetType.monthly:
        return l10n.budgetTypeMonthly;
      case BudgetType.yearly:
        return l10n.budgetTypeYearly;
      case BudgetType.custom:
        return l10n.budgetTypeCustom;
    }
  }
}
