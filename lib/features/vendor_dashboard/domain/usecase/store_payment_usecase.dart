import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import '../repositories/vendor_repository.dart';

class StorePaymentUseCase {
  final VendorRepository repository;

  StorePaymentUseCase(this.repository);

  Future<Either<Failure, StorePaymentResponse>> call(StorePaymentRequest request) {
    return repository.storePayment(request);
  }
}
