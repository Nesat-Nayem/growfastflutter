import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';
import '../repositories/home_repository.dart';

class GetServicesByTypeUseCase
    implements UseCase<List<ServiceSectionModel>, ServiceTypeParams> {
  final HomeRepository repository;

  GetServicesByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceSectionModel>>> call(
      ServiceTypeParams params) {
    return repository.getServicesByType(params.serviceType);
  }
}

class ServiceTypeParams {
  final String serviceType;

  ServiceTypeParams({required this.serviceType});
}
