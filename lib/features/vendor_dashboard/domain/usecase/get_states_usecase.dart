import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import '../entities/state_entity.dart';
import '../repositories/vendor_repository.dart';

class GetStatesUseCase implements UseCase<List<StateEntity>, int> {
  final VendorRepository repository;

  GetStatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<StateEntity>>> call(int countryId) {
    return repository.getStates(countryId);
  }
}
