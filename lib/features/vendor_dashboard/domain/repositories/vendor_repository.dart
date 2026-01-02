import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../entities/country_entity.dart';
import '../entities/state_entity.dart';

abstract class VendorRepository {
  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<StateEntity>>> getStates(int countryId);
  Future<Either<Failure, List<CityEntity>>> getCities(int stateId);
  Future<void> registerStep1(VendorStep1Request request);
}
