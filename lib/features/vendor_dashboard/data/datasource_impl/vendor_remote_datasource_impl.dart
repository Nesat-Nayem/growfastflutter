import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/vendor_dashboard/data/datasources/vendor_remote_datasource.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/city_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
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
      'country',
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
      'state/$countryId',
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
      'city/$stateId',
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
  Future<VendorStep1Response> registerStep1(VendorStep1Request request) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'vendor/register/step1',
      data: request.toJson(),
    );

    if (response['status'] == 'success') {
      return VendorStep1Response.fromJson(response);
    } else {
      throw ServerException(message: response['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<PlansResponse> getPlans(String token) async {
    final headers = <String, dynamic>{};
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    print('VendorRemoteDatasource: Fetching plans with token: ${token.isNotEmpty ? "present" : "empty"}');
    
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'vendor/register/plan',
      headers: headers.isNotEmpty ? headers : null,
    );

    print('VendorRemoteDatasource: Plans API response: $response');

    if (response['status'] == 'success') {
      final plansResponse = PlansResponse.fromJson(response);
      print('VendorRemoteDatasource: Parsed ${plansResponse.plans.length} plans');
      return plansResponse;
    } else {
      throw ServerException(message: response['message'] ?? 'Failed to load plans');
    }
  }

  @override
  Future<PaymentOrderResponse> createPaymentOrder(PaymentOrderRequest request) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'vendor/payment/create-order',
      data: request.toJson(),
    );

    if (response['status'] == 'success') {
      return PaymentOrderResponse.fromJson(response);
    } else {
      throw ServerException(message: response['message'] ?? 'Order creation failed');
    }
  }

  @override
  Future<StorePaymentResponse> storePayment(StorePaymentRequest request, String token) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'vendor/register/storePayment',
      data: request.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response['status'] == 'success') {
      return StorePaymentResponse.fromJson(response);
    } else {
      throw ServerException(message: response['message'] ?? 'Payment storage failed');
    }
  }

  @override
  Future<KycUploadResponse> uploadKyc(KycUploadRequest request, String token) async {
    final formData = FormData();

    if (request.aadhar != null) {
      formData.files.add(MapEntry(
        'aadhar',
        await MultipartFile.fromFile(request.aadhar!.path, filename: 'aadhar.jpg'),
      ));
    }

    if (request.pan != null) {
      formData.files.add(MapEntry(
        'pan',
        await MultipartFile.fromFile(request.pan!.path, filename: 'pan.jpg'),
      ));
    }

    if (request.passport != null) {
      formData.files.add(MapEntry(
        'passport',
        await MultipartFile.fromFile(request.passport!.path, filename: 'passport.jpg'),
      ));
    }

    if (request.idCard != null) {
      formData.fields.add(MapEntry('id_card', request.idCard!));
    }

    final response = await dio.post(
      'vendor/register/uploadKyc',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.data['status'] == 'success') {
      return KycUploadResponse.fromJson(response.data);
    } else {
      throw ServerException(message: response.data['message'] ?? 'KYC upload failed');
    }
  }
}
