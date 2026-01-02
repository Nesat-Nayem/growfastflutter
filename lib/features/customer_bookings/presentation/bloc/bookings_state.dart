part of 'bookings_bloc.dart';

class BookingsState extends Equatable {
  final bool isLocationLoading;
  final bool isStaffLoading;
  final bool isAdditionalServiceLoading;
  final List<BookingLocation> locations;
  final BookingLocation? selectedLocation;
  final List<BookingStaff> staffs;
  final List<BookingServiceDetail>? serviceDetail;
  final String? errorLocationsFetching;
  final String? errorStaffFetching;
  final String? errorAdditionalSerciceFetching;

  const BookingsState({
    this.isLocationLoading = false,
    this.isStaffLoading = false,
    this.isAdditionalServiceLoading = false,
    this.locations = const [],
    this.selectedLocation,
    this.staffs = const [],
    this.serviceDetail,
    this.errorLocationsFetching,
    this.errorStaffFetching,
    this.errorAdditionalSerciceFetching,
  });

  BookingsState copyWith({
    bool? isLocationLoading,
    bool? isStaffLoading,
    bool? isAdditionalServiceLoading,
    List<BookingLocation>? locations,
    BookingLocation? selectedLocation,
    List<BookingStaff>? staffs,
    List<BookingServiceDetail>? serviceDetail,
    String? errorLocationsFetching,
    String? errorStaffFetching,
    String? errorAdditionalSerciceFetching,
  }) {
    return BookingsState(
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      isStaffLoading: isStaffLoading ?? this.isStaffLoading,
      isAdditionalServiceLoading:
          isAdditionalServiceLoading ?? this.isAdditionalServiceLoading,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      staffs: staffs ?? this.staffs,
      serviceDetail: serviceDetail ?? this.serviceDetail,
      errorAdditionalSerciceFetching:
          errorAdditionalSerciceFetching ?? this.errorAdditionalSerciceFetching,
      errorLocationsFetching:
          errorLocationsFetching ?? this.errorLocationsFetching,
      errorStaffFetching: errorStaffFetching ?? this.errorStaffFetching,
    );
  }

  @override
  List<Object?> get props => [
    isLocationLoading,
    locations,
    staffs,
    serviceDetail,
    isStaffLoading,
    isAdditionalServiceLoading,
    selectedLocation,
    errorLocationsFetching,
    errorStaffFetching,
    errorAdditionalSerciceFetching,
  ];
}
