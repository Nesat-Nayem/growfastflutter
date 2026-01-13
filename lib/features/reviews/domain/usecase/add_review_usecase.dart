import '../repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required int serviceId,
    required String title,
    required String email,
    required int rating,
    required String details,
  }) {
    return repository.addReview(
      serviceId: serviceId,
      title: title,
      email: email,
      rating: rating,
      details: details,
    );
  }
}
