import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User?>> getUser();
  Future<Either<Failure, void>> saveUser(User user);
  Future<Either<Failure, void>> clearUser();
}
