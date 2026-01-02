import 'package:equatable/equatable.dart';
import 'package:grow_first/features/vendor_dashboard/domain/entities/city_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/entities/country_entity.dart';

class VendorState extends Equatable {
  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final bool isLoading;
  final bool isStatesLoading;
  final String? error;
  final List<CityEntity> cities;
  final bool isCitiesLoading;

  final bool isSubmittingStep1;
  final String? step1Error;
  final bool step1Success;

  const VendorState({
    this.countries = const [],
    this.states = const [],
    this.isLoading = false,
    this.isStatesLoading = false,
    this.error,
    this.cities = const [],
    this.isCitiesLoading = false,
    this.isSubmittingStep1 = false,
    this.step1Error,
    this.step1Success = false,
  });

  VendorState copyWith({
    List<CountryEntity>? countries,
    List<StateEntity>? states,
    bool? isLoading,
    bool? isStatesLoading,
    String? error,
    List<CityEntity>? cities,
    bool? isCitiesLoading,
    bool? isSubmittingStep1,
    String? step1Error,
    bool? step1Success,
  }) {
    return VendorState(
      countries: countries ?? this.countries,
      states: states ?? this.states,
      isLoading: isLoading ?? this.isLoading,
      isStatesLoading: isStatesLoading ?? this.isStatesLoading,
      error: error,
      cities: cities ?? this.cities,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      isSubmittingStep1: isSubmittingStep1 ?? this.isSubmittingStep1,
      step1Error: step1Error,
      step1Success: step1Success ?? this.step1Success,
    );
  }

  @override
  List<Object?> get props => [
    countries,
    states,
    isLoading,
    isStatesLoading,
    error,
    cities,
    isCitiesLoading,
    isSubmittingStep1,
    step1Error,
    step1Success,
  ];
}
