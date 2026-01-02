import 'package:grow_first/core/monitoring/telementry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryTelemetry implements TelemetryClient {
  final String dsn;
  SentryTelemetry(this.dsn);

  @override
  Future<void> init({required String appVersion, required String env}) async {
    await SentryFlutter.init((o) {
      o.dsn = dsn;
      o.environment = env;
      o.release = appVersion;
      o.tracesSampleRate = 0.2;
      o.profilesSampleRate = 0.1;
    });
  }

  @override
  void setUser(String id, {String? email}) {
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: id, email: email));
    });
  }

  @override
  void clearUser() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  @override
  void log(
      {LogLevel level = LogLevel.warning,
      required String message,
      Map<String, dynamic>? data}) {
    final logger = Sentry.logger;
    data?["message"] = message;

    final stringifyData = data.toString();

    switch (level) {
      case LogLevel.info:
        logger.info(stringifyData);
        break;
      case LogLevel.debug:
        logger.debug(stringifyData);
        break;
      case LogLevel.warning:
        logger.warn(stringifyData);
        break;
      case LogLevel.error:
        logger.error(stringifyData);
        break;
      default:
    }
  }

  @override
  void recordError(Object error, StackTrace st) {
    Sentry.captureException(error, stackTrace: st);
  }
}
