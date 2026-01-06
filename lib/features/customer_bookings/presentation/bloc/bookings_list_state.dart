part of 'bookings_list_cubit.dart';

abstract class BookingsListState {}

class BookingsListInitial extends BookingsListState {}

class BookingsListLoading extends BookingsListState {}

class BookingsListLoaded extends BookingsListState {
  final List<dynamic> bookings;
  BookingsListLoaded(this.bookings);
}

class BookingsListError extends BookingsListState {
  final String message;
  BookingsListError(this.message);
}
