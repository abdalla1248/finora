import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<Account>>> getAccounts();
  Future<Either<Failure, void>> saveAccount(Account account);
  Future<Either<Failure, void>> updateBalance(String accountId, double deltaAmount);
  Future<Either<Failure, void>> deleteAccount(String id);
}
