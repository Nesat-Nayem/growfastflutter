import 'package:dio/dio.dart';

abstract class ReviewsRemoteDataSource {
  Future<Map<String, dynamic>> getReviews();
  Future<Map<String, dynamic>> addReview(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateReview(Map<String, dynamic> data);
  Future<Map<String, dynamic>> deleteReview(int reviewId);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final Dio dio;

  ReviewsRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> getReviews() async {
    try {
      final response = await dio.get('customer/reviews');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addReview(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('customer/add-review', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateReview(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('customer/update-review', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteReview(int reviewId) async {
    try {
      final response = await dio.delete('customer/review/delete/$reviewId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }
}
