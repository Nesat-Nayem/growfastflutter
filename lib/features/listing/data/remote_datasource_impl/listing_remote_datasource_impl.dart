import 'package:dio/dio.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/features/listing/data/models/listing_model.dart';
import 'package:grow_first/features/listing/data/models/response_model/listing_respose_model.dart';
import 'package:grow_first/features/listing/data/remote_datasources/listing_remote_datasource.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  final Dio dio;

  ListingRemoteDataSourceImpl(this.dio);

  @override
  Future<ListingResponseModel> getListingsBySubcategory(
    GetListingsParams params,
  ) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'http://laravel.test/api/customer/services',
      queryParams: params.toQuery(),
    );

    if (response['status'] == true) {
      final services = response['data']['services'];
      final list = services['data'] as List?;

      if (list == null) {
        return const ListingResponseModel(listings: [], total: 0);
      }

      final listings = list.map((e) => ListingModel.fromJson(e)).toList();

      return ListingResponseModel(listings: listings, total: services['total']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ListingModel> getListingDetailById(String id) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'http://laravel.test/api/customer/service/$id',
    );

    if (response['status'] == true) {
      return ListingModel.fromJson(response['data']['service']);
    } else {
      throw ServerException();
    }
  }
}
