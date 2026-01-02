import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart' as dd;
import 'package:grow_first/core/monitoring/telementry.dart';

class DatadogTelemetry implements TelemetryClient {
  final String clientToken;
  final String appId;
  dd.DatadogSdk? _dd;
  dd.DatadogLogger? _logger;

  DatadogTelemetry(this.clientToken, this.appId);

  @override
  Future<void> init({required String appVersion, required String env}) async {
    // Since runApp seems to return void, just call it without assignment
    await dd.DatadogSdk.runApp(
      dd.DatadogConfiguration(
        env: env,
        clientToken: clientToken,
        site: dd.DatadogSite.eu1,
        nativeCrashReportEnabled: true,
        loggingConfiguration: dd.DatadogLoggingConfiguration(),
        rumConfiguration: dd.DatadogRumConfiguration(
          applicationId: appId,
          sessionSamplingRate: 20.0,
        ),
      ),
      dd.TrackingConsent.granted,
      () {},
    );

    // Initialize _dd after the app is run, if needed.
    _dd = dd.DatadogSdk.instance;
    _logger = _dd?.logs?.createLogger(
      dd.DatadogLoggerConfiguration(remoteLogThreshold: dd.LogLevel.warning),
    );
  }

  @override
  void setUser(String id, {String? email}) {
    _dd?.setUserInfo(id: id, email: email);
  }

  @override
  void clearUser() => _dd?.clearAllData();

  @override
  void log({
    LogLevel level = LogLevel.warning,
    required String message,
    Map<String, dynamic>? data,
  }) {
    _logger?.log(mapLogLevel(level), message);
  }

  @override
  void recordError(Object error, StackTrace st) {
    _dd?.rum?.addError(
      error.toString(),
      dd.RumErrorSource.source,
      stackTrace: st,
    );
  }

  dd.LogLevel mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return dd.LogLevel.debug;
      case LogLevel.info:
        return dd.LogLevel.info;
      case LogLevel.warning:
        return dd.LogLevel.warning;
      case LogLevel.error:
        return dd.LogLevel.error;
      case LogLevel.critical:
        return dd.LogLevel.critical;
    }
  }
}
