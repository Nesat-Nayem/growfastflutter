import 'dart:io';
import 'package:dio/dio.dart';

abstract class AccountRemoteDataSource {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateProfileWithImage(Map<String, dynamic> data, File image);
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

  @override
  Future<Map<String, dynamic>> updateProfileWithImage(Map<String, dynamic> data, File image) async {
    try {
      final formData = FormData.fromMap({
        ...data,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await dio.post(
        'customer/update-profile',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
