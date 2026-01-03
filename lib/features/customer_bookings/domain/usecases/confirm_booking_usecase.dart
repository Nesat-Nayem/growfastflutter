import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/customer_bookings/domain/repositories/booking_repository.dart';

class ConfirmBookingUseCase {
  final BookingRepository repository;

  ConfirmBookingUseCase(this.repository);

  Future<Either<Failure, bool>> call(ConfirmBookingParams params) async {
    return await repository.confirmBooking(
      cartId: params.cartId,
      paymentMethod: params.paymentMethod,
      paymentGateway: params.paymentGateway,
      response: params.response,
    );
  }
}

class ConfirmBookingParams {
  final int cartId;
  final String paymentMethod;
  final String paymentGateway;
  final dynamic response;

  ConfirmBookingParams({
    required this.cartId,
    required this.paymentMethod,
    required this.paymentGateway,
    required this.response,
  });
}
