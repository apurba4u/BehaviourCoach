import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/goals/domain/entities/goal_entity.dart';

/// Goal Repository Interface
abstract class GoalRepository {
  Future<Either<Failure, GoalEntity>> createGoal({
    required String userId,
    required String title,
    String? description,
    String? category,
    int? targetValue,
    String? unit,
    DateTime? deadline,
  });

  Future<Either<Failure, List<GoalEntity>>> getGoals({
    required String userId,
    String? status,
    String? category,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, GoalEntity>> getGoalById(String goalId);

  Future<Either<Failure, GoalEntity>> updateGoal({
    required String goalId,
    String? title,
    String? description,
    String? category,
    int? targetValue,
    int? currentValue,
    String? unit,
    String? status,
    DateTime? deadline,
  });

  Future<Either<Failure, Unit>> deleteGoal(String goalId);
}
