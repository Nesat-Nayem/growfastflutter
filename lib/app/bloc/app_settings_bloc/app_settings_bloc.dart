import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_settings_bloc_event.dart';
part 'app_settings_bloc_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(const AppSettingsState()) {
    on<LoadSettings>((e, emit) {
      /* load from KVStore */ emit(state);
    });
    on<ChangeLocale>((e, emit) =>
        emit(AppSettingsState(themeMode: state.themeMode, locale: e.locale)));
    on<ChangeThemeMode>((e, emit) =>
        emit(AppSettingsState(themeMode: e.mode, locale: state.locale)));
  }
}
