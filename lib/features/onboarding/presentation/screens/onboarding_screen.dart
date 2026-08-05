import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _currentPage = 0;
  String _selectedLanguage = 'en';
  String _selectedCurrency = 'USD';
  String _selectedTheme = 'system';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded && state.user != null) {
          context.go('/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header progress indicators
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: Container(
                        height: 4.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: _currentPage >= index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Page View Slides
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    // Slide 1: Offline First
                    _buildIntroSlide(
                      icon: Icons.wifi_off,
                      title: l10n.onboardingOfflineTitle,
                      description: l10n.onboardingOfflineDesc,
                    ),
                    // Slide 2: Privacy First
                    _buildIntroSlide(
                      icon: Icons.security,
                      title: l10n.onboardingPrivacyTitle,
                      description: l10n.onboardingPrivacyDesc,
                    ),
                    // Slide 3: Smart Analytics
                    _buildIntroSlide(
                      icon: Icons.insights,
                      title: l10n.onboardingAnalyticsTitle,
                      description: l10n.onboardingAnalyticsDesc,
                    ),
                    // Slide 4: User Profile Setup Form
                    _buildSetupSlide(l10n),
                  ],
                ),
              ),

              // Footer navigation buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: _currentPage < 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                3,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text('Skip'),
                          ),
                          ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                                vertical: 12.0,
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSlide({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96.0, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 32.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupSlide(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingSetupTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              l10n.onboardingSetupDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.nameLabel,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.nameRequiredError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: InputDecoration(
                labelText: l10n.languageLabel,
                border: const OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedCurrency,
              decoration: InputDecoration(
                labelText: l10n.currencyLabel,
                border: const OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                DropdownMenuItem(value: 'GBP', child: Text('GBP (£)')),
                DropdownMenuItem(value: 'EGP', child: Text('EGP (E£)')),
                DropdownMenuItem(value: 'SAR', child: Text('SAR (ر.س)')),
                DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedTheme,
              decoration: InputDecoration(
                labelText: l10n.themeLabel,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem(value: 'light', child: Text(l10n.themeLight)),
                DropdownMenuItem(value: 'dark', child: Text(l10n.themeDark)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<UserCubit>().createUser(
                    name: _nameController.text.trim(),
                    preferredCurrencyCode: _selectedCurrency,
                    preferredLanguage: _selectedLanguage,
                    themeMode: _selectedTheme,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(l10n.getStartedButton),
            ),
          ],
        ),
      ),
    );
  }
}
