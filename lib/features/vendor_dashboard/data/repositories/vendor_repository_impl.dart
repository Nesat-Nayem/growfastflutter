import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_datasource.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDatasource remoteDataSource;

  VendorRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    try {
      final result = await remoteDataSource.getCountries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to load countries'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(int countryId) async {
    try {
      final result = await remoteDataSource.getStates(countryId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to load states'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getCities(int stateId) async {
    try {
      final result = await remoteDataSource.getCities(stateId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to load cities'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VendorStep1Response>> registerStep1(VendorStep1Request request) async {
    try {
      final result = await remoteDataSource.registerStep1(request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Registration failed'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PlansResponse>> getPlans(String token) async {
    try {
      final result = await remoteDataSource.getPlans(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to load plans'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PaymentOrderResponse>> createPaymentOrder(PaymentOrderRequest request) async {
    try {
      final result = await remoteDataSource.createPaymentOrder(request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to create order'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StorePaymentResponse>> storePayment(StorePaymentRequest request, String token) async {
    try {
      final result = await remoteDataSource.storePayment(request, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to store payment'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, KycUploadResponse>> uploadKyc(KycUploadRequest request, String token) async {
    try {
      final result = await remoteDataSource.uploadKyc(request, token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'KYC upload failed'));
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
