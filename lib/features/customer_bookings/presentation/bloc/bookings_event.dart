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

class SetSelectedBookingStaff extends BookingsEvent {
  final BookingStaff selectedStaff;
  SetSelectedBookingStaff(this.selectedStaff);
}

class ToggleAdditionalService extends BookingsEvent {
  final BookingServiceDetail service;
  ToggleAdditionalService(this.service);
}

class ConfirmBooking extends BookingsEvent {
  final int cartId;
  final String paymentMethod;
  final String paymentGateway;
  final dynamic response;

  ConfirmBooking({
    required this.cartId,
    required this.paymentMethod,
    required this.paymentGateway,
    required this.response,
  });
}

class AddToCart extends BookingsEvent {
  final AddToCartParams params;
  AddToCart(this.params);
}
