import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/features/home/data/datasource/home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  static const String url = "home-page";

  @override
  Future<List<String>> getBannerImages() async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return List<String>.from(response.data['bannerImages']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

// we need to add some more logics into it