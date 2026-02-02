import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../entities/country_entity.dart';
import '../entities/state_entity.dart';

abstract class VendorRepository {
  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<StateEntity>>> getStates(int countryId);
  Future<Either<Failure, List<CityEntity>>> getCities(int stateId);

  // Step 1
  Future<Either<Failure, VendorStep1Response>> registerStep1(VendorStep1Request request);

  // Step 2
  Future<Either<Failure, PlansResponse>> getPlans(String token);
  Future<Either<Failure, PaymentOrderResponse>> createPaymentOrder(PaymentOrderRequest request);
  Future<Either<Failure, StorePaymentResponse>> storePayment(StorePaymentRequest request);

  // Step 3
  Future<Either<Failure, KycUploadResponse>> uploadKyc(KycUploadRequest request, int vendorId);
}
