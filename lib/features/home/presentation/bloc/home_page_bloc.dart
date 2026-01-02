import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';

import '../../domain/usecases/get_home_banner_images_usecase.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetHomeBannerImagesUseCase getBannerImagesUseCase;

  HomePageBloc(this.getBannerImagesUseCase) : super(const HomePageInitial()) {
    on<LoadHomePage>(_onLoadHomePage);
  }

  Future<void> _onLoadHomePage(
    LoadHomePage event,
    Emitter<HomePageState> emit,
  ) async {
    emit(const HomePageLoading());

    try {
      final result = await getBannerImagesUseCase(NoParams());

      result.fold(
        (failure) =>
            emit(HomePageError(Helpers.convertFailureToMessage(failure))),
        (bannerImages) => emit(HomePageLoaded(bannerImages: bannerImages)),
      );
    } catch (e) {
      emit(HomePageError(e.toString()));
    }
  }
}
