import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grow_first/features/home/data/datasource/home_remote_datasource.dart';
import 'package:grow_first/features/home/data/datasource_impl/home_remote_datasource_impl.dart';
import 'package:grow_first/features/home/data/repositories/home_repository_impl.dart';
import 'package:grow_first/features/home/domain/repositories/home_repository.dart';
import 'package:grow_first/features/home/domain/usecases/get_home_banner_images_usecase.dart';
import 'package:grow_first/features/home/domain/usecases/get_services_by_type_usecase.dart';
import 'package:grow_first/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grow_first/features/home/presentation/bloc/service_sections_bloc.dart';

final sl = GetIt.instance;

class HomeInjections {
  static Future<void> register() async {
    // -----------------------------
    // Bloc
    // -----------------------------
    sl.registerFactory(() => HomePageBloc(sl<GetHomePageDataUseCase>()));
    sl.registerFactory(() => ServiceSectionsBloc(sl<GetServicesByTypeUseCase>()));

    // -----------------------------
    // Use cases
    // -----------------------------
    sl.registerLazySingleton(
      () => GetHomePageDataUseCase(sl<HomeRepository>()),
    );
    sl.registerLazySingleton(
      () => GetServicesByTypeUseCase(sl<HomeRepository>()),
    );

    // -----------------------------
    // Repository
    // -----------------------------
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDataSource>()),
    );

    // -----------------------------
    // Data sources (if you had them)
    // -----------------------------
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl((sl<Dio>())),
    );
  }
}
