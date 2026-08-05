import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<Budget>>> getBudgets();
  Future<Either<Failure, void>> saveBudget(Budget budget);
  Future<Either<Failure, void>> deleteBudget(String id);
}
