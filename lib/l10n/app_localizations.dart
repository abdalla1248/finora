import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Finora'**
  String get appTitle;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Finora'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline-First Personal Finance'**
  String get splashSubtitle;

  /// No description provided for @onboardingOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline First'**
  String get onboardingOfflineTitle;

  /// No description provided for @onboardingOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Your financial data stays 100% on your device. No cloud connectivity required.'**
  String get onboardingOfflineDesc;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Zero trackers, zero ads, and zero third-party analytics. Total financial privacy.'**
  String get onboardingPrivacyDesc;

  /// No description provided for @onboardingAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Insights'**
  String get onboardingAnalyticsTitle;

  /// No description provided for @onboardingAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated categorization and visual cashflow insights designed to simplify budget management.'**
  String get onboardingAnalyticsDesc;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Your Profile'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Personalize Finora with your name, preferred currency, and theme settings.'**
  String get onboardingSetupDesc;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get nameLabel;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequiredError;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get languageLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Currency'**
  String get currencyLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme Preference'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String dashboardWelcome(String name);

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Log your expenses and income to start tracking your budget targets and cash flow analytics.'**
  String get dashboardEmptyDesc;

  /// No description provided for @addTransactionCta.
  ///
  /// In en, this message translates to:
  /// **'Add First Transaction'**
  String get addTransactionCta;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get comingSoonMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @accountProfile.
  ///
  /// In en, this message translates to:
  /// **'Account Profile'**
  String get accountProfile;

  /// No description provided for @resetDataButton.
  ///
  /// In en, this message translates to:
  /// **'Reset All Local Data'**
  String get resetDataButton;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get categoryFood;

  /// No description provided for @categoryTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get categoryTransportation;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get categoryBills;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & Medical'**
  String get categoryHealth;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categorySubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get categorySubscription;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get categoryInvestment;

  /// No description provided for @categoryGift.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGift;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categoryTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get categoryTransfer;

  /// No description provided for @typeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get typeExpense;

  /// No description provided for @typeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get typeIncome;

  /// No description provided for @typeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get typeTransfer;

  /// No description provided for @filterAllDates.
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get filterAllDates;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get filterYesterday;

  /// No description provided for @filterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get filterThisWeek;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get filterThisMonth;

  /// No description provided for @filterCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get filterCustomRange;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get sortOldest;

  /// No description provided for @sortHighestAmount.
  ///
  /// In en, this message translates to:
  /// **'Highest Amount'**
  String get sortHighestAmount;

  /// No description provided for @sortLowestAmount.
  ///
  /// In en, this message translates to:
  /// **'Lowest Amount'**
  String get sortLowestAmount;

  /// No description provided for @sortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortAlphabetical;

  /// No description provided for @addTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransactionTitle;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransactionTitle;

  /// No description provided for @transactionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetailsTitle;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction? This action cannot be undone.'**
  String get deleteTransactionConfirmMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveButton;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @titleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a transaction title'**
  String get titleRequiredError;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get amountRequiredError;

  /// No description provided for @amountPositiveError.
  ///
  /// In en, this message translates to:
  /// **'Amount must be a positive number'**
  String get amountPositiveError;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get noteLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @searchTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search title, note, category...'**
  String get searchTransactionsHint;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get filterTitle;

  /// No description provided for @clearFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFiltersButton;

  /// No description provided for @totalIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get totalIncomeLabel;

  /// No description provided for @totalExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get totalExpenseLabel;

  /// No description provided for @netBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalanceLabel;

  /// No description provided for @recentTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactionsTitle;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No matching transactions found.'**
  String get noTransactionsFound;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Financial Analytics Available'**
  String get analyticsEmptyTitle;

  /// No description provided for @analyticsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your income and expenses to unlock visual charts, category breakdowns, and savings metrics.'**
  String get analyticsEmptyDesc;

  /// No description provided for @savingsRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Savings Rate'**
  String get savingsRateLabel;

  /// No description provided for @insightHighestCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Expense Category'**
  String get insightHighestCategoryTitle;

  /// No description provided for @insightHighestCategoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest total expense recorded in this period.'**
  String get insightHighestCategoryDesc;

  /// No description provided for @insightLargestExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Single Largest Expense'**
  String get insightLargestExpenseTitle;

  /// No description provided for @insightLargestExpenseDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest individual expense logged.'**
  String get insightLargestExpenseDesc;

  /// No description provided for @insightLargestIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Single Largest Income'**
  String get insightLargestIncomeTitle;

  /// No description provided for @insightLargestIncomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest individual income deposit logged.'**
  String get insightLargestIncomeDesc;

  /// No description provided for @insightSavingsRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings Rate Ratio'**
  String get insightSavingsRateTitle;

  /// No description provided for @insightSavingsRateDesc.
  ///
  /// In en, this message translates to:
  /// **'Percentage of total income saved.'**
  String get insightSavingsRateDesc;

  /// No description provided for @insightAvgDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Expense'**
  String get insightAvgDailyTitle;

  /// No description provided for @insightAvgDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculated daily spending rate.'**
  String get insightAvgDailyDesc;

  /// No description provided for @periodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// No description provided for @periodYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get periodYesterday;

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get periodThisWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get periodThisMonth;

  /// No description provided for @periodLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get periodLastMonth;

  /// No description provided for @periodThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get periodThisYear;

  /// No description provided for @periodAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get periodAllTime;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets & Goals'**
  String get budgetsTitle;

  /// No description provided for @budgetsTab.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTab;

  /// No description provided for @goalsTab.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get goalsTab;

  /// No description provided for @noBudgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Active Budgets'**
  String get noBudgetsTitle;

  /// No description provided for @noBudgetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Set up monthly spending targets to keep your expenses under control.'**
  String get noBudgetsDesc;

  /// No description provided for @addBudgetCta.
  ///
  /// In en, this message translates to:
  /// **'Create First Budget'**
  String get addBudgetCta;

  /// No description provided for @noGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Savings Goals Yet'**
  String get noGoalsTitle;

  /// No description provided for @noGoalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Define target goals for vacations, emergency funds, or investments.'**
  String get noGoalsDesc;

  /// No description provided for @addGoalCta.
  ///
  /// In en, this message translates to:
  /// **'Create First Savings Goal'**
  String get addGoalCta;

  /// No description provided for @addBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get addBudgetTitle;

  /// No description provided for @editBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudgetTitle;

  /// No description provided for @budgetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Name'**
  String get budgetNameLabel;

  /// No description provided for @budgetNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget name'**
  String get budgetNameRequiredError;

  /// No description provided for @addGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Savings Goal'**
  String get addGoalTitle;

  /// No description provided for @editGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Savings Goal'**
  String get editGoalTitle;

  /// No description provided for @goalTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal Title'**
  String get goalTitleLabel;

  /// No description provided for @goalTitleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a goal title'**
  String get goalTitleRequiredError;

  /// No description provided for @targetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Amount'**
  String get targetAmountLabel;

  /// No description provided for @currentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Saved Amount'**
  String get currentAmountLabel;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Deadline'**
  String get deadlineLabel;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @noAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Accounts Yet'**
  String get noAccountsTitle;

  /// No description provided for @noAccountsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create financial accounts to track balances across wallets, banks, and credit cards.'**
  String get noAccountsDesc;

  /// No description provided for @addAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create First Account'**
  String get addAccountCta;

  /// No description provided for @addAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get addAccountTitle;

  /// No description provided for @editAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccountTitle;

  /// No description provided for @accountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountNameLabel;

  /// No description provided for @accountNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an account name'**
  String get accountNameRequiredError;

  /// No description provided for @accountTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountTypeLabel;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @expenseCategoriesTab.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseCategoriesTab;

  /// No description provided for @incomeCategoriesTab.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeCategoriesTab;

  /// No description provided for @noCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Custom Categories'**
  String get noCategoriesTitle;

  /// No description provided for @noCategoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Create custom categories to organize your transactions.'**
  String get noCategoriesDesc;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get addCategoryTitle;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get categoryNameRequiredError;

  /// No description provided for @categoryTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Category Type'**
  String get categoryTypeLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category? This action cannot be undone.'**
  String get deleteCategoryConfirm;

  /// No description provided for @backupExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Export'**
  String get backupExportTitle;

  /// No description provided for @exportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportSectionTitle;

  /// No description provided for @exportJsonLabel.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportJsonLabel;

  /// No description provided for @exportJsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Full database backup in JSON format.'**
  String get exportJsonDesc;

  /// No description provided for @exportCsvLabel.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportCsvLabel;

  /// No description provided for @exportCsvDesc.
  ///
  /// In en, this message translates to:
  /// **'Export transactions as a spreadsheet-compatible CSV file.'**
  String get exportCsvDesc;

  /// No description provided for @dataManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagementTitle;

  /// No description provided for @factoryResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get factoryResetLabel;

  /// No description provided for @factoryResetDesc.
  ///
  /// In en, this message translates to:
  /// **'Erase all local data and restore the application to its initial state.'**
  String get factoryResetDesc;

  /// No description provided for @factoryResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your data including transactions, budgets, accounts, and settings. This action cannot be undone.'**
  String get factoryResetConfirm;

  /// No description provided for @searchSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get searchSettingsHint;

  /// No description provided for @managementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get managementSectionTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionLabel;

  /// No description provided for @licensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get licensesLabel;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @dangerZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZoneTitle;

  /// No description provided for @primaryCurrencyHeader.
  ///
  /// In en, this message translates to:
  /// **'Primary Currency: {currency}'**
  String primaryCurrencyHeader(String currency);

  /// No description provided for @activeBudgetPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Budget Preview'**
  String get activeBudgetPreviewTitle;

  /// No description provided for @viewAllButton.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllButton;

  /// No description provided for @statusOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get statusOnTrack;

  /// No description provided for @statusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning (70%+)'**
  String get statusWarning;

  /// No description provided for @statusCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical (90%+)'**
  String get statusCritical;

  /// No description provided for @statusExceeded.
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get statusExceeded;

  /// No description provided for @spentLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent: {amount}'**
  String spentLabel(String amount);

  /// No description provided for @remainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String remainingLabel(String amount);

  /// No description provided for @contributeGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Contribute to Goal'**
  String get contributeGoalTitle;

  /// No description provided for @contributeButton.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contributeButton;

  /// No description provided for @depositAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Deposit Amount'**
  String get depositAmountLabel;

  /// No description provided for @sourceAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'From Account'**
  String get sourceAccountLabel;

  /// No description provided for @targetAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'To Account'**
  String get targetAccountLabel;

  /// No description provided for @importJsonLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore from JSON Backup'**
  String get importJsonLabel;

  /// No description provided for @importJsonDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore transactions, accounts, budgets, and goals from a JSON backup file.'**
  String get importJsonDesc;

  /// No description provided for @shareFileButton.
  ///
  /// In en, this message translates to:
  /// **'Share File'**
  String get shareFileButton;

  /// No description provided for @openFileButton.
  ///
  /// In en, this message translates to:
  /// **'Open File'**
  String get openFileButton;

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Finora!'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'This is your dashboard. Every transaction belongs to a Financial Account (like Bank or Cash). We\'ve seeded a default \'Main Cash\' account for you, which you can replace or edit from Settings.'**
  String get tutorialWelcomeDesc;

  /// No description provided for @tutorialOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get tutorialOverviewTitle;

  /// No description provided for @tutorialOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your total net balance, monthly income, and expenses in real-time.'**
  String get tutorialOverviewDesc;

  /// No description provided for @tutorialFabTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Add Transaction'**
  String get tutorialFabTitle;

  /// No description provided for @tutorialFabDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap here anytime to quickly log a new income, expense, or transfer transaction.'**
  String get tutorialFabDesc;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @tutorialPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tutorialPrev;

  /// No description provided for @tutorialSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorialSkip;

  /// No description provided for @tutorialFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get tutorialFinish;

  /// No description provided for @duplicateBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Already Exists'**
  String get duplicateBudgetTitle;

  /// No description provided for @duplicateBudgetMessage.
  ///
  /// In en, this message translates to:
  /// **'A budget already exists for the selected category. What would you like to do?'**
  String get duplicateBudgetMessage;

  /// No description provided for @btnUpdateBudget.
  ///
  /// In en, this message translates to:
  /// **'Replace Amount'**
  String get btnUpdateBudget;

  /// No description provided for @btnIncreaseBudget.
  ///
  /// In en, this message translates to:
  /// **'Increase Amount'**
  String get btnIncreaseBudget;

  /// No description provided for @btnDecreaseBudget.
  ///
  /// In en, this message translates to:
  /// **'Decrease Amount'**
  String get btnDecreaseBudget;

  /// No description provided for @overviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTab;

  /// No description provided for @transactionsTab.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTab;

  /// No description provided for @analyticsTab.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTab;

  /// No description provided for @goalStatusToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get goalStatusToday;

  /// No description provided for @goalStatusTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get goalStatusTomorrow;

  /// No description provided for @goalStatusDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String goalStatusDaysLeft(Object days);

  /// No description provided for @goalStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get goalStatusExpired;

  /// No description provided for @goalStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalStatusCompleted;

  /// No description provided for @savedAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved: {amount}'**
  String savedAmountLabel(Object amount);

  /// No description provided for @targetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target: {amount}'**
  String targetLabel(Object amount);

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark Completed'**
  String get markAsCompleted;

  /// No description provided for @tutorialAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Accounts'**
  String get tutorialAccountsTitle;

  /// No description provided for @tutorialAccountsDesc.
  ///
  /// In en, this message translates to:
  /// **'Every transaction belongs to a Financial Account (like cash or bank). We have seeded a default \'Main Cash\' account for you. You can add new accounts, edit them, or select them from the Settings tab.'**
  String get tutorialAccountsDesc;

  /// No description provided for @deleteAccountErrorHasTransactions.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete account because it still contains transactions. Please delete or reassign those transactions first.'**
  String get deleteAccountErrorHasTransactions;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @accountIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Icon'**
  String get accountIconLabel;

  /// No description provided for @defaultAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Default Account'**
  String get defaultAccountLabel;

  /// No description provided for @defaultAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Use this account as the default for new transactions'**
  String get defaultAccountDesc;

  /// No description provided for @accountTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountTypeCash;

  /// No description provided for @accountTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountTypeBank;

  /// No description provided for @accountTypeSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get accountTypeSavings;

  /// No description provided for @accountTypeCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get accountTypeCreditCard;

  /// No description provided for @accountTypeWallet.
  ///
  /// In en, this message translates to:
  /// **'Digital Wallet'**
  String get accountTypeWallet;

  /// No description provided for @accountTypeBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get accountTypeBusiness;

  /// No description provided for @budgetTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Budget'**
  String get budgetTypeDaily;

  /// No description provided for @budgetTypeWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly Budget'**
  String get budgetTypeWeekly;

  /// No description provided for @budgetTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get budgetTypeMonthly;

  /// No description provided for @budgetTypeYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly Budget'**
  String get budgetTypeYearly;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalanceLabel;

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @expensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesLabel;

  /// No description provided for @netCashFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Cash Flow'**
  String get netCashFlowLabel;

  /// No description provided for @totalTransactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get totalTransactionsLabel;

  /// No description provided for @creationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Creation Date'**
  String get creationDateLabel;

  /// No description provided for @lastActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivityLabel;

  /// No description provided for @monthlySpendLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Spend'**
  String get monthlySpendLabel;

  /// No description provided for @dailyAvgSpendLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg Spend'**
  String get dailyAvgSpendLabel;

  /// No description provided for @largestTxLabel.
  ///
  /// In en, this message translates to:
  /// **'Largest Tx'**
  String get largestTxLabel;

  /// No description provided for @cashFlowBreakdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Breakdown'**
  String get cashFlowBreakdownLabel;

  /// No description provided for @expensesByCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses by Category'**
  String get expensesByCategoryLabel;

  /// No description provided for @noExpenseRecordsLabel.
  ///
  /// In en, this message translates to:
  /// **'No expense records found for this account.'**
  String get noExpenseRecordsLabel;

  /// No description provided for @accountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetailsTitle;

  /// No description provided for @accountNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFoundError;

  /// No description provided for @budgetTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom Budget'**
  String get budgetTypeCustom;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationsTitle;

  /// No description provided for @notificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage reminder frequency, budget alerts, and spending reports'**
  String get notificationsDesc;

  /// No description provided for @budgetNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Alerts'**
  String get budgetNotificationsTitle;

  /// No description provided for @budgetNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Notify when budget reaches 50%, 80%, 100%, or is exceeded'**
  String get budgetNotificationsDesc;

  /// No description provided for @goalNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings Goal Alerts'**
  String get goalNotificationsTitle;

  /// No description provided for @goalNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Notify when goal is reached, expiring, or deadline arrives'**
  String get goalNotificationsDesc;

  /// No description provided for @reminderNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Reminders'**
  String get reminderNotificationsTitle;

  /// No description provided for @reminderNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Scheduled alerts to log daily/weekly expenses'**
  String get reminderNotificationsDesc;

  /// No description provided for @weeklySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummaryTitle;

  /// No description provided for @weeklySummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive a weekly overview of your spending'**
  String get weeklySummaryDesc;

  /// No description provided for @monthlySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummaryTitle;

  /// No description provided for @monthlySummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive a monthly financial report'**
  String get monthlySummaryDesc;

  /// No description provided for @reminderFrequencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Frequency'**
  String get reminderFrequencyTitle;

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeTitle;

  /// No description provided for @testNotificationButton.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get testNotificationButton;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent successfully!'**
  String get testNotificationSent;

  /// No description provided for @permissionStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get permissionStatusTitle;

  /// No description provided for @permissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get permissionGranted;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied (Tap to request)'**
  String get permissionDenied;

  /// No description provided for @requestPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get requestPermissionButton;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @freqDaily.
  ///
  /// In en, this message translates to:
  /// **'Every Day'**
  String get freqDaily;

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every Week'**
  String get freqWeekly;

  /// No description provided for @freqBiWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every 2 Weeks'**
  String get freqBiWeekly;

  /// No description provided for @freqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every Month'**
  String get freqMonthly;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
