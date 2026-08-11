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
    final targetIndex = widget.navigationShell.currentIndex;
    if (targetIndex != oldWidget.navigationShell.currentIndex) {
      if (_pageController.hasClients) {
        final currentPos = _pageController.page?.round() ?? targetIndex;
        if (currentPos != targetIndex) {
          if ((targetIndex - currentPos).abs() > 1) {
            _pageController.jumpToPage(targetIndex);
          }
        }
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
    final currentIndex = widget.navigationShell.currentIndex;

    // Show FAB on Dashboard tab (index 0)
    final showFab = currentIndex == 0;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      floatingActionButton: AnimatedScale(
        scale: showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            if (currentIndex == 0) {
              context.push('/transactions/add');
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 65.0,
        color: theme.colorScheme.surfaceContainerHighest,
        buttonBackgroundColor: theme.colorScheme.primaryContainer,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          if (_pageController.hasClients) {
            if ((index - currentIndex).abs() > 1) {
              _pageController.jumpToPage(index);
            } else {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
              );
            }
          }
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          );
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.dashboard,
              color: currentIndex == 0
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: l10n.appTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: currentIndex == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.pie_chart,
              color: currentIndex == 1
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: l10n.budgetsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: currentIndex == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.trending_up,
              color: currentIndex == 2
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: l10n.analyticsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: currentIndex == 2
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.settings,
              color: currentIndex == 3
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: l10n.settingsTitle,
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: currentIndex == 3
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
