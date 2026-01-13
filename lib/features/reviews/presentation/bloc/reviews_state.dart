part of 'reviews_cubit.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<dynamic> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}
class ReviewSubmitSuccess extends ReviewsState {
  final String message;
  ReviewSubmitSuccess(this.message);
}