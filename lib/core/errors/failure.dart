import 'package:equatable/equatable.dart';

abstract class Failure {
  const Failure([List properties = const <dynamic>[]]) : super();
}

/// Abstraction for catching custom exceptions and returning failure objects to UI.

/// Handles [ServerException] and return Failure object to UI elements.
class ServerFailure extends Failure with EquatableMixin {
  final String message;

  ServerFailure({this.message = 'Some unexpected server failure occured!'})
    : super([message]);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure() : super();
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super();
}
