import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/categories/domain/entities/subcategory.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Subcategory>>> getSubcategories(int categoryId);
}
