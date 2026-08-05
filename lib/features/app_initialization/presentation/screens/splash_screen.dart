import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/app_initialization_cubit.dart';
import '../cubit/app_initialization_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial boot check
    context.read<AppInitializationCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AppInitializationCubit, AppInitializationState>(
      listener: (context, state) {
        if (state is AppInitializationOnboardingRequired) {
          context.go('/onboarding');
        } else if (state is AppInitializationCompleted) {
          context.go('/home');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 80.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24.0),
              Text(
                l10n.splashTitle,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                l10n.splashSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 48.0),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
