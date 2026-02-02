import 'package:grow_first/features/vendor_dashboard/data/models/city_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';

import '../models/country_dto.dart';
import '../models/state_dto.dart';

abstract class VendorRemoteDatasource {
  Future<List<CountryDto>> getCountries();
  Future<List<StateDto>> getStates(int countryId);
  Future<List<CityDto>> getCities(int stateId);

  // Step 1: Basic Details
  Future<VendorStep1Response> registerStep1(VendorStep1Request request);

  // Step 2: Get Plans
  Future<PlansResponse> getPlans(String token);

  // Step 2: Create Payment Order
  Future<PaymentOrderResponse> createPaymentOrder(PaymentOrderRequest request);

  // Step 2: Store Payment (after successful payment)
  Future<StorePaymentResponse> storePayment(StorePaymentRequest request, String token);

  // Step 3: Upload KYC
  Future<KycUploadResponse> uploadKyc(KycUploadRequest request, String token);
}
