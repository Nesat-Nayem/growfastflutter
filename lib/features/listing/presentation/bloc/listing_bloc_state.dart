part of 'listing_bloc.dart';

class ListingState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSelectedListingLoading;
  final List<Listing> listings;
  final Listing? selectedListing;
  final int totalNumberOfListings;
  final int currentPage;
  final int lastPage;
  final bool hasMorePages;
  final String? error;
  final List<String> banners;

  const ListingState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSelectedListingLoading = false,
    this.listings = const [],
    this.selectedListing,
    this.totalNumberOfListings = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMorePages = false,
    this.error,
    this.banners = const [],
  });

  ListingState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSelectedListingLoading,
    List<Listing>? listings,
    Listing? selectedListing,
    int? totalNumberOfListings,
    int? currentPage,
    int? lastPage,
    bool? hasMorePages,
    String? error,
    bool clearError = false,
    List<String>? banners,
  }) {
    return ListingState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSelectedListingLoading:
          isSelectedListingLoading ?? this.isSelectedListingLoading,
      listings: listings ?? this.listings,
      selectedListing: selectedListing ?? this.selectedListing,
      totalNumberOfListings:
          totalNumberOfListings ?? this.totalNumberOfListings,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      error: clearError ? null : (error ?? this.error),
      banners: banners ?? this.banners,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        isSelectedListingLoading,
        listings,
        selectedListing,
        totalNumberOfListings,
        currentPage,
        lastPage,
        hasMorePages,
        error,
        banners,
      ];
}
