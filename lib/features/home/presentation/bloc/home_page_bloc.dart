import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/usecase.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/home/data/model/home_service_model.dart';
import 'package:grow_first/features/home/data/model/recent_search_model.dart';

import '../../domain/usecases/get_home_banner_images_usecase.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetHomePageDataUseCase getHomePageDataUseCase;

  HomePageBloc(this.getHomePageDataUseCase) : super(const HomePageInitial()) {
    on<LoadHomePage>(_onLoadHomePage);
  }

  Future<void> _onLoadHomePage(
    LoadHomePage event,
    Emitter<HomePageState> emit,
  ) async {
    emit(const HomePageLoading());

    final result = await getHomePageDataUseCase(NoParams());

    result.fold(
      (failure) =>
          emit(HomePageError(Helpers.convertFailureToMessage(failure))),
      (data) {
        debugPrint(
          "🧠 BLOC RECEIVED recentSearches = ${data.recentSearches.length}",
        );
        emit(
          HomePageLoaded(
            bannerImages: data.bannerImages,
            services: data.services,
            recentSearches: data.recentSearches,
          ),
        );
      },
    );
  }
}
