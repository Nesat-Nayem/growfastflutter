import 'package:dio/dio.dart';

abstract class AccountRemoteDataSource {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio dio;

  AccountRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get('customer/profile');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        'customer/update-profile',
        data: data,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
