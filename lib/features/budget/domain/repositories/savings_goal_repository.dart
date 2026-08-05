import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/savings_goal.dart';

abstract class SavingsGoalRepository {
  Future<Either<Failure, List<SavingsGoal>>> getGoals();
  Future<Either<Failure, void>> saveGoal(SavingsGoal goal);
  Future<Either<Failure, void>> deleteGoal(String id);
}
