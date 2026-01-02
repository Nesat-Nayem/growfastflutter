import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/categories/domain/entities/category.dart';
import 'package:grow_first/features/categories/domain/entities/subcategory.dart';
import 'package:grow_first/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:grow_first/features/categories/domain/usecases/get_subcategories_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetSubcategoriesUseCase getSubcategoriesUseCase;

  CategoryBloc(this.getCategoriesUseCase, this.getSubcategoriesUseCase)
    : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadSubcategories>(_onLoadSubcategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getCategoriesUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (categories) =>
          emit(state.copyWith(isLoading: false, categories: categories)),
    );
  }

  Future<void> _onLoadSubcategories(
    LoadSubcategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubcategoriesLoading: true,
        error: null,
        subcategories: [],
      ),
    );  

    final result = await getSubcategoriesUseCase(event.categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubcategoriesLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (subcategories) {
        emit(
          state.copyWith(
            isSubcategoriesLoading: false,
            subcategories: subcategories,
          ),
        );
      },
    );
  }
}
