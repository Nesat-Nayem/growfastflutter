import 'package:dio/dio.dart';

abstract class BookingsRemoteDataSource {
  Future<Map<String, dynamic>> getBookingsList();
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final Dio dio;

  BookingsRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getBookingsList() async {
    try {
      final response = await dio.get('customer/bookings');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }
}
