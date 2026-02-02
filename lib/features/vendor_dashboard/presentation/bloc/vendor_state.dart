import 'package:equatable/equatable.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/vendor_step_one_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/entities/country_entity.dart';

class VendorState extends Equatable {
  // Location data
  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final List<CityEntity> cities;
  final bool isLoading;
  final bool isStatesLoading;
  final bool isCitiesLoading;
  final String? error;

  // Step 1: Basic Details
  final bool isSubmittingStep1;
  final String? step1Error;
  final bool step1Success;
  final String? vendorToken;
  final int? vendorId;
  final VendorData? vendorData;
  final int? selectedCountryId; // Store country ID from step 1 for KYC page

  // Step 2: Plans
  final List<PlanDto> plans;
  final bool isLoadingPlans;
  final String? plansError;
  final int? selectedPlanId;

  // Step 2: Payment
  final bool isCreatingOrder;
  final PaymentOrderResponse? paymentOrder;
  final String? paymentError;
  final bool isStoringPayment;
  final bool paymentSuccess;

  // Step 3: KYC
  final bool isUploadingKyc;
  final String? kycError;
  final bool kycSuccess;

  // Overall registration
  final bool registrationComplete;

  const VendorState({
    this.countries = const [],
    this.states = const [],
    this.cities = const [],
    this.isLoading = false,
    this.isStatesLoading = false,
    this.isCitiesLoading = false,
    this.error,
    this.isSubmittingStep1 = false,
    this.step1Error,
    this.step1Success = false,
    this.vendorToken,
    this.vendorId,
    this.vendorData,
    this.selectedCountryId,
    this.plans = const [],
    this.isLoadingPlans = false,
    this.plansError,
    this.selectedPlanId,
    this.isCreatingOrder = false,
    this.paymentOrder,
    this.paymentError,
    this.isStoringPayment = false,
    this.paymentSuccess = false,
    this.isUploadingKyc = false,
    this.kycError,
    this.kycSuccess = false,
    this.registrationComplete = false,
  });

  VendorState copyWith({
    List<CountryEntity>? countries,
    List<StateEntity>? states,
    List<CityEntity>? cities,
    bool? isLoading,
    bool? isStatesLoading,
    bool? isCitiesLoading,
    String? error,
    bool? isSubmittingStep1,
    String? step1Error,
    bool? step1Success,
    String? vendorToken,
    int? vendorId,
    VendorData? vendorData,
    int? selectedCountryId,
    List<PlanDto>? plans,
    bool? isLoadingPlans,
    String? plansError,
    int? selectedPlanId,
    bool? isCreatingOrder,
    PaymentOrderResponse? paymentOrder,
    String? paymentError,
    bool? isStoringPayment,
    bool? paymentSuccess,
    bool? isUploadingKyc,
    String? kycError,
    bool? kycSuccess,
    bool? registrationComplete,
  }) {
    return VendorState(
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      isLoading: isLoading ?? this.isLoading,
      isStatesLoading: isStatesLoading ?? this.isStatesLoading,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      error: error,
      isSubmittingStep1: isSubmittingStep1 ?? this.isSubmittingStep1,
      step1Error: step1Error,
      step1Success: step1Success ?? this.step1Success,
      vendorToken: vendorToken ?? this.vendorToken,
      vendorId: vendorId ?? this.vendorId,
      vendorData: vendorData ?? this.vendorData,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      plans: plans ?? this.plans,
      isLoadingPlans: isLoadingPlans ?? this.isLoadingPlans,
      plansError: plansError,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      isCreatingOrder: isCreatingOrder ?? this.isCreatingOrder,
      paymentOrder: paymentOrder ?? this.paymentOrder,
      paymentError: paymentError,
      isStoringPayment: isStoringPayment ?? this.isStoringPayment,
      paymentSuccess: paymentSuccess ?? this.paymentSuccess,
      isUploadingKyc: isUploadingKyc ?? this.isUploadingKyc,
      kycError: kycError,
      kycSuccess: kycSuccess ?? this.kycSuccess,
      registrationComplete: registrationComplete ?? this.registrationComplete,
    );
  }

  @override
  List<Object?> get props => [
    countries,
    states,
    cities,
    isLoading,
    isStatesLoading,
    isCitiesLoading,
    error,
    isSubmittingStep1,
    step1Error,
    step1Success,
    vendorToken,
    vendorId,
    vendorData,
    selectedCountryId,
    plans,
    isLoadingPlans,
    plansError,
    selectedPlanId,
    isCreatingOrder,
    paymentOrder,
    paymentError,
    isStoringPayment,
    paymentSuccess,
    isUploadingKyc,
    kycError,
    kycSuccess,
    registrationComplete,
  ];
}
