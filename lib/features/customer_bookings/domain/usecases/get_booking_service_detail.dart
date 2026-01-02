import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import '../entities/booking_service_detail.dart';
import '../repositories/booking_repository.dart';

class GetBookingServiceDetailUseCase
    implements UseCase<List<BookingServiceDetail>, int> {
  final BookingRepository repository;

  GetBookingServiceDetailUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingServiceDetail>>> call(int serviceId) {
    return repository.getServiceDetail(serviceId);
  }
}
