import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/reviews/data/remote_datasource/reviews_remote_datasource.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsCubit(this.remoteDataSource) : super(ReviewsInitial());

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
}
