import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/listing/domain/repositories/listing_repository.dart';

class GetAboutUsBannersUseCase {
  final ListingRepository repository;

  GetAboutUsBannersUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getAboutUsBanners();
  }
}
