import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../storage/storage_service.dart';
import '../../features/account/data/datasources/account_local_data_source.dart';
import '../../features/account/data/repositories/account_repository_impl.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/presentation/cubit/account_cubit.dart';
import '../../features/analytics/domain/services/analytics_service.dart';
import '../../features/analytics/presentation/cubit/analytics_cubit.dart';
import '../../features/app_initialization/presentation/cubit/app_initialization_cubit.dart';
import '../../features/backup/domain/services/backup_service.dart';
import '../../features/backup/presentation/cubit/backup_cubit.dart';
import '../../features/budget/data/datasources/budget_local_data_source.dart';
import '../../features/budget/data/datasources/savings_goal_local_data_source.dart';
import '../../features/budget/data/repositories/budget_repository_impl.dart';
import '../../features/budget/data/repositories/savings_goal_repository_impl.dart';
import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/budget/domain/repositories/savings_goal_repository.dart';
import '../../features/budget/presentation/cubit/budget_cubit.dart';
import '../../features/budget/presentation/cubit/savings_goal_cubit.dart';
import '../../features/category/data/datasources/category_local_data_source.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/presentation/cubit/category_cubit.dart';
import '../../features/transaction/data/datasources/transaction_local_data_source.dart';
import '../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/presentation/cubit/transaction_cubit.dart';
import '../../features/user/data/datasources/user_local_data_source.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/presentation/cubit/user_cubit.dart';

import '../tutorial/data/datasources/tutorial_local_data_source.dart';
import '../tutorial/presentation/cubit/tutorial_cubit.dart';
import '../../features/notification/data/services/notification_service.dart';

final GetIt getIt = GetIt.instance;

class DIContainer {
  const DIContainer._();

  static Future<void> setup() async {
    // 1. Secure Storage
    getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

    // 2. Storage Service
    getIt.registerSingleton<StorageService>(
      StorageService(secureStorage: getIt<FlutterSecureStorage>()),
    );

    // Initialize Database
    await getIt<StorageService>().init();

    // 3. Services
    getIt.registerLazySingleton<AnalyticsService>(
      () => const AnalyticsService(),
    );

    // Tutorial Data Source
    getIt.registerLazySingleton<TutorialLocalDataSource>(
      () => TutorialLocalDataSourceImpl(),
    );

    // 4. User Data Sources & Repositories
    getIt.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<UserLocalDataSource>()),
    );

    // 5. Transaction Data Sources & Repositories
    getIt.registerLazySingleton<TransactionLocalDataSource>(
      () => TransactionLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(getIt<TransactionLocalDataSource>()),
    );

    // 6. Budget Data Sources & Repositories
    getIt.registerLazySingleton<BudgetLocalDataSource>(
      () => BudgetLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(getIt<BudgetLocalDataSource>()),
    );

    // 7. Savings Goal Data Sources & Repositories
    getIt.registerLazySingleton<SavingsGoalLocalDataSource>(
      () => SavingsGoalLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<SavingsGoalRepository>(
      () => SavingsGoalRepositoryImpl(getIt<SavingsGoalLocalDataSource>()),
    );

    // 8. Account Data Sources & Repositories
    getIt.registerLazySingleton<AccountLocalDataSource>(
      () => AccountLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(getIt<AccountLocalDataSource>()),
    );

    // 9. Category Data Sources & Repositories
    getIt.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(getIt<StorageService>()),
    );

    getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(getIt<CategoryLocalDataSource>()),
    );

    // 10. Services
    getIt.registerLazySingleton<NotificationService>(
      () => NotificationService(),
    );

    getIt.registerLazySingleton<BackupService>(
      () => BackupService(getIt<StorageService>()),
    );

    // 11. Cubit Controllers
    getIt.registerLazySingleton<TutorialCubit>(
      () => TutorialCubit(getIt<TutorialLocalDataSource>()),
    );

    getIt.registerFactory<AppInitializationCubit>(
      () => AppInitializationCubit(getIt<UserRepository>()),
    );

    getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepository>()));

    getIt.registerLazySingleton<TransactionCubit>(
      () => TransactionCubit(
        getIt<TransactionRepository>(),
        getIt<AccountRepository>(),
      ),
    );

    getIt.registerFactory<AnalyticsCubit>(
      () => AnalyticsCubit(getIt<AnalyticsService>()),
    );

    getIt.registerLazySingleton<BudgetCubit>(
      () => BudgetCubit(getIt<BudgetRepository>()),
    );

    getIt.registerLazySingleton<SavingsGoalCubit>(
      () => SavingsGoalCubit(getIt<SavingsGoalRepository>()),
    );

    getIt.registerLazySingleton<AccountCubit>(
      () => AccountCubit(getIt<AccountRepository>()),
    );

    getIt.registerLazySingleton<CategoryCubit>(
      () => CategoryCubit(getIt<CategoryRepository>()),
    );

    getIt.registerFactory<BackupCubit>(
      () => BackupCubit(getIt<BackupService>()),
    );
  }
}
