import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/features/categories/data/datasource/category_remote_data_source.dart';
import 'package:grow_first/features/categories/data/models/category_model.dart';
import 'package:grow_first/features/categories/data/models/subcategory_model.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  static const String url = "http://laravel.test/api/serviceCategory";

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        // Ensure 'data' key exists and is a list
        final dataList =
            response.data['categories']
                as List?; // adjust if API wraps list under 'data'
        if (dataList == null) throw ServerException();

        // Map JSON to CategoryModel
        return dataList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message:
              'Failed to fetch categories. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Optional: log DioError
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SubcategoryModel>> getSubcategories(int categoryId) async {
    try {
      final response = await dio.get(
        'http://laravel.test/api/serviceSubcategory/$categoryId',
      );

      if (response.statusCode == 200) {
        final dataList = response.data['subcategories'] as List?;
        if (dataList == null || dataList == []) throw ServerException();

        return dataList.map((json) => SubcategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message:
              'Failed to fetch subcategories. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
