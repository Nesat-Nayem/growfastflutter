import 'package:flutter/services.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grow_first/core/network/dio_client.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/features/auth/data/models/auth_user_model.dart';
import 'package:grow_first/features/auth/data/models/auth_response_model.dart';

class SigninPage extends StatefulWidget {
  final Map<String, dynamic>? redirectionData;
  const SigninPage({super.key, this.redirectionData});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController customerMobileNumberController =
      TextEditingController();
  bool isOtpBtnEnabled = false;
  bool isGoogleSignInLoading = false;
  bool _isCountryInitialized = false;

  String? _selectedCountryCode;
  Widget _buildFlag(String flag) {
    // If flag looks like an asset path
    if (flag.contains('/') || flag.contains('.png')) {
      return Image.asset(flag, width: 24, height: 16, fit: BoxFit.cover);
    }

    // Otherwise treat it as emoji
    return Text(flag, style: const TextStyle(fontSize: 15));
  }

  // Web client ID (client_type: 3) from google-services.json — required for
  // Android to obtain an idToken. On iOS the plugin reads the CLIENT_ID from
  // GoogleService-Info.plist automatically.
  static const _webClientId =
      '1088338713221-ru9o516qn1fjudr4mro7nura0ms9f9vf.apps.googleusercontent.com';

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // On iOS the native SDK uses the CLIENT_ID from GoogleService-Info.plist,
    // so we only need to supply serverClientId on Android.
    serverClientId: _webClientId,
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    customerMobileNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => isGoogleSignInLoading = true);

    try {
      // Sign out first to ensure account picker shows
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        if (mounted) setState(() => isGoogleSignInLoading = false);
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Send token to backend
      final dioClient = sl<DioClient>();
      final response = await dioClient.dio.post(
        'customer/google-login',
        data: {'id_token': idToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final userData = response.data['user'] as Map<String, dynamic>;

        final userModel = AuthUserModel.fromJson({
          'id': userData['id'],
          'ref_code': userData['ref_code'] ?? '',
          'ref_by': userData['ref_by'],
          'name': userData['name'] ?? '',
          'user_name': userData['user_name'],
          'gender': userData['gender'],
          'date_of_birth': userData['date_of_birth'],
          'country': userData['country'],
          'state': userData['state'],
          'city': userData['city'],
          'post_code': userData['post_code'],
          'email': userData['email'] ?? '',
          'phone': userData['phone'] ?? '',
          'address': userData['address'],
          'sub_locality': userData['sub_locality'],
          'image': userData['image'],
          'balance': userData['balance'] ?? 0,
          'company_name': userData['company_name'],
          'company_address': userData['company_address'],
          'gstin': userData['gstin'],
          'adhar': userData['adhar'],
          'pan': userData['pan'],
          'domain': userData['domain'],
          'codeid': userData['codeid'],
          'team_type': userData['team_type'],
          'job_title': userData['job_title'],
          'customer_type_id': userData['customer_type_id'],
          'is_block': userData['is_block'] ?? 'N',
          'role': userData['role'] ?? 'user',
          'status': userData['status'] ?? 0,
          'otp_created_at': userData['otp_created_at'] ?? '',
          'step': userData['step'] ?? 0,
          'otp': userData['otp'] ?? '',
          'created_at':
              userData['created_at'] ?? DateTime.now().toIso8601String(),
          'updated_at':
              userData['updated_at'] ?? DateTime.now().toIso8601String(),
          'description': userData['description'],
          'facebook_url': userData['facebook_url'],
          'instagram_url': userData['instagram_url'],
          'twitter_url': userData['twitter_url'],
          'whatsapp_number': userData['whatsapp_number'],
          'youtube_url': userData['youtube_url'],
          'linkedin_url': userData['linkedin_url'],
          'service_id': userData['service_id'],
        });

        // Store auth
        final appStore = sl<AppStore>();
        await appStore.saveAuth(
          AuthResponseModel(token: token, user: userModel),
        );

        // Notify bloc
        sl<AuthBloc>().add(
          GoogleLoginSuccessEvent(token: token, user: userData),
        );

        if (mounted) {
          context.goNamed(AppRouterNames.home);
        }
      } else {
        throw Exception(
          response.data['message'] ?? 'Login failed',
        );
      }
    } on PlatformException catch (e) {
      // Google Sign-In specific errors (e.g. sign_in_failed, network_error)
      debugPrint('Google Sign-In PlatformException: ${e.code} - ${e.message}');
      if (mounted) {
        String message;
        switch (e.code) {
          case 'sign_in_failed':
            message =
                'Google sign-in failed. Please check your Google Play Services and try again.';
            break;
          case 'network_error':
            message = 'Network error. Please check your connection.';
            break;
          case 'sign_in_canceled':
            // User cancelled — no need to show error
            return;
          default:
            message = 'Google sign-in error: ${e.code}';
        }
        AppSnackBar.show(context, message: message);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Authentication failed: ${e.message ?? e.code}',
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Google sign-in failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isGoogleSignInLoading = false);
      }
    }
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0), // AppBar spacing fix
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => context.goNamed(AppRouterNames.home),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 247, 244, 244),
                  width: 0.7,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 248, 246, 246),
                  size: 14,
                ),
              ),
            ),
          ),
        ),
        // leading: IconButton(
        //   onPressed: () {
        //     context.goNamed(AppRouterNames.home);
        //   },
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        // ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10326B), Color(0xFF10326B), Color(0xFF30D3D9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [-1.4, -0.2, 1.0],
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Gradient background at top
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF10326B),
                  Color(0xFF10326B),
                  Color(0xFF30D3D9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [-1.4, -0.2, 1.0],
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
                      // GestureDetector(
                      //   onTap: () {
                      //     context.goNamed(AppRouterNames.home);
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.all(8),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white.withValues(alpha: 0.2),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: const Icon(
                      //       Icons.arrow_back_ios_new,
                      //       color: Colors.white,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
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
                                  if (!_isCountryInitialized &&
                                      state.countries.isNotEmpty) {
                                    final india = state.countries.firstWhere(
                                      (c) => c.code == "IN", // 🇮🇳 FORCE INDIA
                                      orElse: () {
                                        final localeCode = PlatformDispatcher
                                            .instance
                                            .locale
                                            .countryCode;

                                        return state.countries.firstWhere(
                                          (c) => c.code == localeCode,
                                          orElse: () => state.countries.first,
                                        );
                                      },
                                    );

                                    _selectedCountryCode = india.code;
                                    _isCountryInitialized = true;
                                  }

                                  // if (!_isCountryInitialized) {
                                  //   _selectedCountryCode = state.countries
                                  //       .firstWhere(
                                  //         (c) =>
                                  //             c.code ==
                                  //             PlatformDispatcher
                                  //                 .instance
                                  //                 .locale
                                  //                 .countryCode,
                                  //         orElse: () => state.countries.first,
                                  //       )
                                  //       .code;

                                  //   _isCountryInitialized = true;
                                  // }

                                  final selectedCountry = state.countries
                                      .firstWhere(
                                        (c) => c.code == _selectedCountryCode,
                                      );
                                  int _maxLocalDigits(String dialCode) {
                                    const int maxTotalDigits = 13;
                                    return maxTotalDigits - dialCode.length;
                                  }

                                  final maxDigits = _maxLocalDigits(
                                    selectedCountry.dialCode,
                                  ).clamp(6, 10);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 🌍 COUNTRY DROPDOWN
                                      Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                  ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedCountryCode,
                                                  items: state.countries.map((
                                                    country,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: country.code,
                                                      child: Row(
                                                        children: [
                                                          _buildFlag(
                                                            country.flag,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "+${country.dialCode}",
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedCountryCode =
                                                          value;
                                                      isOtpBtnEnabled = false;
                                                      customerMobileNumberController
                                                          .clear();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),

                                            // Divider
                                            Container(
                                              height: 30,
                                              width: 1,
                                              color: Colors.grey.shade300,
                                            ),

                                            // 📱 MOBILE NUMBER INPUT (NO FLAG / NO CODE)
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    customerMobileNumberController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                style: TextStyle(fontSize: 12),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                    maxDigits,
                                                  ),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                      hintText:
                                                          "Enter Mobile Number",
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 9,
                                                          ),
                                                    ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    final totalLength =
                                                        selectedCountry
                                                            .dialCode
                                                            .length +
                                                        value.length;

                                                    isOtpBtnEnabled =
                                                        value.isNotEmpty &&
                                                        totalLength < 13;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      verticalMargin12,
                                    ],
                                  );
                                }

                                return emptyBox;
                              },
                            ),

                            // BlocBuilder<CountryCubit, CountryState>(
                            //   builder: (context, state) {
                            //     if (state is CountryLoading) {
                            //       return const Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }

                            //     if (state is CountryError) {
                            //       return Center(child: Text(state.message));
                            //     }

                            //     if (state is CountryLoaded) {
                            //       return Center(
                            //         child: MobileNumberField(
                            //           controller:
                            //               customerMobileNumberController,
                            //           initialCountryCode: state.countries
                            //               .where(
                            //                 (element) =>
                            //                     element.code ==
                            //                     PlatformDispatcher
                            //                         .instance
                            //                         .locale
                            //                         .countryCode,
                            //               )
                            //               .first
                            //               .code,
                            //           initialFlagAsset: state.countries
                            //               .where(
                            //                 (element) =>
                            //                     element.code ==
                            //                     PlatformDispatcher
                            //                         .instance
                            //                         .locale
                            //                         .countryCode,
                            //               )
                            //               .first
                            //               .flag,
                            //           onValidChanged: (isValid) {
                            //             setState(
                            //               () => isOtpBtnEnabled = isValid,
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     }

                            //     return emptyBox;
                            //   },
                            // ),
                            verticalMargin32,
                            BlocConsumer<AuthBloc, AuthState>(
                              bloc: sl<AuthBloc>(),
                              listener: (context, state) {
                                if (state.isOtpSent) {
                                  // Check if it's a test OTP - show popup
                                  if (state.isTestOtp &&
                                      state.testOtp != null) {
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
                                  AppSnackBar.show(
                                    context,
                                    message: state.error!,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return GradientButtonThird(
                                  text: "Get OTP",
                                  fontSize: 14,
                                  showLoadingIndicator: state.isLoading,
                                  onTap:
                                      state.isLoading ||
                                          (!isOtpBtnEnabled &&
                                              customerMobileNumberController
                                                  .text
                                                  .trim()
                                                  .isNotEmpty)
                                      ? null
                                      : () {
                                          if (customerMobileNumberController
                                              .text
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
                                              customerMobileNumberController
                                                  .text,
                                            ),
                                          );
                                        },
                                  padding: verticalPadding16,
                                );
                              },
                            ),
                            verticalMargin24,
                            Row(
                              children: [
                                Expanded(child: Divider(color: lightGreyColor)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    "OR",
                                    style: context.labelMedium.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: lightGreyColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            verticalMargin24,
                            // Google Sign-in Button
                            GestureDetector(
                              onTap: isGoogleSignInLoading
                                  ? null
                                  : _handleGoogleSignIn,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isGoogleSignInLoading)
                                      const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    else
                                      SvgPicture.asset(
                                        'assets/svg/google_icon.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        isGoogleSignInLoading
                                            ? "Signing in..."
                                            : "Continue with Google",
                                        style: context.labelLarge.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
