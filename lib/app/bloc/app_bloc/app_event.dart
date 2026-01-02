part of 'app_bloc.dart'; // This links this file to app_bloc.dart

sealed class AppEvent {}

class AppStarted extends AppEvent {}

class AppLoggedIn extends AppEvent {
  // final User user;
  AppLoggedIn(
      // this.user
      );
}

class AppLoggedOut extends AppEvent {}
