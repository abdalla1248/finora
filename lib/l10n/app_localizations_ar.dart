// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فينورا';

  @override
  String get splashTitle => 'فينورا';

  @override
  String get splashSubtitle => 'مدير المالية الشخصية المحلي';

  @override
  String get onboardingOfflineTitle => 'يعمل بدون إنترنت';

  @override
  String get onboardingOfflineDesc =>
      'جميع بياناتك المالية تبقى على جهازك 100%. لا حاجة للاتصال بالخادم.';

  @override
  String get onboardingPrivacyTitle => 'الخصوصية أولاً';

  @override
  String get onboardingPrivacyDesc =>
      'بدون تتبع، بدون إعلانات، وبدون تحليلات خارجية. خصوصية مالية تامة.';

  @override
  String get onboardingAnalyticsTitle => 'تحليلات ذكية';

  @override
  String get onboardingAnalyticsDesc =>
      'تصنيف تلقائي ورسوم بيانية لتسهيل إدارة ميزانيتك الشخصية.';

  @override
  String get onboardingSetupTitle => 'إعداد ملفك الشخصي';

  @override
  String get onboardingSetupDesc =>
      'خصص فينورا باسمك، عملتك المفضلة، والمظهر الذي يناسبك.';

  @override
  String get nameLabel => 'اسمك';

  @override
  String get nameRequiredError => 'يرجى إدخال اسمك';

  @override
  String get languageLabel => 'اللغة المفضلة';

  @override
  String get currencyLabel => 'العملة المفضلة';

  @override
  String get themeLabel => 'المظهر المفصل';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'المظهر الفاتح';

  @override
  String get themeDark => 'المظهر الداكن';

  @override
  String get getStartedButton => 'ابدأ الآن';

  @override
  String dashboardWelcome(String name) {
    return 'مرحباً بعودتك، $name!';
  }

  @override
  String get dashboardEmptyTitle => 'لا توجد معاملات بعد';

  @override
  String get dashboardEmptyDesc =>
      'سجل مصاريفك ودخلك للبدء في تتبع أهداف ميزانيتك ورسومك البيانية.';

  @override
  String get addTransactionCta => 'إضافة أول معاملة';

  @override
  String get comingSoonMessage => 'ميزة قادمة قريباً!';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get accountProfile => 'الملف الشخصي';

  @override
  String get resetDataButton => 'إعادة ضبط البيانات المحلية';

  @override
  String get categoryFood => 'الطعام والمطاعم';

  @override
  String get categoryTransportation => 'المواصلات';

  @override
  String get categoryShopping => 'التسوق';

  @override
  String get categoryEntertainment => 'الترفيه';

  @override
  String get categoryBills => 'الفواتير والخدمات';

  @override
  String get categoryHealth => 'الصحة والرعاية';

  @override
  String get categoryEducation => 'التعليم';

  @override
  String get categoryTravel => 'السفر';

  @override
  String get categorySubscription => 'الاشتراكات';

  @override
  String get categorySalary => 'الراتب';

  @override
  String get categoryFreelance => 'العمل الحر';

  @override
  String get categoryBusiness => 'الأعمال';

  @override
  String get categoryInvestment => 'الاستثمارات';

  @override
  String get categoryGift => 'الهدايا';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get categoryTransfer => 'تحويل';

  @override
  String get typeExpense => 'مصروف';

  @override
  String get typeIncome => 'دخل';

  @override
  String get typeTransfer => 'تحويل';

  @override
  String get filterAllDates => 'جميع التواريخ';

  @override
  String get filterToday => 'اليوم';

  @override
  String get filterYesterday => 'الأمس';

  @override
  String get filterThisWeek => 'هذا الأسبوع';

  @override
  String get filterThisMonth => 'هذا الشهر';

  @override
  String get filterCustomRange => 'نطاق مخصص';

  @override
  String get sortNewest => 'الأحدث أولاً';

  @override
  String get sortOldest => 'الأقدم أولاً';

  @override
  String get sortHighestAmount => 'الأعلى مبلغاً';

  @override
  String get sortLowestAmount => 'الأقل مبلغاً';

  @override
  String get sortAlphabetical => 'أبجدياً';

  @override
  String get addTransactionTitle => 'إضافة معاملة';

  @override
  String get editTransactionTitle => 'تعديل المعاملة';

  @override
  String get transactionDetailsTitle => 'تفاصيل المعاملة';

  @override
  String get deleteTransactionTitle => 'حذف المعاملة';

  @override
  String get deleteTransactionConfirmMessage =>
      'هل أنت تأكد من رغبتك في حذف هذه المعاملة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get deleteButton => 'حذف';

  @override
  String get saveButton => 'حفظ';

  @override
  String get titleLabel => 'العنوان';

  @override
  String get titleRequiredError => 'يرجى إدخال عنوان المعاملة';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get amountRequiredError => 'يرجى إدخال المبلغ';

  @override
  String get amountPositiveError => 'يجب أن يكون المبلغ رقماً موجباً';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get noteLabel => 'ملاحظات (اختياري)';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get searchTransactionsHint => 'البحث بالعنوان، الملاحظة، الفئة...';

  @override
  String get filterTitle => 'التصفية والفرز';

  @override
  String get clearFiltersButton => 'مسح التصفيات';

  @override
  String get totalIncomeLabel => 'الدخل';

  @override
  String get totalExpenseLabel => 'المصروف';

  @override
  String get netBalanceLabel => 'صافي الرصيد';

  @override
  String get recentTransactionsTitle => 'أحدث المعاملات';

  @override
  String get noTransactionsFound => 'لم يتم العثور على معاملات مطابقة.';

  @override
  String get analyticsTitle => 'التحليلات';

  @override
  String get analyticsEmptyTitle => 'لا توجد تحليلات مالية متاحة';

  @override
  String get analyticsEmptyDesc =>
      'أضف دخلك ومصاريفك لفتح الرسوم البيانية التفاعلية وتقسيمات الفئات ومعدلات الادخار.';

  @override
  String get savingsRateLabel => 'معدل الادخار';

  @override
  String get insightHighestCategoryTitle => 'أعلى فئة إنفاقاً';

  @override
  String get insightHighestCategoryDesc => 'أعلى إجمالي مصاريف في هذه الفترة.';

  @override
  String get insightLargestExpenseTitle => 'أكبر مصروف فردي';

  @override
  String get insightLargestExpenseDesc => 'أعلى عملية شراء أو مصروف مسجل.';

  @override
  String get insightLargestIncomeTitle => 'أكبر دخل فردي';

  @override
  String get insightLargestIncomeDesc => 'أعلى مبلغ دخل مسجل.';

  @override
  String get insightSavingsRateTitle => 'نسبة الادخار';

  @override
  String get insightSavingsRateDesc =>
      'النسبة المئوية التي تم ادخارها من الدخل.';

  @override
  String get insightAvgDailyTitle => 'متوسط الإنفاق اليومي';

  @override
  String get insightAvgDailyDesc => 'معدل المصروفات اليومية المحسوب.';

  @override
  String get periodToday => 'اليوم';

  @override
  String get periodYesterday => 'الأمس';

  @override
  String get periodThisWeek => 'هذا الأسبوع';

  @override
  String get periodThisMonth => 'هذا الشهر';

  @override
  String get periodLastMonth => 'الشهر الماضي';

  @override
  String get periodThisYear => 'هذه السنة';

  @override
  String get periodAllTime => 'كل الأوقات';

  @override
  String get budgetsTitle => 'الميزانيات والأهداف';

  @override
  String get budgetsTab => 'الميزانيات';

  @override
  String get goalsTab => 'أهداف الادخار';

  @override
  String get noBudgetsTitle => 'لا توجد ميزانيات نشطة';

  @override
  String get noBudgetsDesc =>
      'حدد أهداف إنفاق شهرية لإبقاء مصاريفك تحت السيطرة.';

  @override
  String get addBudgetCta => 'إنشاء أول ميزانية';

  @override
  String get noGoalsTitle => 'لا توجد أهداف ادخار بعد';

  @override
  String get noGoalsDesc =>
      'حدد أهدافاً مالية للرحلات، صندوق الطوارئ، أو الاستثمارات.';

  @override
  String get addGoalCta => 'إنشاء أول هدف ادخار';

  @override
  String get addBudgetTitle => 'إنشاء ميزانية';

  @override
  String get editBudgetTitle => 'تعديل الميزانية';

  @override
  String get budgetNameLabel => 'اسم الميزانية';

  @override
  String get budgetNameRequiredError => 'يرجى إدخال اسم الميزانية';

  @override
  String get addGoalTitle => 'إنشاء هدف ادخار';

  @override
  String get editGoalTitle => 'تعديل هدف الادخار';

  @override
  String get goalTitleLabel => 'عنوان الهدف';

  @override
  String get goalTitleRequiredError => 'يرجى إدخال عنوان الهدف';

  @override
  String get targetAmountLabel => 'المبلغ المستهدف';

  @override
  String get currentAmountLabel => 'المبلغ المدخر حالياً';

  @override
  String get deadlineLabel => 'الموعد النهائي';

  @override
  String get accountsTitle => 'الحسابات';

  @override
  String get noAccountsTitle => 'لا توجد حسابات بعد';

  @override
  String get noAccountsDesc =>
      'أنشئ حسابات مالية لتتبع الأرصدة في المحافظ والمنشآت والبنوك.';

  @override
  String get addAccountCta => 'إضافة أول حساب';

  @override
  String get addAccountTitle => 'إضافة حساب';

  @override
  String get editAccountTitle => 'تعديل الحساب';

  @override
  String get accountNameLabel => 'اسم الحساب';

  @override
  String get accountNameRequiredError => 'يرجى إدخال اسم الحساب';

  @override
  String get accountTypeLabel => 'نوع الحساب';

  @override
  String get balanceLabel => 'الرصيد';

  @override
  String get defaultLabel => 'الافتراضي';

  @override
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذا الحساب؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get expenseCategoriesTab => 'المصروفات';

  @override
  String get incomeCategoriesTab => 'الدخل';

  @override
  String get noCategoriesTitle => 'لا توجد فئات مخصصة بعد';

  @override
  String get noCategoriesDesc =>
      'قم بإنشاء فئات مخصصة لتصنيف معاملاتك المالية بشكل أفضل.';

  @override
  String get addCategoryTitle => 'إضافة فئة';

  @override
  String get editCategoryTitle => 'تعديل الفئة';

  @override
  String get categoryNameLabel => 'اسم الفئة';

  @override
  String get categoryNameRequiredError => 'يرجى إدخال اسم الفئة';

  @override
  String get categoryTypeLabel => 'نوع الفئة';

  @override
  String get colorLabel => 'اللون';

  @override
  String get deleteCategoryTitle => 'حذف الفئة';

  @override
  String get deleteCategoryConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذه الفئة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get backupExportTitle => 'النسخ الاحتياطي والتصدير';

  @override
  String get exportSectionTitle => 'تصدير البيانات';

  @override
  String get exportJsonLabel => 'تصدير بصيغة JSON';

  @override
  String get exportJsonDesc =>
      'نسخة احتياطية كاملة لقاعدة البيانات بصيغة JSON.';

  @override
  String get exportCsvLabel => 'تصدير بصيغة CSV';

  @override
  String get exportCsvDesc => 'تصدير المعاملات كملف جدول بيانات CSV.';

  @override
  String get dataManagementTitle => 'إدارة البيانات';

  @override
  String get factoryResetLabel => 'إعادة ضبط المصنع';

  @override
  String get factoryResetDesc =>
      'مسح كافة البيانات المحلية واستعادة التطبيق إلى حالته الأصلية.';

  @override
  String get factoryResetConfirm =>
      'سيؤدي هذا إلى حذف جميع بياناتك نهائياً بما في ذلك المعاملات والميزانيات والحسابات والإعدادات. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get searchSettingsHint => 'البحث في الإعدادات...';

  @override
  String get managementSectionTitle => 'الإدارة';

  @override
  String get aboutTitle => 'حول التطبيق';

  @override
  String get versionLabel => 'الإصدار 1.0.0';

  @override
  String get licensesLabel => 'تراخيص البرمجيات الحرة';

  @override
  String get privacyPolicyLabel => 'سياسة الخصوصية';

  @override
  String get dangerZoneTitle => 'منطقة الخطر';

  @override
  String primaryCurrencyHeader(String currency) {
    return 'العملة الأساسية: $currency';
  }

  @override
  String get activeBudgetPreviewTitle => 'معاينة الميزانية النشطة';

  @override
  String get viewAllButton => 'عرض الكل';

  @override
  String get statusOnTrack => 'في المسار الصحيح';

  @override
  String get statusWarning => 'تحذير (70%+)';

  @override
  String get statusCritical => 'حرج (90%+)';

  @override
  String get statusExceeded => 'متجاوز';

  @override
  String spentLabel(String amount) {
    return 'المنفق: $amount';
  }

  @override
  String remainingLabel(String amount) {
    return 'المتبقي: $amount';
  }

  @override
  String get contributeGoalTitle => 'المساهمة في الهدف';

  @override
  String get contributeButton => 'إضافة مساهمة';

  @override
  String get depositAmountLabel => 'مبلغ الإيداع';

  @override
  String get sourceAccountLabel => 'من حساب';

  @override
  String get targetAccountLabel => 'إلى حساب';

  @override
  String get importJsonLabel => 'استعادة من نسخة JSON الاحتياطية';

  @override
  String get importJsonDesc =>
      'استعادة جميع المعاملات والحسابات والميزانيات والأهداف من ملف نسخة احتياطية.';

  @override
  String get shareFileButton => 'مشاركة الملف';

  @override
  String get openFileButton => 'فتح الملف';

  @override
  String get tutorialWelcomeTitle => 'مرحباً بك في فينورا!';

  @override
  String get tutorialWelcomeDesc =>
      'هذه هي لوحة التحكم الخاصة بك. كل معاملة تنتمي إلى حساب مالي (مثل البنك أو النقدية). لقد أنشأنا لك حساباً افتراضياً باسم \'النقدية الرئيسية\' يمكنك استبداله أو تعديله لاحقاً من الإعدادات.';

  @override
  String get tutorialOverviewTitle => 'الملخص المالي';

  @override
  String get tutorialOverviewDesc =>
      'تابع صافي رصيدك الإجمالي، ودخلك الشهري، ومصروفاتك في الوقت الفعلي.';

  @override
  String get tutorialFabTitle => 'إضافة معاملة سريعة';

  @override
  String get tutorialFabDesc =>
      'اضغط هنا في أي وقت لتسجيل معاملة جديدة (دخل، مصروف، أو تحويل مالي).';

  @override
  String get tutorialNext => 'التالي';

  @override
  String get tutorialPrev => 'السابق';

  @override
  String get tutorialSkip => 'تخطي';

  @override
  String get tutorialFinish => 'إنهاء';

  @override
  String get duplicateBudgetTitle => 'الميزانية موجودة بالفعل';

  @override
  String get duplicateBudgetMessage =>
      'هناك ميزانية مخصصة بالفعل لهذه الفئة. ماذا تفضل أن تفعل؟';

  @override
  String get btnUpdateBudget => 'استبدال المبلغ';

  @override
  String get btnIncreaseBudget => 'زيادة الميزانية';

  @override
  String get btnDecreaseBudget => 'تقليل الميزانية';

  @override
  String get overviewTab => 'نظرة عامة';

  @override
  String get transactionsTab => 'المعاملات';

  @override
  String get analyticsTab => 'التحليلات';

  @override
  String get goalStatusToday => 'اليوم';

  @override
  String get goalStatusTomorrow => 'غداً';

  @override
  String goalStatusDaysLeft(Object days) {
    return 'متبقي $days أيام';
  }

  @override
  String get goalStatusExpired => 'منتهي الصلاحية';

  @override
  String get goalStatusCompleted => 'مكتمل';

  @override
  String savedAmountLabel(Object amount) {
    return 'المدخر: $amount';
  }

  @override
  String targetLabel(Object amount) {
    return 'المستهدف: $amount';
  }

  @override
  String get markAsCompleted => 'تحديد كمكتمل';

  @override
  String get tutorialAccountsTitle => 'الحسابات المالية';

  @override
  String get tutorialAccountsDesc =>
      'كل معاملة تنتمي إلى حساب مالي (مثل النقدية أو البنك). لقد أنشأنا لك حساباً افتراضياً باسم \'النقدية الرئيسية\'. يمكنك إضافة حسابات جديدة، تعديلها، أو إدارتها من علامة تبويب الإعدادات.';

  @override
  String get deleteAccountErrorHasTransactions =>
      'لا يمكن حذف هذا الحساب لأنه يحتوي على معاملات. يرجى حذف تلك المعاملات أو إعادة تعيينها أولاً.';

  @override
  String get okButton => 'موافق';

  @override
  String get accountIconLabel => 'أيقونة الحساب';

  @override
  String get defaultAccountLabel => 'الحساب الافتراضي';

  @override
  String get defaultAccountDesc =>
      'استخدم هذا الحساب كحساب افتراضي للمعاملات الجديدة';

  @override
  String get accountTypeCash => 'نقدية';

  @override
  String get accountTypeBank => 'حساب بنكي';

  @override
  String get accountTypeSavings => 'حساب توفير';

  @override
  String get accountTypeCreditCard => 'بطاقة ائتمان';

  @override
  String get accountTypeWallet => 'محفظة رقمية';

  @override
  String get accountTypeBusiness => 'أعمال';

  @override
  String get budgetTypeDaily => 'ميزانية يومية';

  @override
  String get budgetTypeWeekly => 'ميزانية أسبوعية';

  @override
  String get budgetTypeMonthly => 'ميزانية شهرية';

  @override
  String get budgetTypeYearly => 'ميزانية سنوية';

  @override
  String get currentBalanceLabel => 'الرصيد الحالي';

  @override
  String get incomeLabel => 'الدخل';

  @override
  String get expensesLabel => 'المصروفات';

  @override
  String get netCashFlowLabel => 'صافي التدفقات النقدية';

  @override
  String get totalTransactionsLabel => 'إجمالي المعاملات';

  @override
  String get creationDateLabel => 'تاريخ الإنشاء';

  @override
  String get lastActivityLabel => 'آخر نشاط';

  @override
  String get monthlySpendLabel => 'الإنفاق الشهري';

  @override
  String get dailyAvgSpendLabel => 'متوسط الإنفاق اليومي';

  @override
  String get largestTxLabel => 'أكبر معاملة';

  @override
  String get cashFlowBreakdownLabel => 'تفصيل التدفقات النقدية';

  @override
  String get expensesByCategoryLabel => 'المصروفات حسب الفئة';

  @override
  String get noExpenseRecordsLabel =>
      'لم يتم العثور على سجلات مصروفات لهذا الحساب.';

  @override
  String get accountDetailsTitle => 'تفاصيل الحساب';

  @override
  String get accountNotFoundError => 'الحساب غير موجود';

  @override
  String get budgetTypeCustom => 'ميزانية مخصصة';

  @override
  String get notificationsTitle => 'إعدادات الإشعارات';

  @override
  String get notificationsDesc =>
      'إدارة تكرار التذكير، تنبيهات الميزانية، وتعارير الإنفاق';

  @override
  String get budgetNotificationsTitle => 'تنبيهات الميزانية';

  @override
  String get budgetNotificationsDesc =>
      'التنبيه عند وصول الميزانية إلى 50٪، 80٪، 100٪، أو تجاوزها';

  @override
  String get goalNotificationsTitle => 'تنبيهات أهداف التوفير';

  @override
  String get goalNotificationsDesc =>
      'التنبيه عند إكمال الهدف، اقتراب الانتهاء، أو حلول الموعد';

  @override
  String get reminderNotificationsTitle => 'تذكيرات المعاملات';

  @override
  String get reminderNotificationsDesc =>
      'تنبيهات مجدولة لتسجيل المصروفات اليومية/الأسبوعية';

  @override
  String get weeklySummaryTitle => 'الملخص الأسبوعي';

  @override
  String get weeklySummaryDesc => 'استلام نظرة عامة أسبوعية عن إنفاقك';

  @override
  String get monthlySummaryTitle => 'الملخص الشهري';

  @override
  String get monthlySummaryDesc => 'استلام تقرير مالي شهري';

  @override
  String get reminderFrequencyTitle => 'تكرار التذكير';

  @override
  String get reminderTimeTitle => 'وقت التذكير';

  @override
  String get testNotificationButton => 'إرسال إشعار تجريبي';

  @override
  String get testNotificationSent => 'تم إرسال الإشعار التجريبي بنجاح!';

  @override
  String get permissionStatusTitle => 'إذن الإشعارات';

  @override
  String get permissionGranted => 'مسموح';

  @override
  String get permissionDenied => 'مرفوض (اضغط للطلب)';

  @override
  String get requestPermissionButton => 'منح الإذن';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusExpired => 'منتهي';

  @override
  String get freqDaily => 'كل يوم';

  @override
  String get freqWeekly => 'كل أسبوع';

  @override
  String get freqBiWeekly => 'كل أسبوعين';

  @override
  String get freqMonthly => 'كل شهر';
}
