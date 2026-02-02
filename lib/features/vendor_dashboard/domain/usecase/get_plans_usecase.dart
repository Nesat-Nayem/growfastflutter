import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import '../repositories/vendor_repository.dart';

class GetPlansUseCase {
  final VendorRepository repository;

  GetPlansUseCase(this.repository);

  Future<Either<Failure, PlansResponse>> call(String token) {
    return repository.getPlans(token);
  }
}
