import 'package:grow_first/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/core/utils/snackbar.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/mobile_number_filed_widget.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class SigninPage extends StatefulWidget {
  final Map<String, dynamic>? redirectionData;
  const SigninPage({super.key, this.redirectionData});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController customerMobileNumberController = TextEditingController();
  bool isOtpBtnEnabled = false;

  @override
  void dispose() {
    customerMobileNumberController.dispose();
    super.dispose();
  }

  void _showTestOtpDialog(BuildContext context, String otp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Test OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your OTP for testing is:'),
            const SizedBox(height: 16),
            Text(
              otp,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: aquaBlueColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigate to OTP verification page
              context.pushNamed(
                AppRouterNames.verifyOtp,
                pathParameters: {
                  "process_initiated_on": customerMobileNumberController.text,
                },
                extra: widget.redirectionData,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background at top
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4DD0E1),
                  Color(0xFF26C6DA),
                  Color(0xFF00BCD4),
                ],
              ),
            ),
          ),
          // White content area
          SafeArea(
            child: Column(
              children: [
                // Top section with gradient background
                Container(
                  padding: horizontalPadding16 + verticalPadding32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () {
                          context.goNamed(AppRouterNames.home);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      verticalMargin16,
                      Text(
                        "Welcome To\nLogin",
                        style: context.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      verticalMargin12,
                      Text(
                        "Enter your credentials to access\nyour account",
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // White rounded container for content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: horizontalPadding16 + verticalPadding24,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalMargin24,
                            Text(
                              "Mobile Number",
                              style: context.labelLarge.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            verticalMargin12,
                            BlocBuilder<CountryCubit, CountryState>(
                              builder: (context, state) {
                                if (state is CountryLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (state is CountryError) {
                                  return Center(child: Text(state.message));
                                }

                                if (state is CountryLoaded) {
                                  return Center(
                                    child: MobileNumberField(
                                      controller: customerMobileNumberController,
                                      initialCountryCode: state.countries
                                          .where(
                                            (element) =>
                                                element.code ==
                                                PlatformDispatcher
                                                    .instance
                                                    .locale
                                                    .countryCode,
                                          )
                                          .first
                                          .code,
                                      initialFlagAsset: state.countries
                                          .where(
                                            (element) =>
                                                element.code ==
                                                PlatformDispatcher
                                                    .instance
                                                    .locale
                                                    .countryCode,
                                          )
                                          .first
                                          .flag,
                                      onValidChanged: (isValid) {
                                        setState(() => isOtpBtnEnabled = isValid);
                                      },
                                    ),
                                  );
                                }

                                return emptyBox;
                              },
                            ),
                            verticalMargin32,
                            BlocConsumer<AuthBloc, AuthState>(
                              bloc: sl<AuthBloc>(),
                              listener: (context, state) {
                                if (state.isOtpSent) {
                                  // Check if it's a test OTP - show popup
                                  if (state.isTestOtp && state.testOtp != null) {
                                    _showTestOtpDialog(context, state.testOtp!);
                                  } else {
                                    // Normal flow - navigate to OTP page
                                    context.pushNamed(
                                      AppRouterNames.verifyOtp,
                                      pathParameters: {
                                        "process_initiated_on":
                                            customerMobileNumberController.text,
                                      },
                                      extra: widget.redirectionData,
                                    );
                                  }
                                }
                                if (state.error != null) {
                                  AppSnackBar.show(context, message: state.error!);
                                }
                              },
                              builder: (context, state) {
                                return GradientButton(
                                  text: "Get OTP",
                                  showLoadingIndicator: state.isLoading,
                                  onTap: state.isLoading ||
                                          (!isOtpBtnEnabled &&
                                              customerMobileNumberController
                                                  .text
                                                  .trim()
                                                  .isNotEmpty)
                                      ? null
                                      : () {
                                          if (customerMobileNumberController.text
                                              .trim()
                                              .isEmpty) {
                                            AppSnackBar.show(
                                              context,
                                              message:
                                                  "Please enter a mobile number to continue your journey",
                                            );
                                            return;
                                          }
                                          sl<AuthBloc>().add(
                                            SendOtpEvent(
                                                customerMobileNumberController.text),
                                          );
                                        },
                                  padding: verticalPadding16,
                                );
                              },
                            ),
                            verticalMargin48,
                            // Row(
                            //   children: [
                            //     Expanded(child: Divider(color: lightGreyColor)),
                            //     const Padding(
                            //       padding: EdgeInsets.symmetric(horizontal: 12),
                            //       child: Text("OR"),
                            //     ),
                            //     Expanded(
                            //       child: Divider(
                            //         color: lightGreyColor,
                            //         thickness: 1,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // verticalMargin48,
                            // Center(
                            //   child: Text.rich(
                            //     TextSpan(
                            //       style: context.labelLarge.copyWith(
                            //         fontWeight: FontWeight.w400,
                            //         letterSpacing: 1,
                            //       ),
                            //       children: [
                            //         const TextSpan(text: "Don't have an account? "),
                            //         TextSpan(
                            //           text: "Register",
                            //           style: context.labelLarge.copyWith(
                            //             fontWeight: FontWeight.w600,
                            //             color: aquaBlueColor,
                            //             letterSpacing: 1,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
