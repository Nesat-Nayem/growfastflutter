import 'package:grow_first/features/categories/data/models/category_model.dart';
import 'package:grow_first/features/categories/data/models/subcategory_model.dart';

abstract class CategoryRemoteDataSource {
  /// Fetch categories from API
  Future<List<CategoryModel>> getCategories();

  /// Fetch subcategories by category ID
  Future<List<SubcategoryModel>> getSubcategories(int categoryId);
}
