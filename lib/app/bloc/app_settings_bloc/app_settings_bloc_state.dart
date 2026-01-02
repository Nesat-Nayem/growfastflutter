part of 'app_settings_bloc.dart';  // Link this file to the main BLoC file

class AppSettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en', 'US'),
  });

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
