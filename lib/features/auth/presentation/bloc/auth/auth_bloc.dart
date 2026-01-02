import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/core/utils/helpers.dart';
import 'package:grow_first/features/auth/domain/usecases/params/verify_otp_params.dart';
import 'package:grow_first/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:grow_first/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc(this.sendOtpUseCase, this.verifyOtpUseCase)
    : super(const AuthState()) {
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResetOtpSentEvent>((event, emit) {
      emit(state.copyWith(isOtpSent: false));
    });
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await sendOtpUseCase(event.phone);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (_) => emit(state.copyWith(isLoading: false, isOtpSent: true)),
    );
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await verifyOtpUseCase(
      VerifyOtpParams(phone: event.phone, otp: event.otp),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: Helpers.convertFailureToMessage(failure),
        ),
      ),
      (auth) => emit(
        state.copyWith(isLoading: false, user: auth.user, token: auth.token),
      ),
    );
  }
}
