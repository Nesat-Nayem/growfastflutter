import 'package:grow_first/features/vendor_dashboard/data/models/city_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';

import '../models/country_dto.dart';
import '../models/state_dto.dart';

abstract class VendorRemoteDatasource {
  Future<List<CountryDto>> getCountries();
  Future<List<StateDto>> getStates(int countryId);
  Future<List<CityDto>> getCities(int stateId);

  // Add Step1 registration
  Future<void> registerStep1(VendorStep1Request request);
}
