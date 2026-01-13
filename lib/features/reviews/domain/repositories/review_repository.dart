abstract class ReviewRepository {
  Future<Map<String, dynamic>> addReview({
    required int serviceId,
    required String title,
    required String email,
    required int rating,
    required String details,
  });
}
