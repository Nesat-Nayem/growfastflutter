import 'package:get_it/get_it.dart';
import 'package:grow_first/core/network/dio_client.dart';
import 'package:grow_first/features/listing/data/remote_datasource_impl/listing_remote_datasource_impl.dart';
import 'package:grow_first/features/listing/data/remote_datasources/listing_remote_datasource.dart';
import 'package:grow_first/features/listing/data/repositories/listing_repository_impl.dart';
import 'package:grow_first/features/listing/domain/repositories/listing_repository.dart';
import 'package:grow_first/features/listing/domain/usecases/get_about_us_banners_usecase.dart';
import 'package:grow_first/features/listing/domain/usecases/get_listing_detail_usecase.dart';
import 'package:grow_first/features/listing/domain/usecases/get_listings_usecase.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';

final sl = GetIt.instance;

class ListingInjections {
  static Future<void> register() async {
    // -----------------------------
    // Bloc
    // -----------------------------
    sl.registerFactory(
      () => ListingBloc(
        sl<GetListingsUseCase>(),
        sl<GetListingDetailUseCase>(),
        sl<GetAboutUsBannersUseCase>(),
      ),
    );

    // -----------------------------
    // Use cases
    // -----------------------------
    sl.registerLazySingleton(() => GetListingsUseCase(sl<ListingRepository>()));
    sl.registerLazySingleton(() => GetListingDetailUseCase(sl<ListingRepository>()));
    sl.registerLazySingleton(() => GetAboutUsBannersUseCase(sl<ListingRepository>()));

    // -----------------------------
    // Repository
    // -----------------------------
    sl.registerLazySingleton<ListingRepository>(
      () => ListingRepositoryImpl(sl<ListingRemoteDataSource>()),
    );

    // -----------------------------
    // Data sources
    // -----------------------------
    sl.registerLazySingleton<ListingRemoteDataSource>(
      () => ListingRemoteDataSourceImpl(sl<DioClient>().dio),
    );
  }
}
