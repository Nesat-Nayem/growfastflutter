import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await dio.get('customer/dashboard');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }
}
