import 'package:equatable/equatable.dart';
import 'package:grow_first/features/auth/domain/entities/auth_user.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isOtpSent;
  final bool isTestOtp;
  final String? testOtp;
  final AuthUser? user;
  final String? token;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isOtpSent = false,
    this.isTestOtp = false,
    this.testOtp,
    this.user,
    this.token,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isOtpSent,
    bool? isTestOtp,
    String? testOtp,
    AuthUser? user,
    String? token,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isTestOtp: isTestOtp ?? this.isTestOtp,
      testOtp: testOtp ?? this.testOtp,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isOtpSent, isTestOtp, testOtp, user, token, error];
}
