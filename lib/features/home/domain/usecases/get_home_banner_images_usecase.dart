import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';

import '../repositories/home_repository.dart';

class GetHomePageDataUseCase
    implements UseCase<HomePageResponse, NoParams> {
  final HomeRepository repository;

  GetHomePageDataUseCase(this.repository);

  @override
  Future<Either<Failure, HomePageResponse>> call(NoParams params) {
    return repository.getHomePageData();
  }
}
