import 'package:grow_first/features/listing/domain/entities/listing.dart';

class ListingResponseModel {
  final List<Listing> listings;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final bool hasMorePages;

  const ListingResponseModel({
    required this.listings,
    required this.total,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 8,
    this.hasMorePages = false,
  });
}
