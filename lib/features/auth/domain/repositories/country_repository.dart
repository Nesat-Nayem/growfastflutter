import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import '../entities/country.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<Country>>> getCountries({
    String? name,
    int? page,
  });
}
