import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import '../sessions/session_manager.dart';
import '../storage/secure_storage.dart';

// Conditional imports for platform-specific code
import 'dio_client_stub.dart'
    if (dart.library.io) 'dio_client_io.dart'
    if (dart.library.html) 'dio_client_web.dart' as platform;

class DioClient {
  late final Dio dio;

  DioClient(AppConfig cfg, ISecureStore secure, SessionManager sm) {
    dio = Dio(
      BaseOptions(
        baseUrl: cfg.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    
    // Configure platform-specific settings (e.g., self-signed certs on mobile)
    platform.configureDio(dio);
    
    // Add logging in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
    
    dio.interceptors.add(AuthInterceptor(secure, sm));
  }
}
