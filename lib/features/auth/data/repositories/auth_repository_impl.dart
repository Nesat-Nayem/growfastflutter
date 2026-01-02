import 'package:dartz/dartz.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:grow_first/features/auth/domain/entities/auth_response.dart';
import 'package:grow_first/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AppStore appStore;

  AuthRepositoryImpl(this.remoteDataSource, this.appStore);

  @override
  Future<Either<Failure, int>> sendOtp(String phone) async {
    try {
      final userId = await remoteDataSource.sendOtp(phone);
      return Right(userId);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await remoteDataSource.verifyOtp(phone: phone, otp: otp);
      if (response.token.isNotEmpty) {
        await appStore.saveAuth(response);
      }
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
