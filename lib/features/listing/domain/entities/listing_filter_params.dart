import 'package:equatable/equatable.dart';

class ListingFilterParams extends Equatable {
  final List<int> selectedCategories;
  final List<int> selectedSubcategories;
  final String? keyword;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy; // 'low_to_high', 'high_to_low', 'newest', 'rating'
  final List<int> selectedRatings;

  const ListingFilterParams({
    this.selectedCategories = const [],
    this.selectedSubcategories = const [],
    this.keyword,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.selectedRatings = const [],
  });

  ListingFilterParams copyWith({
    List<int>? selectedCategories,
    List<int>? selectedSubcategories,
    String? keyword,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    List<int>? selectedRatings,
    bool clearKeyword = false,
    bool clearLocation = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearSortBy = false,
  }) {
    return ListingFilterParams(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubcategories: selectedSubcategories ?? this.selectedSubcategories,
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
      location: clearLocation ? null : (location ?? this.location),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
      selectedRatings: selectedRatings ?? this.selectedRatings,
    );
  }

  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      selectedSubcategories.isNotEmpty ||
      keyword != null ||
      location != null ||
      minPrice != null ||
      maxPrice != null ||
      sortBy != null ||
      selectedRatings.isNotEmpty;

  int get activeFilterCount {
    int count = 0;
    if (selectedCategories.isNotEmpty) count++;
    if (selectedSubcategories.isNotEmpty) count++;
    if (keyword != null && keyword!.isNotEmpty) count++;
    if (location != null && location!.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (sortBy != null) count++;
    if (selectedRatings.isNotEmpty) count++;
    return count;
  }

  ListingFilterParams clear() {
    return const ListingFilterParams();
  }

  @override
  List<Object?> get props => [
        selectedCategories,
        selectedSubcategories,
        keyword,
        location,
        minPrice,
        maxPrice,
        sortBy,
        selectedRatings,
      ];
}
