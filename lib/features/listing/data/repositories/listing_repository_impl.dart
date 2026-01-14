import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/listing/data/models/response_model/listing_respose_model.dart';
import 'package:grow_first/features/listing/data/remote_datasources/listing_remote_datasource.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/repositories/listing_repository.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource remoteDataSource;

  ListingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ListingResponseModel>> getListingsBySubcategory(
    GetListingsParams params,
  ) async {
    try {
      final models = await remoteDataSource.getListingsBySubcategory(params);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> getListingDetailById(String id) async {
    try {
      final model = await remoteDataSource.getListingDetailById(id);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAboutUsBanners() async {
    try {
      final banners = await remoteDataSource.getAboutUsBanners();
      return Right(banners);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
