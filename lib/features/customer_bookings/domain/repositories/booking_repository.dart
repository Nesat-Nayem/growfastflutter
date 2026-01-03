import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_service_detail_model.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_location.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_staff.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingLocation>>> getLocations(int serviceId);

  Future<Either<Failure, List<BookingStaff>>> getStaffs({
    required int country,
    required int state,
    required int city,
    required int serviceId,
  });

  Future<Either<Failure, List<BookingServiceDetailModel>>> getServiceDetail(
    int serviceId,
  );

  Future<Either<Failure, bool>> confirmBooking({
    required int cartId,
    required String paymentMethod,
    required String paymentGateway,
    required dynamic response,
  });

  Future<Either<Failure, int>> addToCart({
    required int staffId,
    required int serviceId,
    required String bookingDate,
    required String bookingTime,
    required String bookingNotes,
    required List<int> additionalServiceIds,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String streetAddress,
    required String postalCode,
    required String country,
    required String state,
    required String city,
  });
}
