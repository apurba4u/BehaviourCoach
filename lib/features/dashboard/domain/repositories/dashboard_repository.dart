import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';

/// Dashboard Repository Interface
abstract class DashboardRepository {
  /// Get aggregated dashboard data for a user
  Future<Either<Failure, DashboardData>> getDashboardData(String userId);

  /// Refresh dashboard data (force fetch from remote)
  Future<Either<Failure, DashboardData>> refreshDashboardData(String userId);
}
