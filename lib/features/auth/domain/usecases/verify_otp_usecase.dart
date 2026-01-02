import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/auth/domain/entities/auth_response.dart';
import 'package:grow_first/features/auth/domain/repositories/auth_repository.dart';
import 'package:grow_first/features/auth/domain/usecases/params/verify_otp_params.dart';

class VerifyOtpUseCase implements UseCase<AuthResponse, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(VerifyOtpParams params) {
    return repository.verifyOtp(phone: params.phone, otp: params.otp);
  }
}
