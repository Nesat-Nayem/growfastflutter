import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/listing/data/models/response_model/listing_respose_model.dart';
import 'package:grow_first/features/listing/domain/repositories/listing_repository.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

class GetListingsUseCase
    implements UseCase<ListingResponseModel, GetListingsParams> {
  final ListingRepository repository;

  GetListingsUseCase(this.repository);

  @override
  Future<Either<Failure, ListingResponseModel>> call(GetListingsParams params) {
    return repository.getListingsBySubcategory(params);
  }
}
