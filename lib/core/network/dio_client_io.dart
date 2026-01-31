import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Configure Dio for mobile/desktop platforms (dart:io)
void configureDio(Dio dio) {
  // Allow self-signed certificates in debug mode (for testing)
  if (kDebugMode) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }
}
