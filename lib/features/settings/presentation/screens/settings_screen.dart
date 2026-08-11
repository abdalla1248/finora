import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import '../widgets/user_profile_card.dart';

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
                        return UserProfileCard(
                          user: state.user!,
                          matchesSearch: _matchesSearch,
                          onPickProfileImage: _pickProfileImage,
                          onRemovePhoto: () {
                            context.read<UserCubit>().updateProfilePhoto(null);
                          },
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

              // Management Section
              if (_matchesSearch(l10n.accountsTitle) ||
                  _matchesSearch(l10n.categoriesTitle) ||
                  _matchesSearch(l10n.notificationsTitle) ||
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
                      if (_matchesSearch(l10n.notificationsTitle)) ...[
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: Text(l10n.notificationsTitle),
                          subtitle: Text(l10n.notificationsDesc),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/settings/notifications'),
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
