import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/categories/data/datasource/category_remote_data_source.dart';
import 'package:grow_first/features/categories/data/models/category_model.dart';
import 'package:grow_first/features/categories/data/models/subcategory_model.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  static const String url = "serviceCategory";

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await NetworkHelper.sendRequest(
        dio,
        RequestType.get,
        url,
      ) as Map<String, dynamic>;

      final dataList = response['categories'] as List?;
      if (dataList == null) throw ServerException();

      return dataList.map((json) => CategoryModel.fromJson(json)).toList();
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
      final response = await NetworkHelper.sendRequest(
        dio,
        RequestType.get,
        'serviceSubcategory/$categoryId',
      ) as Map<String, dynamic>;

      final dataList = response['subcategories'] as List?;
      if (dataList == null || dataList.isEmpty) throw ServerException();

      return dataList.map((json) => SubcategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
