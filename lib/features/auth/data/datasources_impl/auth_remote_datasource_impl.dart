import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:grow_first/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<int> sendOtp(String phone) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'https://growfirst.org/api/customer/send-otp',
      data: {'phone': phone},
    );

    if (response['status'] == 'success') {
      return response['user_id'];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.post,
      'https://growfirst.org/api/customer/verify-otp-login',
      data: {'phone': phone, 'otp': otp},
    );

    if (response['status'] == 'success') {
      return AuthResponseModel.fromJson(response);
    } else {
      throw ServerException();
    }
  }
}
