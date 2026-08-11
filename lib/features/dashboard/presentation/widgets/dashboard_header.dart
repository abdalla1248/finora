import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../user/domain/entities/user.dart';

class DashboardHeader extends StatelessWidget {
  final GlobalKey welcomeHeaderKey;
  final User? user;

  const DashboardHeader({
    super.key,
    required this.welcomeHeaderKey,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userName = user != null ? user!.name : 'User';
    final currency = user != null ? user!.preferredCurrencyCode : 'USD';
    final imagePath = user?.profileImagePath;
    final imageFile = imagePath != null ? File(imagePath) : null;
    final hasValidImage = imageFile != null && imageFile.existsSync();

    return Card(
      key: welcomeHeaderKey,
      elevation: 2.0,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: hasValidImage ? FileImage(imageFile) : null,
              child: !hasValidImage
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : null,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardWelcome(userName),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    l10n.primaryCurrencyHeader(currency),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
