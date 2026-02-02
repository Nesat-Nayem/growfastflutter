import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  SendOtpEvent(this.phone);
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  VerifyOtpEvent(this.phone, this.otp);
}

class ResetOtpSentEvent extends AuthEvent {}

class GoogleLoginSuccessEvent extends AuthEvent {
  final String token;
  final Map<String, dynamic> user;
  
  GoogleLoginSuccessEvent({required this.token, required this.user});
  
  @override
  List<Object?> get props => [token, user];
}
