part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object?> get props => [];
}

class HomePageInitial extends HomePageState {
  const HomePageInitial();
}

class HomePageLoading extends HomePageState {
  const HomePageLoading();
}

class HomePageError extends HomePageState {
  final String message;

  const HomePageError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomePageLoaded extends HomePageState {
  final List<String> bannerImages;
  final List<HomeServiceModel> services;
  final List<RecentSearchModel> recentSearches;
  final List<BannerModel> apkBanners;
  final List<SliderModel> apkSliders;
  
  const HomePageLoaded({
    required this.bannerImages,
    required this.services,
    required this.recentSearches,
    required this.apkBanners,
    required this.apkSliders,
  });

  @override
  List<Object?> get props => [bannerImages, services, recentSearches, apkBanners, apkSliders]; //,recentSearches mention karshel re ba
}

