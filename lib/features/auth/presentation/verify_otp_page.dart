import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/otp_fields.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.processInitaiedOn});

  final String processInitaiedOn;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late Timer _timer;
  Duration _remaining = const Duration(minutes: 2); // <<< DEFAULT TIMER

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds == 0) {
        timer.cancel();
        setState(() {}); // to update UI
      } else {
        setState(() {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        });
      }
    });
  }

  void _restartTimer() {
    setState(() {
      _remaining = const Duration(minutes: 2);
    });
    _startTimer();
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = _remaining.inSeconds == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          "Verify OTP",
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: horizontalPadding16 + verticalPadding12,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalMargin32,
                      Text(
                        "Verification code",
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      verticalMargin16,
                      Text(
                        "Please enter the verification code we sent to your mobile number.",
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                      verticalMargin48,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.processInitaiedOn,
                            style: context.bodySmall,
                          ),
                          horizontalMargin16,
                          const Icon(Icons.edit_note_outlined),
                        ],
                      ),
                      verticalMargin48,
                      BlocListener<AuthBloc, AuthState>(
                        bloc: sl<AuthBloc>(),
                        listener: (context, state) {
                          if (state.token?.isNotEmpty ?? false) {
                            context.pop();
                            context.pop();
                            context.pushNamed(
                              AppRouterNames.customerSelectBookingLocation,
                              pathParameters: {
                                "listingId":
                                    sl<ListingBloc>().state.selectedListing?.id
                                        .toString() ??
                                    "",
                              },
                            );
                          }
                        },
                        child: AnimatedOtpFields(
                          length: 6,
                          onCompleted: (value) {
                            sl<AuthBloc>().add(
                              VerifyOtpEvent(widget.processInitaiedOn, value),
                            );
                          },
                        ),
                      ),
                      verticalMargin32,
                      Center(
                        child: GestureDetector(
                          onTap: canResend ? _restartTimer : null,
                          child: Text(
                            canResend
                                ? "Resend OTP"
                                : "Resend in ${_formatTime(_remaining)}",
                            style: context.labelLarge.copyWith(
                              color: canResend ? Colors.blue : shipGreyColor1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GradientButton(
                text: "Verify OTP",
                onTap: () {
                  context.pushNamed(AppRouterNames.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
