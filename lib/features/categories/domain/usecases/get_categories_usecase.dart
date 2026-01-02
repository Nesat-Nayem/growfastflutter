import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';

import '../../../../core/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams?> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams? params) {
    return repository.getCategories();
  }
}
