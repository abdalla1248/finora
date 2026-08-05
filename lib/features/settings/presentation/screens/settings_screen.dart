import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _searchQuery = '';

  bool _matchesSearch(String label) {
    if (_searchQuery.isEmpty) return true;
    return label.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        await context.read<UserCubit>().updateProfilePhoto(picked.path);
      }
    } catch (_) {}
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  _pickProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  _pickProfileImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  context.read<UserCubit>().updateProfilePhoto(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context, User user) {
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

  void _showLanguagePickerDialog(BuildContext context, User user) {
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

  void _showCurrencyPickerDialog(BuildContext context, User user) {
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

  void _showThemePickerDialog(BuildContext context, User user) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded && state.user == null) {
          context.go('/');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: ResponsiveCenteredView(
          child: ListView(
            padding: EdgeInsets.all(16.0.r),
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchSettingsHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 24.0.h),

              // Account Profile Section
              if (_matchesSearch(l10n.accountProfile) ||
                  _matchesSearch(l10n.nameLabel) ||
                  _matchesSearch(l10n.languageLabel) ||
                  _matchesSearch(l10n.currencyLabel) ||
                  _matchesSearch(l10n.themeLabel)) ...[
                _SectionHeader(title: l10n.accountProfile),
                SizedBox(height: 8.0.h),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserLoaded && state.user != null) {
                        final user = state.user!;
                        final imagePath = user.profileImagePath;
                        final imageFile = imagePath != null
                            ? File(imagePath)
                            : null;
                        final hasValidImage =
                            imageFile != null && imageFile.existsSync();

                        return Column(
                          children: [
                            SizedBox(height: 16.0.h),
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 44.0.r,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    backgroundImage: hasValidImage
                                        ? FileImage(imageFile)
                                        : null,
                                    child: !hasValidImage
                                        ? Text(
                                            user.name.isNotEmpty
                                                ? user.name[0].toUpperCase()
                                                : 'F',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32.0.sp,
                                                ),
                                          )
                                        : null,
                                  ),
                                  CircleAvatar(
                                    radius: 16.0.r,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.camera_alt,
                                        size: 16.0.r,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          _showImageSourcePicker(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0.h),
                            if (_matchesSearch(l10n.nameLabel))
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(l10n.nameLabel),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0.sp,
                                          ),
                                    ),
                                    SizedBox(width: 4.0.w),
                                    Icon(Icons.chevron_right, size: 20.0.r),
                                  ],
                                ),
                                onTap: () => _showEditNameDialog(context, user),
                              ),
                            if (_matchesSearch(l10n.languageLabel)) ...[
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: Text(l10n.languageLabel),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.preferredLanguage.toLowerCase() ==
                                              'ar'
                                          ? 'العربية'
                                          : 'English',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0.sp,
                                          ),
                                    ),
                                    SizedBox(width: 4.0.w),
                                    Icon(Icons.chevron_right, size: 20.0.r),
                                  ],
                                ),
                                onTap: () =>
                                    _showLanguagePickerDialog(context, user),
                              ),
                            ],
                            if (_matchesSearch(l10n.currencyLabel)) ...[
                              ListTile(
                                leading: const Icon(Icons.attach_money),
                                title: Text(l10n.currencyLabel),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.preferredCurrencyCode,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0.sp,
                                          ),
                                    ),
                                    SizedBox(width: 4.0.w),
                                    Icon(Icons.chevron_right, size: 20.0.r),
                                  ],
                                ),
                                onTap: () =>
                                    _showCurrencyPickerDialog(context, user),
                              ),
                            ],
                            if (_matchesSearch(l10n.themeLabel)) ...[
                              ListTile(
                                leading: const Icon(Icons.palette_outlined),
                                title: Text(l10n.themeLabel),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.themeMode.toLowerCase() == 'light'
                                          ? l10n.themeLight
                                          : (user.themeMode.toLowerCase() ==
                                                    'dark'
                                                ? l10n.themeDark
                                                : l10n.themeSystem),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0.sp,
                                          ),
                                    ),
                                    SizedBox(width: 4.0.w),
                                    Icon(Icons.chevron_right, size: 20.0.r),
                                  ],
                                ),
                                onTap: () =>
                                    _showThemePickerDialog(context, user),
                              ),
                            ],
                          ],
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Loading user preferences...'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.0.h),
              ],

              // Help & Tutorials Section

              // Management Section
              if (_matchesSearch(l10n.accountsTitle) ||
                  _matchesSearch(l10n.categoriesTitle) ||
                  _matchesSearch(l10n.backupExportTitle)) ...[
                _SectionHeader(title: l10n.managementSectionTitle),
                SizedBox(height: 8.0.h),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Column(
                    children: [
                      if (_matchesSearch(l10n.accountsTitle))
                        ListTile(
                          leading: const Icon(Icons.account_balance),
                          title: Text(l10n.accountsTitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/accounts'),
                        ),
                      if (_matchesSearch(l10n.categoriesTitle)) ...[
                        ListTile(
                          leading: const Icon(Icons.category),
                          title: Text(l10n.categoriesTitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/categories'),
                        ),
                      ],
                      if (_matchesSearch(l10n.backupExportTitle)) ...[
                        ListTile(
                          leading: const Icon(Icons.backup),
                          title: Text(l10n.backupExportTitle),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/backup'),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 24.0.h),
              ],

              // About Section
              if (_matchesSearch(l10n.aboutTitle) ||
                  _matchesSearch(l10n.versionLabel) ||
                  _matchesSearch(l10n.licensesLabel)) ...[
                _SectionHeader(title: l10n.aboutTitle),
                SizedBox(height: 8.0.h),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text(l10n.appTitle),
                        subtitle: Text(l10n.versionLabel),
                      ),

                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(l10n.licensesLabel),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'Finora',
                            applicationVersion: '1.0.0',
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: Text(l10n.privacyPolicyLabel),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoonMessage)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0.h),
              ],

              // Danger Zone
              if (_matchesSearch(l10n.resetDataButton)) ...[
                _SectionHeader(title: l10n.dangerZoneTitle),
                SizedBox(height: 8.0.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<UserCubit>().clearUser();
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: Text(l10n.resetDataButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16.0.sp,
      ),
    );
  }
}
