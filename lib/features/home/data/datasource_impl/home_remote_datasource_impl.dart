import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/errors/exceptions.dart';
import 'package:grow_first/features/home/data/datasource/home_remote_datasource.dart';
import 'package:grow_first/features/home/data/model/banner_model.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';
import 'package:grow_first/features/home/data/model/home_service_model.dart';
import 'package:grow_first/features/home/data/model/recent_search_model.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';
import 'package:grow_first/features/home/data/model/slider_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  static const String url = "http://public.test/api/home-page";
  static const String recentUrl =
      "http://public.test/api/customer/recent-searches?location=dewas";
  static const String servicesByTypeUrl =
      "http://public.test/api/customer/recent-searches";

  @override
  Future<HomePageResponse> getHomePageData() async {
    try {
      final response = await dio.get(url);
      debugPrint("🔥 CALLING RECENT SEARCH API");
      final recentResponse = await dio.get(recentUrl);
      debugPrint("🔥 RECENT RESPONSE: ${recentResponse.data}");
      
      final apkBanners = await getApkBanners();
      final apkSliders = await getApkSliders();
      
      if (response.statusCode == 200 && recentResponse.statusCode == 200) {
        debugPrint("✅ HOME API HIT SUCCESS");
        final recentList = recentResponse.data['data']['data'] as List;
        debugPrint("Recent sorted list is :$recentList");
        return HomePageResponse(
          bannerImages: List<String>.from(response.data['bannerImages']),
          services: (response.data['services'] as List)
              .map((e) => HomeServiceModel.fromJson(e))
              .toList(),
          recentSearches: recentList
              .map((e) => RecentSearchModel.fromJson(e))
              .toList(),
          apkBanners: apkBanners,
          apkSliders: apkSliders,
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint("❌ HOME API ERROR: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<ServiceSectionModel>> getServicesByType(String serviceType) async {
    try {
      final response = await dio.get(
        servicesByTypeUrl,
        queryParameters: {'service_type': serviceType},
      );
      debugPrint("🔥 SERVICES BY TYPE ($serviceType) RESPONSE: ${response.data}");
      
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final servicesList = response.data['data']['data'] as List;
        return servicesList
            .map((e) => ServiceSectionModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("❌ SERVICES BY TYPE ($serviceType) ERROR: $e");
      return [];
    }
  }

  @override
  Future<List<BannerModel>> getApkBanners() async {
    try {
      final response = await dio.get('apk-banner');
      debugPrint("🔥 APK BANNER RESPONSE: ${response.data}");
      
      if (response.statusCode == 200 && response.data['status'] == true) {
        final bannerList = response.data['data'] as List;
        return bannerList
            .map((e) => BannerModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("❌ APK BANNER ERROR: $e");
      return [];
    }
  }

  @override
  Future<List<SliderModel>> getApkSliders() async {
    try {
      final response = await dio.get('apk-slider');
      debugPrint("🔥 APK SLIDER RESPONSE: ${response.data}");
      
      if (response.statusCode == 200 && response.data['status'] == true) {
        final sliderList = response.data['data'] as List;
        return sliderList
            .map((e) => SliderModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("❌ APK SLIDER ERROR: $e");
      return [];
    }
  }
}
