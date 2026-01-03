part of 'bookings_bloc.dart';

class BookingsState extends Equatable {
  final bool isLoading;
  final bool isLocationLoading;
  final bool isStaffLoading;
  final bool isAdditionalServiceLoading;
  final List<BookingLocation> locations;
  final BookingLocation? selectedLocation;
  final List<BookingStaff> staffs;
  final BookingStaff? selectedStaff;
  final List<BookingServiceDetail>? serviceDetail;
  final List<BookingServiceDetail> selectedAdditionalServices;
  final String? errorLocationsFetching;
  final String? errorStaffFetching;
  final String? errorAdditionalSerciceFetching;
  final bool isBookingConfirmed;
  final String? errorConfirmingBooking;
  final int? cartId;
  final bool isAddingToCart;
  final String? errorAddingToCart;

  const BookingsState({
    this.isLoading = false,
    this.isLocationLoading = false,
    this.isStaffLoading = false,
    this.isAdditionalServiceLoading = false,
    this.locations = const [],
    this.selectedLocation,
    this.staffs = const [],
    this.selectedStaff,
    this.serviceDetail,
    this.selectedAdditionalServices = const [],
    this.errorLocationsFetching,
    this.errorStaffFetching,
    this.errorAdditionalSerciceFetching,
    this.isBookingConfirmed = false,
    this.errorConfirmingBooking,
    this.cartId,
    this.isAddingToCart = false,
    this.errorAddingToCart,
  });

  BookingsState copyWith({
    bool? isLoading,
    bool? isLocationLoading,
    bool? isStaffLoading,
    bool? isAdditionalServiceLoading,
    List<BookingLocation>? locations,
    BookingLocation? selectedLocation,
    List<BookingStaff>? staffs,
    BookingStaff? selectedStaff,
    List<BookingServiceDetail>? serviceDetail,
    List<BookingServiceDetail>? selectedAdditionalServices,
    String? errorLocationsFetching,
    String? errorStaffFetching,
    String? errorAdditionalSerciceFetching,
    bool? isBookingConfirmed,
    String? errorConfirmingBooking,
    int? cartId,
    bool? isAddingToCart,
    String? errorAddingToCart,
  }) {
    return BookingsState(
      isLoading: isLoading ?? this.isLoading,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      isStaffLoading: isStaffLoading ?? this.isStaffLoading,
      isAdditionalServiceLoading:
          isAdditionalServiceLoading ?? this.isAdditionalServiceLoading,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      staffs: staffs ?? this.staffs,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      serviceDetail: serviceDetail ?? this.serviceDetail,
      selectedAdditionalServices:
          selectedAdditionalServices ?? this.selectedAdditionalServices,
      errorAdditionalSerciceFetching:
          errorAdditionalSerciceFetching ?? this.errorAdditionalSerciceFetching,
      errorLocationsFetching:
          errorLocationsFetching ?? this.errorLocationsFetching,
      errorStaffFetching: errorStaffFetching ?? this.errorStaffFetching,
      isBookingConfirmed: isBookingConfirmed ?? this.isBookingConfirmed,
      errorConfirmingBooking:
          errorConfirmingBooking ?? this.errorConfirmingBooking,
      cartId: cartId ?? this.cartId,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      errorAddingToCart: errorAddingToCart ?? this.errorAddingToCart,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    locations,
    staffs,
    serviceDetail,
    isStaffLoading,
    isAdditionalServiceLoading,
    selectedLocation,
    selectedStaff,
    selectedAdditionalServices,
    errorLocationsFetching,
    errorStaffFetching,
    errorAdditionalSerciceFetching,
    isBookingConfirmed,
    errorConfirmingBooking,
    cartId,
    isAddingToCart,
    errorAddingToCart,
  ];
}
