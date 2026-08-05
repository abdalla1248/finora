import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../budget/presentation/screens/budget_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class HomeShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final PageController _pageController;

  static const List<Widget> _pages = [
    DashboardScreen(),
    BudgetScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex !=
        oldWidget.navigationShell.currentIndex) {
      if (_pageController.hasClients &&
          _pageController.page?.round() !=
              widget.navigationShell.currentIndex) {
        _pageController.animateToPage(
          widget.navigationShell.currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.navigationShell.currentIndex,
        height: 65.0,
        color: theme.colorScheme.surfaceContainerHighest,
        buttonBackgroundColor: theme.colorScheme.primaryContainer,
        backgroundColor: theme.colorScheme.surface,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
          }
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.dashboard, color: theme.colorScheme.onSurface),
            label: l10n.appTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.pie_chart, color: theme.colorScheme.onSurface),
            label: l10n.budgetsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.trending_up, color: theme.colorScheme.onSurface),
            label: l10n.analyticsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings, color: theme.colorScheme.onSurface),
            label: l10n.settingsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
