import 'package:grow_first/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> sendOtp(String phone);

  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  });
}
