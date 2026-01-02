import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<String>>> getBannerImages();
}
