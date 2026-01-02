part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final bool isLoading;
  final bool isSubcategoriesLoading;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final String? error;

  const CategoryState({
    this.isLoading = false,
    this.isSubcategoriesLoading = false,
    this.categories = const [],
    this.subcategories = const [],
    this.error,
  });

  CategoryState copyWith({
    bool? isLoading,
    bool? isSubcategoriesLoading,
    List<Category>? categories,
    List<Subcategory>? subcategories,
    String? error,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      isSubcategoriesLoading:
          isSubcategoriesLoading ?? this.isSubcategoriesLoading,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    categories,
    subcategories,
    error,
    isSubcategoriesLoading,
  ];
}
