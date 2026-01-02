import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grow_first/features/vendor_dashboard/data/datasource_impl/vendor_remote_datasource_impl.dart';
import 'package:grow_first/features/vendor_dashboard/data/datasources/vendor_remote_datasource.dart';
import 'package:grow_first/features/vendor_dashboard/data/repositories/vendor_repository_impl.dart';
import 'package:grow_first/features/vendor_dashboard/domain/repositories/vendor_repository.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_cities_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_countries_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/get_states_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/domain/usecase/vendor_registration_step_1_usecase.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';

final sl = GetIt.instance;

class VendorInjections {
  static Future<void> register() async {
    // -----------------------------
    // Bloc
    // -----------------------------
    sl.registerCachedFactory(
      () => VendorBloc(
        sl<GetCountriesUseCase>(),
        sl<GetStatesUseCase>(),
        sl<GetCitiesUseCase>(),
        sl<RegisterStep1UseCase>(),
      ),
    );

    // -----------------------------
    // Use cases
    // -----------------------------
    sl.registerLazySingleton(() => GetCountriesUseCase(sl<VendorRepository>()));
    sl.registerLazySingleton(() => GetStatesUseCase(sl<VendorRepository>()));
    sl.registerLazySingleton(() => GetCitiesUseCase(sl<VendorRepository>()));
    sl.registerLazySingleton(
      () => RegisterStep1UseCase(sl<VendorRepository>()),
    );

    // -----------------------------
    // Repository
    // -----------------------------
    sl.registerLazySingleton<VendorRepository>(
      () => VendorRepositoryImpl(sl<VendorRemoteDatasource>()),
    );

    // -----------------------------
    // Data sources
    // -----------------------------
    sl.registerLazySingleton<VendorRemoteDatasource>(
      () => VendorRemoteDatasourceImpl(sl<Dio>()),
    );
  }
}
