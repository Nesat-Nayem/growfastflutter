import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomePageResponse>> getHomePageData();
}