import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource/bookings_remote_datasource.dart';

part 'bookings_list_state.dart';

class BookingsListCubit extends Cubit<BookingsListState> {
  final BookingsRemoteDataSource remoteDataSource;

  BookingsListCubit(this.remoteDataSource) : super(BookingsListInitial());

  Future<void> loadBookings() async {
    emit(BookingsListLoading());
    try {
      final response = await remoteDataSource.getBookingsList();
      if (response['status'] == 'success') {
        final bookings = response['bookings'] as List;
        emit(BookingsListLoaded(bookings));
      } else {
        emit(BookingsListError(response['message'] ?? 'Failed to load bookings'));
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        emit(BookingsListError('Please login to view your bookings'));
      } else {
        emit(BookingsListError(e.toString()));
      }
    }
  }
}
