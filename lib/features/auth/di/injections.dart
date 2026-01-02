import 'package:dio/dio.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:grow_first/features/auth/data/datasources/country_remote_datasource.dart';
import 'package:grow_first/features/auth/data/datasources_impl/auth_remote_datasource_impl.dart';
import 'package:grow_first/features/auth/data/datasources_impl/country_remote_datasource_impl.dart';
import 'package:grow_first/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grow_first/features/auth/data/repositories/country_repository_impl.dart';
import 'package:grow_first/features/auth/domain/repositories/auth_repository.dart';
import 'package:grow_first/features/auth/domain/repositories/country_repository.dart';
import 'package:grow_first/features/auth/domain/usecases/get_countries.dart';
import 'package:grow_first/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:grow_first/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';

class AuthInjections {
  static void register() {
    // Datasources
    sl.registerLazySingleton<CountryRemoteDatasource>(
      () => CountryRemoteDatasourceImpl(Dio()..options = BaseOptions()),
    );

    // Repositories
    sl.registerLazySingleton<CountryRepository>(
      () => CountryRepositoryImpl(sl<CountryRemoteDatasource>()),
    );

    // UseCases
    sl.registerLazySingleton(() => GetCountries(sl<CountryRepository>()));

    // Cubits / Blocs
    sl.registerCachedFactory(() => CountryCubit(sl<GetCountries>()));

    // Datasource
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<Dio>()),
    );

    sl.registerCachedFactory<AppStore>(() => AppStore(sl<ISecureStore>()));

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<AppStore>()),
    );

    // UseCases
    sl.registerLazySingleton(() => SendOtpUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));

    // Bloc
    sl.registerCachedFactory(
      () => AuthBloc(sl<SendOtpUseCase>(), sl<VerifyOtpUseCase>()),
    );
  }
}
