import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import '../repositories/vendor_repository.dart';

class RegisterStep1UseCase {
  final VendorRepository repository;

  RegisterStep1UseCase(this.repository);

  Future<Either<Failure, void>> call(VendorStep1Request request) async {
    try {
      await repository.registerStep1(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
