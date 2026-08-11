// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finora';

  @override
  String get splashTitle => 'Finora';

  @override
  String get splashSubtitle => 'Offline-First Personal Finance';

  @override
  String get onboardingOfflineTitle => 'Offline First';

  @override
  String get onboardingOfflineDesc =>
      'Your financial data stays 100% on your device. No cloud connectivity required.';

  @override
  String get onboardingPrivacyTitle => 'Privacy First';

  @override
  String get onboardingPrivacyDesc =>
      'Zero trackers, zero ads, and zero third-party analytics. Total financial privacy.';

  @override
  String get onboardingAnalyticsTitle => 'Smart Insights';

  @override
  String get onboardingAnalyticsDesc =>
      'Automated categorization and visual cashflow insights designed to simplify budget management.';

  @override
  String get onboardingSetupTitle => 'Setup Your Profile';

  @override
  String get onboardingSetupDesc =>
      'Personalize Finora with your name, preferred currency, and theme settings.';

  @override
  String get nameLabel => 'Your Name';

  @override
  String get nameRequiredError => 'Please enter your name';

  @override
  String get languageLabel => 'Preferred Language';

  @override
  String get currencyLabel => 'Preferred Currency';

  @override
  String get themeLabel => 'Theme Preference';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String dashboardWelcome(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get dashboardEmptyTitle => 'No Transactions Yet';

  @override
  String get dashboardEmptyDesc =>
      'Log your expenses and income to start tracking your budget targets and cash flow analytics.';

  @override
  String get addTransactionCta => 'Add First Transaction';

  @override
  String get comingSoonMessage => 'Feature coming soon!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get accountProfile => 'Account Profile';

  @override
  String get resetDataButton => 'Reset All Local Data';

  @override
  String get categoryFood => 'Food & Dining';

  @override
  String get categoryTransportation => 'Transportation';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryBills => 'Bills & Utilities';

  @override
  String get categoryHealth => 'Health & Medical';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categorySubscription => 'Subscriptions';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryInvestment => 'Investments';

  @override
  String get categoryGift => 'Gifts';

  @override
  String get categoryOther => 'Other';

  @override
  String get categoryTransfer => 'Transfer';

  @override
  String get typeExpense => 'Expense';

  @override
  String get typeIncome => 'Income';

  @override
  String get typeTransfer => 'Transfer';

  @override
  String get filterAllDates => 'All Dates';

  @override
  String get filterToday => 'Today';

  @override
  String get filterYesterday => 'Yesterday';

  @override
  String get filterThisWeek => 'This Week';

  @override
  String get filterThisMonth => 'This Month';

  @override
  String get filterCustomRange => 'Custom Range';

  @override
  String get sortNewest => 'Newest First';

  @override
  String get sortOldest => 'Oldest First';

  @override
  String get sortHighestAmount => 'Highest Amount';

  @override
  String get sortLowestAmount => 'Lowest Amount';

  @override
  String get sortAlphabetical => 'Alphabetical';

  @override
  String get addTransactionTitle => 'Add Transaction';

  @override
  String get editTransactionTitle => 'Edit Transaction';

  @override
  String get transactionDetailsTitle => 'Transaction Details';

  @override
  String get deleteTransactionTitle => 'Delete Transaction';

  @override
  String get deleteTransactionConfirmMessage =>
      'Are you sure you want to delete this transaction? This action cannot be undone.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get saveButton => 'Save Transaction';

  @override
  String get titleLabel => 'Title';

  @override
  String get titleRequiredError => 'Please enter a transaction title';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountRequiredError => 'Please enter an amount';

  @override
  String get amountPositiveError => 'Amount must be a positive number';

  @override
  String get categoryLabel => 'Category';

  @override
  String get noteLabel => 'Notes (Optional)';

  @override
  String get dateLabel => 'Date';

  @override
  String get searchTransactionsHint => 'Search title, note, category...';

  @override
  String get filterTitle => 'Filter & Sort';

  @override
  String get clearFiltersButton => 'Clear Filters';

  @override
  String get totalIncomeLabel => 'Income';

  @override
  String get totalExpenseLabel => 'Expense';

  @override
  String get netBalanceLabel => 'Net Balance';

  @override
  String get recentTransactionsTitle => 'Recent Transactions';

  @override
  String get noTransactionsFound => 'No matching transactions found.';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsEmptyTitle => 'No Financial Analytics Available';

  @override
  String get analyticsEmptyDesc =>
      'Add your income and expenses to unlock visual charts, category breakdowns, and savings metrics.';

  @override
  String get savingsRateLabel => 'Savings Rate';

  @override
  String get insightHighestCategoryTitle => 'Top Expense Category';

  @override
  String get insightHighestCategoryDesc =>
      'Highest total expense recorded in this period.';

  @override
  String get insightLargestExpenseTitle => 'Single Largest Expense';

  @override
  String get insightLargestExpenseDesc => 'Highest individual expense logged.';

  @override
  String get insightLargestIncomeTitle => 'Single Largest Income';

  @override
  String get insightLargestIncomeDesc =>
      'Highest individual income deposit logged.';

  @override
  String get insightSavingsRateTitle => 'Savings Rate Ratio';

  @override
  String get insightSavingsRateDesc => 'Percentage of total income saved.';

  @override
  String get insightAvgDailyTitle => 'Average Daily Expense';

  @override
  String get insightAvgDailyDesc => 'Calculated daily spending rate.';

  @override
  String get periodToday => 'Today';

  @override
  String get periodYesterday => 'Yesterday';

  @override
  String get periodThisWeek => 'This Week';

  @override
  String get periodThisMonth => 'This Month';

  @override
  String get periodLastMonth => 'Last Month';

  @override
  String get periodThisYear => 'This Year';

  @override
  String get periodAllTime => 'All Time';

  @override
  String get budgetsTitle => 'Budgets & Goals';

  @override
  String get budgetsTab => 'Budgets';

  @override
  String get goalsTab => 'Savings Goals';

  @override
  String get noBudgetsTitle => 'No Active Budgets';

  @override
  String get noBudgetsDesc =>
      'Set up monthly spending targets to keep your expenses under control.';

  @override
  String get addBudgetCta => 'Create First Budget';

  @override
  String get noGoalsTitle => 'No Savings Goals Yet';

  @override
  String get noGoalsDesc =>
      'Define target goals for vacations, emergency funds, or investments.';

  @override
  String get addGoalCta => 'Create First Savings Goal';

  @override
  String get addBudgetTitle => 'Create Budget';

  @override
  String get editBudgetTitle => 'Edit Budget';

  @override
  String get budgetNameLabel => 'Budget Name';

  @override
  String get budgetNameRequiredError => 'Please enter a budget name';

  @override
  String get addGoalTitle => 'Create Savings Goal';

  @override
  String get editGoalTitle => 'Edit Savings Goal';

  @override
  String get goalTitleLabel => 'Goal Title';

  @override
  String get goalTitleRequiredError => 'Please enter a goal title';

  @override
  String get targetAmountLabel => 'Target Amount';

  @override
  String get currentAmountLabel => 'Current Saved Amount';

  @override
  String get deadlineLabel => 'Target Deadline';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get noAccountsTitle => 'No Accounts Yet';

  @override
  String get noAccountsDesc =>
      'Create financial accounts to track balances across wallets, banks, and credit cards.';

  @override
  String get addAccountCta => 'Create First Account';

  @override
  String get addAccountTitle => 'Create Account';

  @override
  String get editAccountTitle => 'Edit Account';

  @override
  String get accountNameLabel => 'Account Name';

  @override
  String get accountNameRequiredError => 'Please enter an account name';

  @override
  String get accountTypeLabel => 'Account Type';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get defaultLabel => 'Default';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete this account? This action cannot be undone.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get expenseCategoriesTab => 'Expense';

  @override
  String get incomeCategoriesTab => 'Income';

  @override
  String get noCategoriesTitle => 'No Custom Categories';

  @override
  String get noCategoriesDesc =>
      'Create custom categories to organize your transactions.';

  @override
  String get addCategoryTitle => 'Create Category';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get categoryNameRequiredError => 'Please enter a category name';

  @override
  String get categoryTypeLabel => 'Category Type';

  @override
  String get colorLabel => 'Color';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String get deleteCategoryConfirm =>
      'Are you sure you want to delete this category? This action cannot be undone.';

  @override
  String get backupExportTitle => 'Backup & Export';

  @override
  String get exportSectionTitle => 'Export Data';

  @override
  String get exportJsonLabel => 'Export as JSON';

  @override
  String get exportJsonDesc => 'Full database backup in JSON format.';

  @override
  String get exportCsvLabel => 'Export as CSV';

  @override
  String get exportCsvDesc =>
      'Export transactions as a spreadsheet-compatible CSV file.';

  @override
  String get dataManagementTitle => 'Data Management';

  @override
  String get factoryResetLabel => 'Factory Reset';

  @override
  String get factoryResetDesc =>
      'Erase all local data and restore the application to its initial state.';

  @override
  String get factoryResetConfirm =>
      'This will permanently delete all your data including transactions, budgets, accounts, and settings. This action cannot be undone.';

  @override
  String get searchSettingsHint => 'Search settings...';

  @override
  String get managementSectionTitle => 'Management';

  @override
  String get aboutTitle => 'About';

  @override
  String get versionLabel => 'Version 1.0.0';

  @override
  String get licensesLabel => 'Open Source Licenses';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get dangerZoneTitle => 'Danger Zone';

  @override
  String primaryCurrencyHeader(String currency) {
    return 'Primary Currency: $currency';
  }

  @override
  String get activeBudgetPreviewTitle => 'Active Budget Preview';

  @override
  String get viewAllButton => 'View All';

  @override
  String get statusOnTrack => 'On Track';

  @override
  String get statusWarning => 'Warning (70%+)';

  @override
  String get statusCritical => 'Critical (90%+)';

  @override
  String get statusExceeded => 'Exceeded';

  @override
  String spentLabel(String amount) {
    return 'Spent: $amount';
  }

  @override
  String remainingLabel(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String get contributeGoalTitle => 'Contribute to Goal';

  @override
  String get contributeButton => 'Contribute';

  @override
  String get depositAmountLabel => 'Deposit Amount';

  @override
  String get sourceAccountLabel => 'From Account';

  @override
  String get targetAccountLabel => 'To Account';

  @override
  String get importJsonLabel => 'Restore from JSON Backup';

  @override
  String get importJsonDesc =>
      'Restore transactions, accounts, budgets, and goals from a JSON backup file.';

  @override
  String get shareFileButton => 'Share File';

  @override
  String get openFileButton => 'Open File';

  @override
  String get tutorialWelcomeTitle => 'Welcome to Finora!';

  @override
  String get tutorialWelcomeDesc =>
      'This is your dashboard. Every transaction belongs to a Financial Account (like Bank or Cash). We\'ve seeded a default \'Main Cash\' account for you, which you can replace or edit from Settings.';

  @override
  String get tutorialOverviewTitle => 'Financial Overview';

  @override
  String get tutorialOverviewDesc =>
      'Track your total net balance, monthly income, and expenses in real-time.';

  @override
  String get tutorialFabTitle => 'Quick Add Transaction';

  @override
  String get tutorialFabDesc =>
      'Tap here anytime to quickly log a new income, expense, or transfer transaction.';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialPrev => 'Previous';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialFinish => 'Finish';

  @override
  String get duplicateBudgetTitle => 'Budget Already Exists';

  @override
  String get duplicateBudgetMessage =>
      'A budget already exists for the selected category. What would you like to do?';

  @override
  String get btnUpdateBudget => 'Replace Amount';

  @override
  String get btnIncreaseBudget => 'Increase Amount';

  @override
  String get btnDecreaseBudget => 'Decrease Amount';

  @override
  String get overviewTab => 'Overview';

  @override
  String get transactionsTab => 'Transactions';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get goalStatusToday => 'Today';

  @override
  String get goalStatusTomorrow => 'Tomorrow';

  @override
  String goalStatusDaysLeft(Object days) {
    return '$days days left';
  }

  @override
  String get goalStatusExpired => 'Expired';

  @override
  String get goalStatusCompleted => 'Completed';

  @override
  String savedAmountLabel(Object amount) {
    return 'Saved: $amount';
  }

  @override
  String targetLabel(Object amount) {
    return 'Target: $amount';
  }

  @override
  String get markAsCompleted => 'Mark Completed';

  @override
  String get tutorialAccountsTitle => 'Financial Accounts';

  @override
  String get tutorialAccountsDesc =>
      'Every transaction belongs to a Financial Account (like cash or bank). We have seeded a default \'Main Cash\' account for you. You can add new accounts, edit them, or select them from the Settings tab.';

  @override
  String get deleteAccountErrorHasTransactions =>
      'Cannot delete account because it still contains transactions. Please delete or reassign those transactions first.';

  @override
  String get okButton => 'OK';

  @override
  String get accountIconLabel => 'Account Icon';

  @override
  String get defaultAccountLabel => 'Default Account';

  @override
  String get defaultAccountDesc =>
      'Use this account as the default for new transactions';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeSavings => 'Savings';

  @override
  String get accountTypeCreditCard => 'Credit Card';

  @override
  String get accountTypeWallet => 'Digital Wallet';

  @override
  String get accountTypeBusiness => 'Business';

  @override
  String get budgetTypeDaily => 'Daily Budget';

  @override
  String get budgetTypeWeekly => 'Weekly Budget';

  @override
  String get budgetTypeMonthly => 'Monthly Budget';

  @override
  String get budgetTypeYearly => 'Yearly Budget';

  @override
  String get currentBalanceLabel => 'Current Balance';

  @override
  String get incomeLabel => 'Income';

  @override
  String get expensesLabel => 'Expenses';

  @override
  String get netCashFlowLabel => 'Net Cash Flow';

  @override
  String get totalTransactionsLabel => 'Total Transactions';

  @override
  String get creationDateLabel => 'Creation Date';

  @override
  String get lastActivityLabel => 'Last Activity';

  @override
  String get monthlySpendLabel => 'Monthly Spend';

  @override
  String get dailyAvgSpendLabel => 'Daily Avg Spend';

  @override
  String get largestTxLabel => 'Largest Tx';

  @override
  String get cashFlowBreakdownLabel => 'Cash Flow Breakdown';

  @override
  String get expensesByCategoryLabel => 'Expenses by Category';

  @override
  String get noExpenseRecordsLabel =>
      'No expense records found for this account.';

  @override
  String get accountDetailsTitle => 'Account Details';

  @override
  String get accountNotFoundError => 'Account not found';

  @override
  String get budgetTypeCustom => 'Custom Budget';

  @override
  String get notificationsTitle => 'Notification Settings';

  @override
  String get notificationsDesc =>
      'Manage reminder frequency, budget alerts, and spending reports';

  @override
  String get budgetNotificationsTitle => 'Budget Alerts';

  @override
  String get budgetNotificationsDesc =>
      'Notify when budget reaches 50%, 80%, 100%, or is exceeded';

  @override
  String get goalNotificationsTitle => 'Savings Goal Alerts';

  @override
  String get goalNotificationsDesc =>
      'Notify when goal is reached, expiring, or deadline arrives';

  @override
  String get reminderNotificationsTitle => 'Transaction Reminders';

  @override
  String get reminderNotificationsDesc =>
      'Scheduled alerts to log daily/weekly expenses';

  @override
  String get weeklySummaryTitle => 'Weekly Summary';

  @override
  String get weeklySummaryDesc => 'Receive a weekly overview of your spending';

  @override
  String get monthlySummaryTitle => 'Monthly Summary';

  @override
  String get monthlySummaryDesc => 'Receive a monthly financial report';

  @override
  String get reminderFrequencyTitle => 'Reminder Frequency';

  @override
  String get reminderTimeTitle => 'Reminder Time';

  @override
  String get testNotificationButton => 'Send Test Notification';

  @override
  String get testNotificationSent => 'Test notification sent successfully!';

  @override
  String get permissionStatusTitle => 'Notification Permission';

  @override
  String get permissionGranted => 'Granted';

  @override
  String get permissionDenied => 'Denied (Tap to request)';

  @override
  String get requestPermissionButton => 'Grant Permission';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusExpired => 'Expired';

  @override
  String get freqDaily => 'Every Day';

  @override
  String get freqWeekly => 'Every Week';

  @override
  String get freqBiWeekly => 'Every 2 Weeks';

  @override
  String get freqMonthly => 'Every Month';
}
