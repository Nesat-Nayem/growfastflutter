import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/customer_bookings/domain/repositories/booking_repository.dart';

class AddToCartUseCase {
  final BookingRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, int>> call(AddToCartParams params) async {
    return await repository.addToCart(
      staffId: params.staffId,
      serviceId: params.serviceId,
      bookingDate: params.bookingDate,
      bookingTime: params.bookingTime,
      bookingNotes: params.bookingNotes,
      additionalServiceIds: params.additionalServiceIds,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      streetAddress: params.streetAddress,
      postalCode: params.postalCode,
      country: params.country,
      state: params.state,
      city: params.city,
    );
  }
}

class AddToCartParams {
  final int staffId;
  final int serviceId;
  final String bookingDate;
  final String bookingTime;
  final String bookingNotes;
  final List<int> additionalServiceIds;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String streetAddress;
  final String postalCode;
  final String country;
  final String state;
  final String city;

  AddToCartParams({
    required this.staffId,
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingNotes,
    required this.additionalServiceIds,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.streetAddress,
    required this.postalCode,
    required this.country,
    required this.state,
    required this.city,
  });
}
