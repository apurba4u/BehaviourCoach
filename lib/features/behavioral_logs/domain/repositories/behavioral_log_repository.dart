import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/behavioral_logs/domain/entities/behavioral_log_entity.dart';

/// Behavioral Log Repository Interface
abstract class BehavioralLogRepository {
  Future<Either<Failure, BehavioralLogEntity>> createLog({
    required String userId,
    required String logType,
    int? score,
    int? durationMinutes,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, List<BehavioralLogEntity>>> getLogs({
    required String userId,
    String? logType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, BehavioralLogEntity>> getLogById(String logId);

  Future<Either<Failure, BehavioralLogEntity>> updateLog({
    required String logId,
    int? score,
    int? durationMinutes,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, Unit>> deleteLog(String logId);

  Future<Either<Failure, Map<String, dynamic>>> getLogStats({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
