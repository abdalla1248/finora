import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/cubit/user_cubit.dart';

class SettingsDialogs {
  static void showEditNameDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: user.name);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.nameLabel),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.nameLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  context.read<UserCubit>().updateName(newName);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
  }

  static void showLanguagePickerDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context);
    final currentLang = user.preferredLanguage.toLowerCase();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.languageLabel),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                trailing: currentLang == 'en'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateLanguage('en');
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('العربية (Arabic)'),
                trailing: currentLang == 'ar'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateLanguage('ar');
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void showCurrencyPickerDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context);
    final currencies = ['USD', 'EUR', 'GBP', 'EGP', 'SAR', 'AED'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.currencyLabel),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((c) {
              final isSelected = user.preferredCurrencyCode.toUpperCase() == c;
              return ListTile(
                title: Text(c),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateCurrency(c);
                  Navigator.of(dialogContext).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  static void showThemePickerDialog(BuildContext context, User user) {
    final l10n = AppLocalizations.of(context);
    final currentMode = user.themeMode.toLowerCase();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.themeLabel),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: Text(l10n.themeSystem),
                trailing: currentMode == 'system'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateUser(
                    user.copyWith(themeMode: 'system'),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: Text(l10n.themeLight),
                trailing: currentMode == 'light'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateUser(
                    user.copyWith(themeMode: 'light'),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(l10n.themeDark),
                trailing: currentMode == 'dark'
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<UserCubit>().updateUser(
                    user.copyWith(themeMode: 'dark'),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
