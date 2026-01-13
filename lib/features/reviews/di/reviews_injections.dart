import 'package:get_it/get_it.dart';
import 'package:grow_first/features/reviews/data/remote_datasource/reviews_remote_datasource.dart';
import 'package:grow_first/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:grow_first/features/reviews/domain/repositories/review_repository.dart';
import 'package:grow_first/features/reviews/domain/usecase/add_review_usecase.dart';
import '../presentation/bloc/reviews_cubit.dart';

final sl = GetIt.instance;

class ReviewsInjections {
  static void register() {
    sl.registerLazySingleton<ReviewsRemoteDataSource>(
      () => ReviewsRemoteDataSourceImpl(sl()),
    );

    sl.registerLazySingleton(
      () => ReviewRepositoryImpl(sl()),
    );

    sl.registerLazySingleton(
      () => AddReviewUseCase(sl()),
    );

      sl.registerFactory<ReviewsCubit>(
      () => ReviewsCubit(
        sl<ReviewsRemoteDataSource>(),
        sl<AddReviewUseCase>(),
      ),
    );
      sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(sl()),
    );
  }
}
