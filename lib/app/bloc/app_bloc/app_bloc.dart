import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/storage/secure_storage.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ISecureStore secureStore;

  AppBloc({required this.secureStore}) : super(AppInitial()) {
    on<AppStarted>(_onStarted);
    on<AppLoggedIn>((e, emit) => emit(AppAuthenticated()));
    on<AppLoggedOut>(_onLoggedOut);
  }

  Future<void> _onStarted(AppStarted e, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 1));
    bool login = await secureStore.read("isLoggedIn") == "true";
    final isLoggedIn = login;
    if (isLoggedIn) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  Future<void> _onLoggedOut(AppLoggedOut e, Emitter emit) async {
    // await logoutUser();
    emit(AppUnauthenticated());
  }
}
