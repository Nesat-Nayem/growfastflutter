part of 'app_settings_bloc.dart';  // This is the 'part of' directive to link this file to the main BLoC file

sealed class AppSettingsEvent {}

class LoadSettings extends AppSettingsEvent {}

class ChangeLocale extends AppSettingsEvent {
  final Locale locale;
  ChangeLocale(this.locale);
}

class ChangeThemeMode extends AppSettingsEvent {
  final ThemeMode mode;
  ChangeThemeMode(this.mode);
}
