import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';

import '../repositories/home_repository.dart';

class GetHomeBannerImagesUseCase implements UseCase<List<String>, NoParams> {
  final HomeRepository repository;

  GetHomeBannerImagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getBannerImages();
  }
}
