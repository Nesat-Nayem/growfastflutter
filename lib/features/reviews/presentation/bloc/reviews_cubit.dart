import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/reviews/data/remote_datasource/reviews_remote_datasource.dart';
import 'package:grow_first/features/reviews/domain/usecase/add_review_usecase.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRemoteDataSource remoteDataSource;
 final AddReviewUseCase _addReviewUseCase;
  ReviewsCubit(
    this.remoteDataSource,
    this._addReviewUseCase,
  ) : super(ReviewsInitial());

  Future<void> loadReviews() async {
    emit(ReviewsLoading());
    try {
      final response = await remoteDataSource.getReviews();
      if (response['status'] == 'success') {
        final reviews = response['reviews'] as List? ?? [];
        emit(ReviewsLoaded(reviews));
      } else {
        emit(ReviewsError(response['message'] ?? 'Failed to load reviews'));
      }
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      final response = await remoteDataSource.deleteReview(reviewId);
      if (response['status'] == 'success') {
        loadReviews(); // Reload reviews after deletion
      } else {
        emit(ReviewsError(response['message'] ?? 'Failed to delete review'));
      }
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int serviceId,
    required String title,
    required String email,
    required int rating,
    required String details,
  }) async {
    emit(ReviewsLoading());

    try {
      final response = await _addReviewUseCase(
        serviceId: serviceId,
        title: title,
        email: email,
        rating: rating,
        details: details,
      );

      if (response['status'] == 'success') {
        emit(ReviewSubmitSuccess(response['message']));
      } else {
        emit(ReviewsError(response['message'] ?? 'Failed'));
      }
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
