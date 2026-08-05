import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_data_source.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _localDataSource;

  AccountRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      var models = await _localDataSource.getAccounts();
      if (models.isEmpty) {
        // Seed default Cash account if no accounts exist
        final defaultAccount = AccountModel(
          id: 'default_cash_account',
          name: 'Main Cash',
          type: AccountType.cash.name,
          balance: 0.0,
          currencyCode: 'USD',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isArchived: false,
          isDefault: true,
        );
        await _localDataSource.saveAccount(defaultAccount);
        models = [defaultAccount];
      }
      final entities = models.map((m) => m.toEntity()).toList();
      final defaultAccounts = entities.where((a) => a.isDefault).toList();
      final nonDefaultAccounts = entities.where((a) => !a.isDefault).toList();
      final sortedEntities = [...defaultAccounts, ...nonDefaultAccounts];
      return Right(sortedEntities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAccount(Account account) async {
    try {
      final model = AccountModel.fromEntity(account);
      await _localDataSource.saveAccount(model);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBalance(
    String accountId,
    double deltaAmount,
  ) async {
    try {
      final models = await _localDataSource.getAccounts();
      final targetIndex = models.indexWhere((a) => a.id == accountId);
      if (targetIndex != -1) {
        final existing = models[targetIndex];
        final updated = AccountModel(
          id: existing.id,
          name: existing.name,
          type: existing.type,
          balance: existing.balance + deltaAmount,
          currencyCode: existing.currencyCode,
          colorHex: existing.colorHex,
          iconData: existing.iconData,
          createdAt: existing.createdAt,
          updatedAt: DateTime.now(),
          isArchived: existing.isArchived,
          isDefault: existing.isDefault,
        );
        await _localDataSource.saveAccount(updated);
      }
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      await _localDataSource.deleteAccount(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
