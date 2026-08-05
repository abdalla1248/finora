import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../logging/logger.dart';
import '../error/exceptions.dart';
import '../../features/user/data/models/user_model.dart';
import '../../features/transaction/data/models/transaction_model.dart';
import '../../features/budget/data/models/budget_model.dart';
import '../../features/budget/data/models/savings_goal_model.dart';
import '../../features/account/data/models/account_model.dart';
import '../../features/category/data/models/custom_category_model.dart';

/// Database box constants.
class HiveBoxNames {
  const HiveBoxNames._();

  static const String user = 'user_box';
  static const String transactions = 'transactions_box';
  static const String budgets = 'budgets_box';
  static const String goals = 'goals_box';
  static const String accounts = 'accounts_box';
  static const String customCategories = 'custom_categories_box';
  static const String settings = 'settings_box';
}

/// Service managing persistent local key-value storage.
class StorageService {
  final FlutterSecureStorage _secureStorage;
  static const String _encryptionKeyKey = 'finora_db_key';

  List<int>? _encryptionKey;

  StorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  List<int>? get encryptionKey => _encryptionKey;

  /// Initializes the local database setup.
  Future<void> init() async {
    try {
      AppLogger.info('Initializing Hive persistent database...');
      await Hive.initFlutter();

      // Register Hive Adapters
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(TransactionModelAdapter());
      Hive.registerAdapter(BudgetModelAdapter());
      Hive.registerAdapter(SavingsGoalModelAdapter());
      Hive.registerAdapter(AccountModelAdapter());
      Hive.registerAdapter(CustomCategoryModelAdapter());

      await _initializeEncryptionKey();
      AppLogger.info('Hive initialization completed successfully.');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize local database storage.',
        e,
        stackTrace,
      );
      throw DatabaseException(
        'Failed to initialize local database storage.',
        e,
      );
    }
  }

  /// Retrieves or generates a secure 64-byte database encryption key.
  Future<void> _initializeEncryptionKey() async {
    try {
      AppLogger.info(
        'Checking Secure Storage for existing DB encryption key...',
      );
      final base64Key = await _secureStorage.read(key: _encryptionKeyKey);

      if (base64Key != null) {
        AppLogger.info('Existing DB encryption key found. Loading...');
        _encryptionKey = base64.decode(base64Key);
      } else {
        AppLogger.info(
          'No DB encryption key found. Generating fresh 256-bit key...',
        );
        final secureKey = Hive.generateSecureKey();
        await _secureStorage.write(
          key: _encryptionKeyKey,
          value: base64.encode(secureKey),
        );
        _encryptionKey = secureKey;
        AppLogger.info(
          'Fresh encryption key generated and persisted to system keychain.',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to resolve secure database keys.', e, stackTrace);
      throw DatabaseException('Failed to resolve secure database keys.', e);
    }
  }

  /// Opens an encrypted box for a specific feature.
  Future<Box<T>> openEncryptedBox<T>(String boxName) async {
    if (_encryptionKey == null) {
      throw const DatabaseException(
        'StorageService must be initialized before opening boxes.',
      );
    }

    try {
      AppLogger.debug('Opening encrypted Hive Box: "$boxName"');
      return await Hive.openBox<T>(
        boxName,
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to open encrypted box: "$boxName"',
        e,
        stackTrace,
      );
      throw DatabaseException(
        'Failed to open encrypted Hive box: "$boxName"',
        e,
      );
    }
  }

  /// Clears all stored data boxes for Factory Reset.
  Future<void> clearAllData() async {
    try {
      final txBox = await openEncryptedBox<TransactionModel>(HiveBoxNames.transactions);
      await txBox.clear();
      final budgetBox = await openEncryptedBox<BudgetModel>(HiveBoxNames.budgets);
      await budgetBox.clear();
      final goalBox = await openEncryptedBox<SavingsGoalModel>(HiveBoxNames.goals);
      await goalBox.clear();
      final accountBox = await openEncryptedBox<AccountModel>(HiveBoxNames.accounts);
      await accountBox.clear();
      final categoryBox = await openEncryptedBox<CustomCategoryModel>(HiveBoxNames.customCategories);
      await categoryBox.clear();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear all data boxes.', e, stackTrace);
      throw DatabaseException('Failed to clear all data boxes.', e);
    }
  }
}
