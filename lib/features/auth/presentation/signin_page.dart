import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/core/utils/snackbar.dart';
import 'package:grow_first/core/utils/validators.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/mobile_number_filed_widget.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  TextEditingController customerMobileNumberController =
      TextEditingController();
  TextEditingController vendorEmailController = TextEditingController();
  TextEditingController vendorPasswordController = TextEditingController();

  bool rememberMe = false;
  bool isOtpBtnEnabled = false;
  bool isVendorSignInBtnEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });

    vendorEmailController.addListener(_validateVendorForm);
    vendorPasswordController.addListener(_validateVendorForm);
  }

  void _validateVendorForm() {
    final emailError = Validators.validateEmail(vendorEmailController.text);
    final passwordError = Validators.validatePassword(
      vendorPasswordController.text,
    );

    setState(() {
      isVendorSignInBtnEnabled = emailError == null && passwordError == null;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    customerMobileNumberController.dispose();
    vendorEmailController.dispose();
    vendorPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: horizontalPadding16 + verticalPadding12,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Text(
                  "Login",
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              verticalMargin32,
              Text(
                "Welcome",
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalMargin4,
              Text(
                "Enter your credentials to access your account",
                style: context.labelLarge.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),
              verticalMargin32,
              verticalMargin12,
              TabBar(
                key: const Key('user-types'),
                labelPadding: rightPadding24,
                tabAlignment: TabAlignment.start,
                indicatorPadding: emptyPadding,
                dividerColor: Colors.transparent,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                controller: _tabController,
                labelStyle: context.bodyLarge.copyWith(
                  letterSpacing: 1.4,
                  color: aquaBlueColor,
                ),
                onTap: (value) => _tabController.animateTo(value),
                indicatorColor: darkNavyBlueColor,
                dividerHeight: 0.8,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: [
                  Tab(text: "Customer"),
                  Tab(text: "Vendor"),
                ],
              ),
              verticalMargin48,
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Mobile Number",
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
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
                          GradientButton(
                            text: "Get OTP",
                            onTap:
                                isOtpBtnEnabled ||
                                    customerMobileNumberController.text
                                        .trim()
                                        .isEmpty
                                ? () {
                                    // if (customerMobileNumberController.text
                                    //     .trim()
                                    //     .isEmpty) {
                                    // AppSnackBar.show(
                                    //   context,
                                    //   message:
                                    //       "Please enter a mobile number to continue your journey",
                                    // );
                                    context.pushNamed(
                                      AppRouterNames.verifyOtp,
                                      pathParameters: {
                                        "process_initiated_on":
                                            "+91 7509300556",
                                      },
                                    );
                                    return;
                                    // }
                                  }
                                : null,
                            padding: verticalPadding16,
                          ),
                          verticalMargin48,
                          Row(
                            children: [
                              Expanded(child: Divider(color: lightGreyColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text("OR"),
                              ),
                              Expanded(
                                child: Divider(
                                  color: lightGreyColor,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          verticalMargin48,
                          Center(
                            child: Text.rich(
                              TextSpan(
                                style: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                ),
                                children: [
                                  TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register",
                                    style: context.labelLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: aquaBlueColor,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Email Address",
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          verticalMargin12,
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: lightGreyColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: verticalPadding12 + horizontalPadding12,
                            child: TextFormField(
                              controller: vendorEmailController,
                              onTapOutside: (event) {
                                return FocusManager.instance.primaryFocus
                                    ?.unfocus();
                              },
                              keyboardType: TextInputType.phone,
                              style: context.labelLarge.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: "your@email.com",
                                hintStyle: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: lightGreyColor,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (value) {},
                              validator: Validators.validatePassword,
                            ),
                          ),
                          verticalMargin16,
                          Text(
                            "Password",
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          verticalMargin12,
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: lightGreyColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: verticalPadding12 + horizontalPadding12,
                            child: TextFormField(
                              controller: vendorPasswordController,
                              onTapOutside: (event) {
                                return FocusManager.instance.primaryFocus
                                    ?.unfocus();
                              },
                              keyboardType: TextInputType.phone,
                              style: context.labelLarge.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: "your-password",
                                hintStyle: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: lightGreyColor,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (value) {},
                              validator: Validators.validatePassword,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CheckboxTheme(
                                    data: CheckboxThemeData(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(5),
                                      ),
                                    ),
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = !rememberMe;
                                        });
                                      },
                                    ),
                                  ),
                                  horizontalMargin4,
                                  Text(
                                    "Remeber Me",
                                    style: context.labelLarge.copyWith(
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Forgot Password?",
                                style: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  decoration: TextDecoration.underline,
                                  height: 3.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _tabController.index == 1
          ? SafeArea(
              bottom: true,
              child: Padding(
                padding: verticalPadding16 + horizontalPadding16,
                child: Column(
                  mainAxisAlignment: .end,
                  mainAxisSize: .min,
                  children: [
                    GradientButton(
                      text: "Sign In",
                      onTap:
                          isVendorSignInBtnEnabled ||
                              (vendorEmailController.text.trim().isEmpty &&
                                  vendorPasswordController.text.trim().isEmpty)
                          ? () {
                              if ((vendorEmailController.text.trim().isEmpty &&
                                  vendorPasswordController.text
                                      .trim()
                                      .isEmpty)) {
                                AppSnackBar.show(
                                  context,
                                  message:
                                      "Please enter email & password to continue your journey",
                                );
                                return;
                              }
                            }
                          : null,
                      padding: verticalPadding16,
                    ),
                  ],
                ),
              ),
            )
          : null,
      resizeToAvoidBottomInset: false,
    );
  }
}
