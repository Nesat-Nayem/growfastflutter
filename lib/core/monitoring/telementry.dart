enum LogLevel {
  debug, // For detailed logs, typically for development
  info, // For informational logs, useful for runtime monitoring
  warning, // For warnings, could indicate potential issues
  error, // For errors or exceptions
  critical, // For critical issues that require immediate attention
}

abstract class TelemetryClient {
  Future<void> init({required String appVersion, required String env});

  void setUser(String id, {String? email});
  void clearUser();

  void log(
      {LogLevel level = LogLevel.warning,
      required String message,
      Map<String, dynamic> data});
  void recordError(Object error, StackTrace st);
}
