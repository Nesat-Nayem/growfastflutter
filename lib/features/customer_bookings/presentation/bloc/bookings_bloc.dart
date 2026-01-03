import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/utils/helpers.dart';

import '../../domain/entities/booking_location.dart';
import '../../domain/entities/booking_staff.dart';
import '../../domain/entities/booking_service_detail.dart';
import '../../domain/usecases/get_booking_locations.dart';
import '../../domain/usecases/get_booking_staffs.dart';
import '../../domain/usecases/get_booking_service_detail.dart';
import '../../domain/usecases/confirm_booking_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingLocationsUseCase getLocations;
  final GetBookingStaffsUseCase getStaffs;
  final GetBookingServiceDetailUseCase getServiceDetail;
  final ConfirmBookingUseCase confirmBooking;
  final AddToCartUseCase addToCart;

  BookingsBloc({
    required this.getLocations,
    required this.getStaffs,
    required this.getServiceDetail,
    required this.confirmBooking,
    required this.addToCart,
  }) : super(const BookingsState()) {
    on<LoadBookingLocations>(_onLoadLocations);
    on<LoadBookingStaffs>(_onLoadStaffs);
    on<LoadBookingServiceDetail>(_onLoadServiceDetail);
    on<SetSelectedBookingLocation>(_onSetSelectedLocation);
    on<SetSelectedBookingStaff>(_onSetSelectedStaff);
    on<ToggleAdditionalService>(_onToggleAdditionalService);
    on<ConfirmBooking>(_onConfirmBooking);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(isAddingToCart: true, errorAddingToCart: null));

    final result = await addToCart(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        isAddingToCart: false,
        errorAddingToCart: Helpers.convertFailureToMessage(failure),
      )),
      (cartId) => emit(state.copyWith(
        isAddingToCart: false,
        cartId: cartId,
      )),
    );
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true)); // Reuse isLocationLoading or add a new one if needed, but adding a general one or just using existing ones for now. Let's add isConfirmingBooking to state.
    
    final result = await confirmBooking(ConfirmBookingParams(
      cartId: event.cartId,
      paymentMethod: event.paymentMethod,
      paymentGateway: event.paymentGateway,
      response: event.response,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorConfirmingBooking: Helpers.convertFailureToMessage(failure),
      )),
      (success) => emit(state.copyWith(
        isLoading: false,
        isBookingConfirmed: success,
      )),
    );
  }

  void _onSetSelectedStaff(
    SetSelectedBookingStaff event,
    Emitter<BookingsState> emit,
  ) {
    emit(state.copyWith(selectedStaff: event.selectedStaff));
  }

  void _onToggleAdditionalService(
    ToggleAdditionalService event,
    Emitter<BookingsState> emit,
  ) {
    final currentSelected =
        List<BookingServiceDetail>.from(state.selectedAdditionalServices);
    if (currentSelected.contains(event.service)) {
      currentSelected.remove(event.service);
    } else {
      currentSelected.add(event.service);
    }
    emit(state.copyWith(selectedAdditionalServices: currentSelected));
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
        emit(
          state.copyWith(
            isStaffLoading: false,
            staffs: staffs,
            selectedStaff: staffs.isNotEmpty ? staffs.first : null,
          ),
        );
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
