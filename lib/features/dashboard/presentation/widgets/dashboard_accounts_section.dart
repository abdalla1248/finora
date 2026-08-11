import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/domain/entities/account.dart';
import '../../../account/presentation/utils/account_presentation_extensions.dart';

class DashboardAccountsSection extends StatelessWidget {
  final GlobalKey accountsSectionKey;
  final List<Account> accounts;

  const DashboardAccountsSection({
    super.key,
    required this.accountsSectionKey,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Column(
      key: accountsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.accountsTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                context.push('/accounts');
              },
              child: Text(l10n.viewAllButton),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 85.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final color = account.getThemeColor(context);
              return Card(
                elevation: 2.0,
                shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                margin: const EdgeInsetsDirectional.only(end: 12.0),
                child: InkWell(
                  onTap: () => context.push('/accounts/details/${account.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Icon(
                            account.icon,
                            color: color,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  account.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (account.isDefault) ...[
                                  const SizedBox(width: 4.0),
                                  Icon(
                                    Icons.star,
                                    size: 12.0,
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              formatCurrency(
                                account.balance,
                                account.currencyCode,
                                context,
                              ),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
