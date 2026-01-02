part of 'listing_bloc.dart';

class ListingState extends Equatable {
  final bool isLoading;
  final bool isSelectedListingLoading;
  final List<Listing> listings;
  final Listing? selectedListing;
  final int totalNumberOfListings;
  final String? error;

  const ListingState({
    this.isLoading = false,
    this.isSelectedListingLoading = false,
    this.listings = const [],
    this.selectedListing,
    this.totalNumberOfListings = 0,
    this.error,
  });

  ListingState copyWith({
    bool? isLoading,
    bool? isSelectedListingLoading,
    List<Listing>? listings,
    Listing? selectedListing,
    int? totalNumberOfListings,
    String? error,
  }) {
    return ListingState(
      isLoading: isLoading ?? this.isLoading,
      isSelectedListingLoading:
          isSelectedListingLoading ?? this.isSelectedListingLoading,
      listings: listings ?? this.listings,
      selectedListing: selectedListing ?? this.selectedListing,
      totalNumberOfListings:
          totalNumberOfListings ?? this.totalNumberOfListings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    listings,
    selectedListing,
    isSelectedListingLoading,
    totalNumberOfListings,
    error,
  ];
}
