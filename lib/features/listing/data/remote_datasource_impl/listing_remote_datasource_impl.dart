import 'dart:developer' as developer;

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
    developer.log(
      'ListingRemoteDataSourceImpl.getListingsBySubcategory => params: ${params.toQuery()}',
      name: 'ListingRemoteDataSourceImpl',
    );
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'customer/services',
      queryParams: params.toQuery(),
    );

    if (response['status'] != true) {
      throw ServerException();
    }

    final services = response['data']?['services'];
    developer.log(
      'ListingRemoteDataSourceImpl.getListingsBySubcategory => services null? ${services == null}',
      name: 'ListingRemoteDataSourceImpl',
    );
    if (services == null) {
      return const ListingResponseModel(listings: [], total: 0);
    }

    final rawList = (services['data'] as List?) ?? [];
    developer.log(
      'ListingRemoteDataSourceImpl.getListingsBySubcategory => rawList length: ${rawList.length}',
      name: 'ListingRemoteDataSourceImpl',
    );
    final listings = rawList.map((e) => ListingModel.fromJson(e)).toList();

    final totalValue = services['total'];
    final total = totalValue is int
        ? totalValue
        : int.tryParse(totalValue?.toString() ?? '') ?? listings.length;

    developer.log(
      'ListingRemoteDataSourceImpl.getListingsBySubcategory => mapped listings: ${listings.length}, total: $total',
      name: 'ListingRemoteDataSourceImpl',
    );
    return ListingResponseModel(listings: listings, total: total);
  }

  @override
  Future<ListingModel> getListingDetailById(String id) async {
    final response = await NetworkHelper.sendRequest(
      dio,
      RequestType.get,
      'customer/service/$id',
    );

    if (response['status'] == true) {
      return ListingModel.fromJson(response['data']['service']);
    } else {
      throw ServerException();
    }
  }
}
