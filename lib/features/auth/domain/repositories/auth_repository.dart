import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/auth/domain/entities/auth_response.dart';
import 'package:grow_first/features/auth/domain/entities/send_otp_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, SendOtpResponse>> sendOtp(String phone);

  Future<Either<Failure, AuthResponse>> verifyOtp({
    required String phone,
    required String otp,
  });
}
