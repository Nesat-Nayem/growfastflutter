import 'package:grow_first/features/auth/data/models/auth_user_model.dart';
import 'package:grow_first/features/auth/domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  AuthResponseModel({required super.token, required super.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'],
      user: AuthUserModel.fromJson(json['user']),
    );
  }
}
