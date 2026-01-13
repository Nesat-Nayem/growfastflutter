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
    try {
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

      developer.log(
        'ListingRemoteDataSourceImpl.getListingsBySubcategory => response status: ${response['status']}',
        name: 'ListingRemoteDataSourceImpl',
      );

      if (response['status'] != true) {
        developer.log(
          'ListingRemoteDataSourceImpl.getListingsBySubcategory => API returned status false',
          name: 'ListingRemoteDataSourceImpl',
        );
        throw ServerException();
      }

      final services = response['data']?['services'];
      developer.log(
        'ListingRemoteDataSourceImpl.getListingsBySubcategory => services null? ${services == null}',
        name: 'ListingRemoteDataSourceImpl',
      );
      
      if (services == null) {
        return const ListingResponseModel(
          listings: [],
          total: 0,
          currentPage: 1,
          lastPage: 1,
          perPage: 8,
          hasMorePages: false,
        );
      }

      final rawList = (services['data'] as List?) ?? [];
      developer.log(
        'ListingRemoteDataSourceImpl.getListingsBySubcategory => rawList length: ${rawList.length}',
        name: 'ListingRemoteDataSourceImpl',
      );
      
      final listings = <ListingModel>[];
      for (var e in rawList) {
        try {
          listings.add(ListingModel.fromJson(e));
        } catch (parseError) {
          developer.log(
            'ListingRemoteDataSourceImpl => Error parsing listing: $parseError',
            name: 'ListingRemoteDataSourceImpl',
            error: parseError,
          );
        }
      }

      final totalValue = services['total'];
      final total = totalValue is int
          ? totalValue
          : int.tryParse(totalValue?.toString() ?? '') ?? listings.length;

      final currentPage = services['current_page'] is int
          ? services['current_page']
          : int.tryParse(services['current_page']?.toString() ?? '1') ?? 1;

      final lastPage = services['last_page'] is int
          ? services['last_page']
          : int.tryParse(services['last_page']?.toString() ?? '1') ?? 1;

      final perPage = services['per_page'] is int
          ? services['per_page']
          : int.tryParse(services['per_page']?.toString() ?? '8') ?? 8;

      final hasMorePages = currentPage < lastPage;

      developer.log(
        'ListingRemoteDataSourceImpl.getListingsBySubcategory => mapped listings: ${listings.length}, total: $total, currentPage: $currentPage, lastPage: $lastPage, hasMore: $hasMorePages',
        name: 'ListingRemoteDataSourceImpl',
      );
      
      return ListingResponseModel(
        listings: listings,
        total: total,
        currentPage: currentPage,
        lastPage: lastPage,
        perPage: perPage,
        hasMorePages: hasMorePages,
      );
    } catch (e) {
      developer.log(
        'ListingRemoteDataSourceImpl.getListingsBySubcategory => Exception: $e',
        name: 'ListingRemoteDataSourceImpl',
        error: e,
      );
      rethrow;
    }
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
