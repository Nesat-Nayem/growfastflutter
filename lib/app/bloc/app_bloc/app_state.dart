part of 'app_bloc.dart'; // This links this file to app_bloc.dart

sealed class AppState {}

class AppInitial extends AppState {}

class AppAuthenticated extends AppState {
  // final User user;
  AppAuthenticated(
      // this.user
      );
}

class AppUnauthenticated extends AppState {}
