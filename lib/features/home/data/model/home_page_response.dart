import 'package:grow_first/features/home/data/model/recent_search_model.dart';

import 'home_service_model.dart';

class HomePageResponse {
  final List<String> bannerImages;
  final List<HomeServiceModel> services;
    final List<RecentSearchModel> recentSearches;

  HomePageResponse({
    required this.bannerImages,
    required this.services,
    required this.recentSearches
  });
}
