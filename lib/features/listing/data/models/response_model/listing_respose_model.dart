import 'package:grow_first/features/listing/domain/entities/listing.dart';

class ListingResponseModel {
  final List<Listing> listings;
  final int total;

  const ListingResponseModel({required this.listings, required this.total});
}
