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

class HomePageLoaded extends HomePageState {
  final List<String> bannerImages;

  const HomePageLoaded({required this.bannerImages});

  @override
  List<Object?> get props => [bannerImages];
}

class HomePageError extends HomePageState {
  final String message;

  const HomePageError(this.message);

  @override
  List<Object?> get props => [message];
}
