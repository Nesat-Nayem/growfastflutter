import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/country_entity.dart';
import '../repositories/vendor_repository.dart';

class GetCountriesUseCase implements UseCase<List<CountryEntity>, NoParams> {
  final VendorRepository repository;

  GetCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CountryEntity>>> call(NoParams params) {
    return repository.getCountries();
  }
}
