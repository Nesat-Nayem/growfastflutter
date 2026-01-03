import 'package:get_it/get_it.dart';
import 'package:grow_first/core/network/dio_client.dart';
import 'package:grow_first/features/categories/data/datasource/category_remote_data_source.dart';
import 'package:grow_first/features/categories/data/datasource_impl/category_remote_data_source_impl.dart';
import 'package:grow_first/features/categories/data/repostories/category_repository_impl.dart';
import 'package:grow_first/features/categories/domain/repositories/category_repository.dart';
import 'package:grow_first/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:grow_first/features/categories/domain/usecases/get_subcategories_usecase.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';

final sl = GetIt.instance; // optional: use app-level sl if already defined

class CategoryInjections {
  static Future<void> register() async {
    // -----------------------------
    // Bloc
    // -----------------------------
    sl.registerCachedFactory(() => CategoryBloc(sl(), sl()));

    // -----------------------------
    // Use cases
    // -----------------------------
    sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetSubcategoriesUseCase(sl()));

    // -----------------------------
    // Repository
    // -----------------------------
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(remoteDataSource: sl()),
    );

    // -----------------------------
    // Data sources
    // -----------------------------
    sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(sl<DioClient>().dio),
    );
  }
}
