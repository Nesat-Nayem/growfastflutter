import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/categories/data/datasource/category_remote_data_source.dart';
import 'package:grow_first/features/categories/data/models/subcategory_model.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final List<CategoryModel> categoryModels = await remoteDataSource
          .getCategories();

      // Convert models to entities
      final List<Category> categories = categoryModels
          .map((model) => model)
          .toList();

      return Right(categories);
    } catch (e) {
      // Here you can map exceptions to your Failure types
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubcategoryModel>>> getSubcategories(
    int categoryId,
  ) async {
    try {
      final List<SubcategoryModel> subcategoryModels = await remoteDataSource
          .getSubcategories(categoryId);
      return Right(subcategoryModels);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
