import 'package:dio/dio.dart';

abstract class ReviewsRemoteDataSource {
  Future<Map<String, dynamic>> getReviews();
  Future<Map<String, dynamic>> addReview(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateReview(Map<String, dynamic> data);
  Future<Map<String, dynamic>> deleteReview(int reviewId);
  Future<Map<String, dynamic>> likeReview(int reviewId, bool isLike);
  Future<Map<String, dynamic>> replyReview(int reviewId, String reply, {int? parentId});
  Future<Map<String, dynamic>> getLikesDislikes(int reviewId);
  Future<Map<String, dynamic>> getReplies(int reviewId);
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

  @override
  Future<Map<String, dynamic>> likeReview(int reviewId, bool isLike) async {
    try {
      final response = await dio.post('customer/like-review', data: {
        'review_id': reviewId,
        'is_like': isLike ? 1 : 0,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to like review: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> replyReview(int reviewId, String reply, {int? parentId}) async {
    try {
      final response = await dio.post('customer/reply-review', data: {
        'review_id': reviewId,
        'reply': reply,
        if (parentId != null) 'parent_id': parentId,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to reply review: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getLikesDislikes(int reviewId) async {
    try {
      final response = await dio.get('customer/get-likes-dislikes/$reviewId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get likes/dislikes: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getReplies(int reviewId) async {
    try {
      final response = await dio.get('customer/get-replies/$reviewId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get replies: $e');
    }
  }
}
