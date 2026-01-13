import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/features/home/data/datasource/home_remote_datasource.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';
import 'package:grow_first/features/home/data/model/home_service_model.dart';
import 'package:grow_first/features/home/data/model/recent_search_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  static const String url =
      "https://growfirst.org/api/home-page"; // ✅ FULL URL
      static const String recentUrl =
    "https://growfirst.org/api/customer/recent-searches?location=dewas";

  @override
  Future<HomePageResponse> getHomePageData() async {
    try {
      final response = await dio.get(url);
      debugPrint("🔥 CALLING RECENT SEARCH API");
          final recentResponse = await dio.get(recentUrl);
debugPrint("🔥 RECENT RESPONSE: ${recentResponse.data}");
      if (response.statusCode == 200 && recentResponse.statusCode == 200) {
        debugPrint("✅ HOME API HIT SUCCESS");
  final recentList =
          recentResponse.data['data']['data'] as List;
          print("Recent sorted list is :$recentList");
        return HomePageResponse(
          bannerImages: List<String>.from(response.data['bannerImages']),
          services: (response.data['services'] as List)
              .map((e) => HomeServiceModel.fromJson(e))
              .toList(),
              recentSearches: recentList
            .map((e) => RecentSearchModel.fromJson(e))
            .toList(),
            
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint("❌ HOME API ERROR: $e");
      throw ServerException();
    }
  }


}
