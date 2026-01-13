import 'package:grow_first/features/home/data/model/home_page_response.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomePageResponse> getHomePageData();
  Future<List<ServiceSectionModel>> getServicesByType(String serviceType);
}
