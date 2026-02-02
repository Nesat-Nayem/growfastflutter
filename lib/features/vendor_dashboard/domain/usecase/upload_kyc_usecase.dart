import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import '../repositories/vendor_repository.dart';

class UploadKycUseCase {
  final VendorRepository repository;

  UploadKycUseCase(this.repository);

  Future<Either<Failure, KycUploadResponse>> call(KycUploadRequest request, String token) {
    return repository.uploadKyc(request, token);
  }
}
