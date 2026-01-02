import 'dart:async';

sealed class SessionEvent {}

class SessionLoggedOut extends SessionEvent {}

class SessionManager {
  final _controller = StreamController<SessionEvent>.broadcast();
  Stream<SessionEvent> get events => _controller.stream;
  void notifyUnauthorized() => _controller.add(SessionLoggedOut());
  void dispose() => _controller.close();
}
