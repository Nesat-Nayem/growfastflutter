import 'package:grow_first/features/listing/data/models/listing_model.dart';
import 'package:grow_first/features/listing/data/models/response_model/listing_respose_model.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';

abstract class ListingRemoteDataSource {
  Future<ListingResponseModel> getListingsBySubcategory(
    GetListingsParams params,
  );

  Future<ListingModel> getListingDetailById(String id);

  Future<List<String>> getAboutUsBanners();
}
