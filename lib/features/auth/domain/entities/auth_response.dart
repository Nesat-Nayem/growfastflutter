import 'package:grow_first/features/auth/domain/entities/auth_user.dart';

class AuthResponse {
  final String token;
  final AuthUser user;

  const AuthResponse({
    required this.token,
    required this.user,
  });
}
