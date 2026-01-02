import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import '../sessions/session_manager.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient(AppConfig cfg, ISecureStore secure, SessionManager sm) {
    dio = Dio(
      BaseOptions(
        baseUrl: cfg.baseUrl,
        connectTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.addAll([AuthInterceptor(secure, sm)]);
  }
}
