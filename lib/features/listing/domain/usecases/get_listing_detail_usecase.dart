import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/domain/repositories/listing_repository.dart';

class GetListingDetailUseCase implements UseCase<Listing, String> {
  final ListingRepository repository;

  GetListingDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Listing>> call(String id) {
    return repository.getListingDetailById(id);
  }
}
