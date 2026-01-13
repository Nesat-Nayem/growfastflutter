

import 'package:grow_first/features/home/data/model/home_page_response.dart';

abstract class HomeRemoteDataSource {
  Future<HomePageResponse> getHomePageData();
}
