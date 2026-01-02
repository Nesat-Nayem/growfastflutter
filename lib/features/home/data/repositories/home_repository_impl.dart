import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/errors/failure.dart';

import '../../domain/repositories/home_repository.dart';
import '../datasource/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<String>>> getBannerImages() async {
    try {
      final bannerImages = await remoteDataSource.getBannerImages();
      return Right(bannerImages);
    } on ServerException {
      return Left(ServerFailure(message: 'Server error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
