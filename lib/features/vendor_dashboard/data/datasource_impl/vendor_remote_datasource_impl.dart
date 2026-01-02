import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/vendor_dashboard/data/datasources/vendor_remote_datasource.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/city_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import '../models/country_dto.dart';
import '../models/state_dto.dart';

class VendorRemoteDatasourceImpl implements VendorRemoteDatasource {
  final Dio dio;

  VendorRemoteDatasourceImpl(this.dio);

  @override
  Future<List<CountryDto>> getCountries() async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'https://growfirst.org/api/country',
    );

    if (response['status'] == 'success') {
      return (response['data'] as List)
          .map((e) => CountryDto.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<StateDto>> getStates(int countryId) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'https://growfirst.org/api/state/$countryId',
    );

    if (response['status'] == 'success') {
      return (response['data'] as List)
          .map((e) => StateDto.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CityDto>> getCities(int stateId) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'https://growfirst.org/api/city/$stateId',
    );

    if (response['status'] == 'success') {
      return (response['data'] as List)
          .map((e) => CityDto.fromJson(e))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> registerStep1(VendorStep1Request request) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'https://growfirst.org/api/vendor/register/step1',
      data: request.toJson(),
    );

    if (response['status'] != 'success') {
      throw ServerException();
    }
  }
}
