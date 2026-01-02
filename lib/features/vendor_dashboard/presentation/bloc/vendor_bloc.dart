import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_cities_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_countries_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_states_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/vendor_registration_step_1_usecase.dart';

import 'vendor_event.dart';
import 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetStatesUseCase getStatesUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final RegisterStep1UseCase registerStep1UseCase;

  VendorBloc(
    this.getCountriesUseCase,
    this.getStatesUseCase,
    this.getCitiesUseCase,
    this.registerStep1UseCase,
  ) : super(const VendorState()) {
    on<LoadCountries>(_onLoadCountries);
    on<LoadStates>(_onLoadStates);
    on<LoadCities>(_onLoadCities);
    // New event handler for Step1 registration
    on<SubmitVendorStep1>(_onSubmitVendorStep1);
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
    emit(
      state.copyWith(
        isSubmittingStep1: true,
        step1Error: null,
        step1Success: false,
      ),
    );

    final result = await registerStep1UseCase(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmittingStep1: false,
          step1Error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (_) {
        emit(state.copyWith(isSubmittingStep1: false, step1Success: true));
      },
    );
  }
}
