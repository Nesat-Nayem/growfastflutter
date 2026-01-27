import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/auth/domain/entities/send_otp_response.dart';
import 'package:grow_first/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<SendOtpResponse, String> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, SendOtpResponse>> call(String phone) {
    return repository.sendOtp(phone);
  }
}
