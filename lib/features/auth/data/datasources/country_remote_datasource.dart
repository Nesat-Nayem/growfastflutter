import 'package:grow_first/features/auth/data/models/country_model.dart';

abstract class CountryRemoteDatasource {
  /// Fetch list of countries from the API
  Future<List<CountryModel>> getCountries({String? name, int? page});
}
