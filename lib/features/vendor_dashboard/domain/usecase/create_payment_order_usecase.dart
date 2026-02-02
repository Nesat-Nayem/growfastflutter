import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import '../repositories/vendor_repository.dart';

class CreatePaymentOrderUseCase {
  final VendorRepository repository;

  CreatePaymentOrderUseCase(this.repository);

  Future<Either<Failure, PaymentOrderResponse>> call(PaymentOrderRequest request) {
    return repository.createPaymentOrder(request);
  }
}
