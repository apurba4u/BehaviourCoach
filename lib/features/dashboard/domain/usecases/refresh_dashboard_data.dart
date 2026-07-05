import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:discipline_os/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Refresh Dashboard Data Use Case
class RefreshDashboardData {
  final DashboardRepository _repository;

  RefreshDashboardData(this._repository);

  Future<Either<Failure, DashboardData>> call(String userId) {
    return _repository.refreshDashboardData(userId);
  }
}
