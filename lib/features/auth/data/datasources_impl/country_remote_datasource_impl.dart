import 'package:dio/dio.dart';
import 'package:grow_first/features/auth/data/datasources/country_remote_datasource.dart';
import 'package:grow_first/features/auth/data/models/country_model.dart';

class CountryRemoteDatasourceImpl implements CountryRemoteDatasource {
  final Dio dio;

  CountryRemoteDatasourceImpl(this.dio);

  @override
  Future<List<CountryModel>> getCountries({String? name, int? page}) async {
    return Future.value(<CountryModel>[]);
  }
}
