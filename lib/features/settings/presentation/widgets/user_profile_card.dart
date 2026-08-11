import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../user/domain/entities/user.dart';
import 'settings_dialogs.dart';

class UserProfileCard extends StatelessWidget {
  final User user;
  final bool Function(String) matchesSearch;
  final Future<void> Function(ImageSource) onPickProfileImage;
  final VoidCallback onRemovePhoto;

  const UserProfileCard({
    super.key,
    required this.user,
    required this.matchesSearch,
    required this.onPickProfileImage,
    required this.onRemovePhoto,
  });

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
                  onPickProfileImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  onPickProfileImage(ImageSource.camera);
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
                  onRemovePhoto();
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
    final imagePath = user.profileImagePath;
    final imageFile = imagePath != null ? File(imagePath) : null;
    final hasValidImage = imageFile != null && imageFile.existsSync();

    return Column(
      children: [
        SizedBox(height: 16.0.h),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 44.0.r,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: hasValidImage ? FileImage(imageFile) : null,
                child: !hasValidImage
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'F',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0.sp,
                            ),
                      )
                    : null,
              ),
              CircleAvatar(
                radius: 16.0.r,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.camera_alt,
                    size: 16.0.r,
                    color: Colors.white,
                  ),
                  onPressed: () => _showImageSourcePicker(context),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0.h),
        if (matchesSearch(l10n.nameLabel))
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.nameLabel),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(width: 4.0.w),
                Icon(Icons.chevron_right, size: 20.0.r),
              ],
            ),
            onTap: () => SettingsDialogs.showEditNameDialog(context, user),
          ),
        if (matchesSearch(l10n.languageLabel)) ...[
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageLabel),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.preferredLanguage.toLowerCase() == 'ar'
                      ? 'العربية'
                      : 'English',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(width: 4.0.w),
                Icon(Icons.chevron_right, size: 20.0.r),
              ],
            ),
            onTap: () => SettingsDialogs.showLanguagePickerDialog(context, user),
          ),
        ],
        if (matchesSearch(l10n.currencyLabel)) ...[
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(l10n.currencyLabel),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.preferredCurrencyCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(width: 4.0.w),
                Icon(Icons.chevron_right, size: 20.0.r),
              ],
            ),
            onTap: () => SettingsDialogs.showCurrencyPickerDialog(context, user),
          ),
        ],
        if (matchesSearch(l10n.themeLabel)) ...[
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.themeLabel),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.themeMode.toLowerCase() == 'light'
                      ? l10n.themeLight
                      : (user.themeMode.toLowerCase() == 'dark'
                          ? l10n.themeDark
                          : l10n.themeSystem),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0.sp,
                      ),
                ),
                SizedBox(width: 4.0.w),
                Icon(Icons.chevron_right, size: 20.0.r),
              ],
            ),
            onTap: () => SettingsDialogs.showThemePickerDialog(context, user),
          ),
        ],
      ],
    );
  }
}
