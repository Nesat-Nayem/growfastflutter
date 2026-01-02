import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/core/usecase.dart';
import '../entities/subcategory.dart';
import '../repositories/category_repository.dart';

class GetSubcategoriesUseCase implements UseCase<List<Subcategory>, int> {
  final CategoryRepository repository;

  GetSubcategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Subcategory>>> call(int categoryId) {
    return repository.getSubcategories(categoryId);
  }
}
