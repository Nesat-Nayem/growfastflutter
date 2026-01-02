import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import '../entities/city_entity.dart';
import '../repositories/vendor_repository.dart';

class GetCitiesUseCase implements UseCase<List<CityEntity>, int> {
  final VendorRepository repository;

  GetCitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CityEntity>>> call(int stateId) {
    return repository.getCities(stateId);
  }
}
