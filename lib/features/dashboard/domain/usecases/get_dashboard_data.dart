import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:discipline_os/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Get Dashboard Data Use Case
class GetDashboardData {
  final DashboardRepository _repository;

  GetDashboardData(this._repository);

  Future<Either<Failure, DashboardData>> call(String userId) {
    return _repository.getDashboardData(userId);
  }
}
