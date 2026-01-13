import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';

import '../../domain/repositories/home_repository.dart';
import '../datasource/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomePageResponse>> getHomePageData() async {
    try {
      final response = await remoteDataSource.getHomePageData();
      return Right(response);
    } on ServerException {
      return Left(ServerFailure(message: 'Server error'));
    }
  }
}

