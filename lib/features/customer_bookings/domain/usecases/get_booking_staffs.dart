import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_staff.dart';
import 'package:grow_first/features/customer_bookings/domain/repositories/booking_repository.dart';

class GetBookingStaffsUseCase
    implements UseCase<List<BookingStaff>, GetBookingStaffsParams> {
  final BookingRepository repository;

  GetBookingStaffsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingStaff>>> call(
    GetBookingStaffsParams params,
  ) {
    return repository.getStaffs(
      country: params.country,
      state: params.state,
      city: params.city,
      serviceId: params.serviceId,
    );
  }
}

class GetBookingStaffsParams {
  final int country;
  final int state;
  final int city;
  final int serviceId;

  GetBookingStaffsParams({
    required this.country,
    required this.state,
    required this.city,
    required this.serviceId,
  });
}
