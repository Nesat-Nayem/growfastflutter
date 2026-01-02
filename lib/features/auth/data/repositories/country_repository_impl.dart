import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/utils/countries.dart';
import 'package:grow_first/features/auth/data/datasources/country_remote_datasource.dart';
import 'package:grow_first/features/auth/domain/entities/country.dart';
import 'package:grow_first/features/auth/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDatasource remoteDatasource;

  CountryRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Country>>> getCountries({
    String? name,
    int? page,
  }) async {
    try {
      return Right(kCountriesList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
