import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/features/listing/domain/entities/listing_filter_params.dart';

class ListingFilterCubit extends Cubit<ListingFilterParams> {
  ListingFilterCubit([ListingFilterParams? initialParams])
      : super(initialParams ?? const ListingFilterParams());

  void updateCategories(List<int> categories) {
    emit(state.copyWith(selectedCategories: categories));
  }

  void toggleCategory(int categoryId) {
    final current = List<int>.from(state.selectedCategories);
    if (current.contains(categoryId)) {
      current.remove(categoryId);
    } else {
      current.add(categoryId);
    }
    emit(state.copyWith(selectedCategories: current));
  }

  void updateSubcategories(List<int> subcategories) {
    emit(state.copyWith(selectedSubcategories: subcategories));
  }

  void toggleSubcategory(int subcategoryId) {
    final current = List<int>.from(state.selectedSubcategories);
    if (current.contains(subcategoryId)) {
      current.remove(subcategoryId);
    } else {
      current.add(subcategoryId);
    }
    emit(state.copyWith(selectedSubcategories: current));
  }

  void updateKeyword(String? keyword) {
    if (keyword == null || keyword.isEmpty) {
      emit(state.copyWith(clearKeyword: true));
    } else {
      emit(state.copyWith(keyword: keyword));
    }
  }

  void updateLocation(String? location) {
    if (location == null || location.isEmpty) {
      emit(state.copyWith(clearLocation: true));
    } else {
      emit(state.copyWith(location: location));
    }
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    emit(state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
    ));
  }

  void updateSortBy(String? sortBy) {
    if (sortBy == null) {
      emit(state.copyWith(clearSortBy: true));
    } else {
      emit(state.copyWith(sortBy: sortBy));
    }
  }

  void toggleRating(int rating) {
    final current = List<int>.from(state.selectedRatings);
    if (current.contains(rating)) {
      current.remove(rating);
    } else {
      current.add(rating);
    }
    emit(state.copyWith(selectedRatings: current));
  }

  void updateRatings(List<int> ratings) {
    emit(state.copyWith(selectedRatings: ratings));
  }

  void clearAllFilters() {
    emit(const ListingFilterParams());
  }

  void setFilters(ListingFilterParams params) {
    emit(params);
  }
}
