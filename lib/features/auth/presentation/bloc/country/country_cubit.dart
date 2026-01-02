import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/auth/domain/usecases/get_countries.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final GetCountries getCountries;

  CountryCubit(this.getCountries) : super(CountryInitial()) {
    fetchCountries();
  }

  Future<void> fetchCountries({String? name, int? page}) async {
    emit(CountryLoading());

    final result = await getCountries(NoParams());

    result.fold(
      (failure) => emit(CountryError(Helpers.convertFailureToMessage(failure))),
      (countries) => emit(CountryLoaded(countries)),
    );
  }
}
