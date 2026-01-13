import '../../domain/repositories/review_repository.dart';
import '../remote_datasource/reviews_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewsRemoteDataSource remote;

  ReviewRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> addReview({
    required int serviceId,
    required String title,
    required String email,
    required int rating,
    required String details,
  }) {
    return remote.addReview({
      "service_id": serviceId,
      "title": title,
      "email": email,
      "rating": rating,
      "details": details,
    });
  }
}