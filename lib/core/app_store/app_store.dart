import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/features/auth/data/models/auth_response_model.dart';
import 'package:grow_first/features/auth/data/models/auth_user_model.dart';
import 'package:grow_first/features/auth/domain/entities/auth_user.dart';

class AppStore {
  final ISecureStore secureStore;

  AppStore(this.secureStore);

  static const _kUser = 'user';
  static const _kToken = 'token';

  AuthUserModel? _userModel;
  String? _token;

  /// Expose domain entity only
  AuthUser? get user => _userModel;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  /// Call after successful OTP verification
  Future<void> saveAuth(AuthResponseModel auth) async {
    _token = auth.token;

    // safe because AuthResponseModel always provides AuthUserModel
    _userModel = auth.user as AuthUserModel;

    await secureStore.write(_kToken, _token!);
    await secureStore.write(_kUser, jsonEncode(_userModel!.toJson()));
    await secureStore.write("isLoggedIn", "true");
    debugPrint('Auth saved: ${await secureStore.read(_kUser)}');
  }

  /// Update user data after profile update
  Future<void> updateUser(Map<String, dynamic> userData) async {
    if (_userModel == null) return;
    
    // Merge existing user data with updated data
    final currentJson = _userModel!.toJson();
    currentJson.addAll(userData);
    
    _userModel = AuthUserModel.fromJson(currentJson);
    await secureStore.write(_kUser, jsonEncode(_userModel!.toJson()));
    debugPrint('User updated: ${await secureStore.read(_kUser)}');
  }

  /// Call on app start / splash
  Future<void> load() async {
    final token = await secureStore.read(_kToken);
    final userJson = await secureStore.read(_kUser);

    if (token != null && userJson != null) {
      _token = token;
      _userModel = AuthUserModel.fromJson(jsonDecode(userJson));
    }
  }

  /// Logout
  Future<void> clear() async {
    _token = null;
    _userModel = null;
    await secureStore.clear();
  }
}
