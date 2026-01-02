import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/listing/data/models/response_model/listing_respose_model.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

abstract class ListingRepository {
  Future<Either<Failure, ListingResponseModel>> getListingsBySubcategory(
    GetListingsParams params,
  );

  Future<Either<Failure, Listing>> getListingDetailById(String id);
}
