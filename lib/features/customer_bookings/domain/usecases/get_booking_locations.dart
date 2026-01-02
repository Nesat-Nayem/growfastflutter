import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_location.dart';
import 'package:grow_first/features/customer_bookings/domain/repositories/booking_repository.dart';

class GetBookingLocationsUseCase
    implements UseCase<List<BookingLocation>, int> {
  final BookingRepository repository;

  GetBookingLocationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingLocation>>> call(int serviceId) {
    return repository.getLocations(serviceId);
  }
}
