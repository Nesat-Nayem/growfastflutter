import 'package:equatable/equatable.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

class LoadCountries extends VendorEvent {}

class LoadStates extends VendorEvent {
  final int countryId;
  const LoadStates(this.countryId);

  @override
  List<Object?> get props => [countryId];
}

class LoadCities extends VendorEvent {
  final int stateId;
  const LoadCities(this.stateId);

  @override
  List<Object?> get props => [stateId];
}

// Step 1: Submit basic details
class SubmitVendorStep1 extends VendorEvent {
  final VendorStep1Request request;
  const SubmitVendorStep1(this.request);

  @override
  List<Object?> get props => [request];
}

// Step 2: Load plans
class LoadPlans extends VendorEvent {
  const LoadPlans();
}

// Step 2: Select plan
class SelectPlan extends VendorEvent {
  final int planId;
  const SelectPlan(this.planId);

  @override
  List<Object?> get props => [planId];
}

// Step 2: Create payment order
class CreatePaymentOrder extends VendorEvent {
  final int planId;
  final String gateway;
  const CreatePaymentOrder({required this.planId, this.gateway = 'razorpay'});

  @override
  List<Object?> get props => [planId, gateway];
}

// Step 2: Store payment after success
class StorePayment extends VendorEvent {
  final StorePaymentRequest request;
  const StorePayment(this.request);

  @override
  List<Object?> get props => [request];
}

// Step 3: Upload KYC
class UploadKyc extends VendorEvent {
  final KycUploadRequest request;
  const UploadKyc(this.request);

  @override
  List<Object?> get props => [request];
}

// Reset registration state
class ResetVendorRegistration extends VendorEvent {}
