part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class LoadSubcategories extends CategoryEvent {
  final int categoryId;

  const LoadSubcategories(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
