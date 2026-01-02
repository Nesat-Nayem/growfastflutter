import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/utils/helpers.dart';

import '../../domain/entities/booking_location.dart';
import '../../domain/entities/booking_staff.dart';
import '../../domain/entities/booking_service_detail.dart';
import '../../domain/usecases/get_booking_locations.dart';
import '../../domain/usecases/get_booking_staffs.dart';
import '../../domain/usecases/get_booking_service_detail.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingLocationsUseCase getLocations;
  final GetBookingStaffsUseCase getStaffs;
  final GetBookingServiceDetailUseCase getServiceDetail;

  BookingsBloc({
    required this.getLocations,
    required this.getStaffs,
    required this.getServiceDetail,
  }) : super(const BookingsState()) {
    on<LoadBookingLocations>(_onLoadLocations);
    on<LoadBookingStaffs>(_onLoadStaffs);
    on<LoadBookingServiceDetail>(_onLoadServiceDetail);
    on<SetSelectedBookingLocation>(_onSetSelectedLocation);
  }

  void _onSetSelectedLocation(
    SetSelectedBookingLocation event,
    Emitter<BookingsState> emit,
  ) {
    emit(state.copyWith(selectedLocation: event.selectedLocation));
  }

  Future<void> _onLoadLocations(
    LoadBookingLocations event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(isLocationLoading: true, errorLocationsFetching: null));

    final result = await getLocations(event.serviceId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLocationLoading: false,
            errorLocationsFetching: Helpers.convertFailureToMessage(failure),
          ),
        );
      },
      (locations) {
        emit(
          state.copyWith(
            isLocationLoading: false,
            locations: locations,
            selectedLocation: locations.isNotEmpty ? locations.first : null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadStaffs(
    LoadBookingStaffs event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(isStaffLoading: true, errorStaffFetching: null));

    final result = await getStaffs(
      GetBookingStaffsParams(
        country: event.country,
        state: event.state,
        city: event.city,
        serviceId: event.serviceId,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isStaffLoading: false,
            errorStaffFetching: Helpers.convertFailureToMessage(failure),
          ),
        );
      },
      (staffs) {
        emit(state.copyWith(isStaffLoading: false, staffs: staffs));
      },
    );
  }

  Future<void> _onLoadServiceDetail(
    LoadBookingServiceDetail event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isAdditionalServiceLoading: true,
        errorAdditionalSerciceFetching: null,
      ),
    );

    final result = await getServiceDetail(event.serviceId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isAdditionalServiceLoading: false,
            errorAdditionalSerciceFetching: Helpers.convertFailureToMessage(
              failure,
            ),
          ),
        );
      },
      (serviceDetail) {
        emit(
          state.copyWith(
            isAdditionalServiceLoading: false,
            serviceDetail: serviceDetail,
          ),
        );
      },
    );
  }
}
