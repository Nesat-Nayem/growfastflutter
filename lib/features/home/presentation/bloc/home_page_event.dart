part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomePage extends HomePageEvent {
  const LoadHomePage();
}

class RefreshHomePage extends HomePageEvent {
  const RefreshHomePage();
}
