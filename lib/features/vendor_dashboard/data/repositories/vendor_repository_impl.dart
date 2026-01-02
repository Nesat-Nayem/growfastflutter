import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_datasource.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDatasource remoteDataSource;

  VendorRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    try {
      final result = await remoteDataSource.getCountries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(int countryId) async {
    try {
      final result = await remoteDataSource.getStates(countryId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(int stateId) async {
    try {
      final result = await remoteDataSource.getCities(stateId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> registerStep1(VendorStep1Request request) =>
      remoteDataSource.registerStep1(request);
}
