import 'package:dio/dio.dart';
import '../../sessions/session_manager.dart';
import '../../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final ISecureStore secure;
  final SessionManager sessionManager;

  const AuthInterceptor(this.secure, this.sessionManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secure.read(SecureStore.kAccessToken);
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    if (code == 401 || code == 403) {
      sessionManager.notifyUnauthorized();
    }
    super.onError(err, handler);
  }
}
