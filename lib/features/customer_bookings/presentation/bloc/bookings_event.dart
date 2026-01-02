part of 'bookings_bloc.dart';

abstract class BookingsEvent {}

class LoadBookingLocations extends BookingsEvent {
  final int serviceId;
  LoadBookingLocations(this.serviceId);
}

class LoadBookingStaffs extends BookingsEvent {
  final int country;
  final int state;
  final int city;
  final int serviceId;

  LoadBookingStaffs({
    required this.country,
    required this.state,
    required this.city,
    required this.serviceId,
  });
}

class LoadBookingServiceDetail extends BookingsEvent {
  final int serviceId;
  LoadBookingServiceDetail(this.serviceId);
}

class SetSelectedBookingLocation extends BookingsEvent {
  final BookingLocation selectedLocation;
  SetSelectedBookingLocation(this.selectedLocation);
}
