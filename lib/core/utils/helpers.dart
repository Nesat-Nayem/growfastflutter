import 'package:grow_first/core/errors/failure.dart';

class Helpers {
  static String convertFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unknown error occurred";
  }
}
