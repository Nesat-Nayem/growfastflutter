import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/auth/domain/entities/country.dart';
import 'package:grow_first/features/auth/domain/repositories/country_repository.dart';

class GetCountries implements UseCase<List<Country>, NoParams> {
  final CountryRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) {
    return repository.getCountries();
  }
}
