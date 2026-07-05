import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/behavior_timeline/domain/entities/behavior_timeline_entity.dart';

/// Behavior Timeline Repository Interface
abstract class BehaviorTimelineRepository {
  Future<Either<Failure, BehaviorTimelineEntity>> createEvent({
    required String userId,
    required String eventType,
    required String title,
    String? description,
    String? icon,
    String? color,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, List<BehaviorTimelineEntity>>> getEvents({
    required String userId,
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, BehaviorTimelineEntity>> getEventById(String eventId);

  Future<Either<Failure, Unit>> deleteEvent(String eventId);
}
