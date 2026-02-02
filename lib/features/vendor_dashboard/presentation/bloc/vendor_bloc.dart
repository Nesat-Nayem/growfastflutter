import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/create_payment_order_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_cities_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_countries_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_plans_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_states_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/store_payment_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/upload_kyc_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/vendor_registration_step_1_usecase.dart';

import 'vendor_event.dart';
import 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final RegisterStep1UseCase registerStep1UseCase;
  final GetPlansUseCase getPlansUseCase;
  final CreatePaymentOrderUseCase createPaymentOrderUseCase;
  final StorePaymentUseCase storePaymentUseCase;
  final UploadKycUseCase uploadKycUseCase;

  VendorBloc(
    this.getCountriesUseCase,
    this.getStatesUseCase,
    this.getCitiesUseCase,
    this.registerStep1UseCase,
    this.getPlansUseCase,
    this.createPaymentOrderUseCase,
    this.storePaymentUseCase,
    this.uploadKycUseCase,
  ) : super(const VendorState()) {
    on<LoadCountries>(_onLoadCountries);
    on<LoadStates>(_onLoadStates);
    on<LoadCities>(_onLoadCities);
    on<SubmitVendorStep1>(_onSubmitVendorStep1);
    on<LoadPlans>(_onLoadPlans);
    on<SelectPlan>(_onSelectPlan);
    on<CreatePaymentOrder>(_onCreatePaymentOrder);
    on<StorePayment>(_onStorePayment);
    on<UploadKyc>(_onUploadKyc);
    on<ResetVendorRegistration>(_onResetRegistration);
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<VendorState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getCountriesUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (countries) =>
          emit(state.copyWith(isLoading: false, countries: countries)),
    );
  }

  Future<void> _onLoadStates(
    LoadStates event,
    Emitter<VendorState> emit,
  ) async {
    emit(state.copyWith(isStatesLoading: true, states: []));

    final result = await getStatesUseCase(event.countryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isStatesLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (states) => emit(state.copyWith(isStatesLoading: false, states: states)),
    );
  }

  Future<void> _onLoadCities(
    LoadCities event,
    Emitter<VendorState> emit,
  ) async {
    emit(state.copyWith(isCitiesLoading: true, cities: []));

    final result = await getCitiesUseCase(event.stateId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isCitiesLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (cities) => emit(state.copyWith(isCitiesLoading: false, cities: cities)),
    );
  }

  Future<void> _onSubmitVendorStep1(
    SubmitVendorStep1 event,
    Emitter<VendorState> emit,
  ) async {
    emit(state.copyWith(
      isSubmittingStep1: true,
      step1Error: null,
      step1Success: false,
    ));

    final result = await registerStep1UseCase(event.request);

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmittingStep1: false,
        step1Error: Helpers.convertFailureToMessage(failure),
      )),
      (response) => emit(state.copyWith(
        isSubmittingStep1: false,
        step1Success: true,
        vendorToken: response.token,
        vendorId: response.vendor.id,
        vendorData: response.vendor,
      )),
    );
  }

  Future<void> _onLoadPlans(
    LoadPlans event,
    Emitter<VendorState> emit,
  ) async {
    // Debug: Log the current state
    print('VendorBloc: Loading plans, vendorToken: ${state.vendorToken}');
    
    emit(state.copyWith(isLoadingPlans: true, plansError: null));

    // Use token if available, otherwise pass empty string (API should work without auth)
    final token = state.vendorToken ?? '';
    final result = await getPlansUseCase(token);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingPlans: false,
        plansError: Helpers.convertFailureToMessage(failure),
      )),
      (response) => emit(state.copyWith(
        isLoadingPlans: false,
        plans: response.plans,
      )),
    );
  }

  void _onSelectPlan(
    SelectPlan event,
    Emitter<VendorState> emit,
  ) {
    emit(state.copyWith(selectedPlanId: event.planId));
  }

  Future<void> _onCreatePaymentOrder(
    CreatePaymentOrder event,
    Emitter<VendorState> emit,
  ) async {
    if (state.vendorId == null || state.vendorToken == null) {
      emit(state.copyWith(
        isCreatingOrder: false,
        paymentError: 'Session expired. Please restart registration.',
      ));
      return;
    }

    emit(state.copyWith(isCreatingOrder: true, paymentError: null));

    final request = PaymentOrderRequest(
      vendorId: state.vendorId!,
      planId: event.planId,
      gateway: event.gateway,
    );

    final result = await createPaymentOrderUseCase(request);

    result.fold(
      (failure) => emit(state.copyWith(
        isCreatingOrder: false,
        paymentError: Helpers.convertFailureToMessage(failure),
      )),
      (response) => emit(state.copyWith(
        isCreatingOrder: false,
        paymentOrder: response,
        selectedPlanId: event.planId,
      )),
    );
  }

  Future<void> _onStorePayment(
    StorePayment event,
    Emitter<VendorState> emit,
  ) async {
    if (state.vendorId == null) {
      emit(state.copyWith(
        isStoringPayment: false,
        paymentError: 'Session expired. Please restart registration.',
      ));
      return;
    }

    emit(state.copyWith(isStoringPayment: true, paymentError: null));

    // Create request with vendor_id
    final request = StorePaymentRequest(
      planId: event.request.planId,
      transactionId: event.request.transactionId,
      vendorId: state.vendorId!,
    );

    final result = await storePaymentUseCase(request);

    result.fold(
      (failure) => emit(state.copyWith(
        isStoringPayment: false,
        paymentError: Helpers.convertFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        isStoringPayment: false,
        paymentSuccess: true,
      )),
    );
  }

  Future<void> _onUploadKyc(
    UploadKyc event,
    Emitter<VendorState> emit,
  ) async {
    if (state.vendorId == null) {
      emit(state.copyWith(
        isUploadingKyc: false,
        kycError: 'Session expired. Please restart registration.',
      ));
      return;
    }

    emit(state.copyWith(isUploadingKyc: true, kycError: null));

    final result = await uploadKycUseCase(event.request, state.vendorId!);

    result.fold(
      (failure) => emit(state.copyWith(
        isUploadingKyc: false,
        kycError: Helpers.convertFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        isUploadingKyc: false,
        kycSuccess: true,
        registrationComplete: true,
      )),
    );
  }

  void _onResetRegistration(
    ResetVendorRegistration event,
    Emitter<VendorState> emit,
  ) {
    emit(const VendorState());
  }
}
