import 'package:dartz/dartz.dart';
import 'package:grow_first/core/errors/failure.dart';
import 'package:grow_first/features/home/data/model/home_page_response.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomePageResponse>> getHomePageData();
  Future<Either<Failure, List<ServiceSectionModel>>> getServicesByType(String serviceType);
}