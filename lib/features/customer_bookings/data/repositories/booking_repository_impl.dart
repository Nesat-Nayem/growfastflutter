import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/customer_bookings/data/models/booking_service_detail_model.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource/booking_remote_datasource.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_location.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_staff.dart';
import 'package:grow_first/features/customer_bookings/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remote;

  BookingRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<BookingLocation>>> getLocations(
    int serviceId,
  ) async {
    try {
      final result = await remote.getLocations(serviceId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingStaff>>> getStaffs({
    required int country,
    required int state,
    required int city,
    required int serviceId,
  }) async {
    try {
      final result = await remote.getStaffs(
        country: country,
        state: state,
        city: city,
        serviceId: serviceId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingServiceDetailModel>>> getServiceDetail(
    int serviceId,
  ) async {
    try {
      final result = await remote.getServiceDetail(serviceId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmBooking({
    required int cartId,
    required String paymentMethod,
    required String paymentGateway,
    required dynamic response,
  }) async {
    try {
      final result = await remote.confirmBooking(
        cartId: cartId,
        paymentMethod: paymentMethod,
        paymentGateway: paymentGateway,
        response: response,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final result = await remote.addToCart(
        staffId: staffId,
        serviceId: serviceId,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        bookingNotes: bookingNotes,
        additionalServiceIds: additionalServiceIds,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        streetAddress: streetAddress,
        postalCode: postalCode,
        country: country,
        state: state,
        city: city,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
