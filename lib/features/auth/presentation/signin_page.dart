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
  TextEditingController customerMobileNumberController = TextEditingController();
  bool isOtpBtnEnabled = false;
  bool isGoogleSignInLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '1088338713221-hs1i9it5cucpjvgmdtkme2b6fhsukrfd.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
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
        setState(() => isGoogleSignInLoading = false);
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Get Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      // Send token to backend
      final dioClient = sl<DioClient>();
      final response = await dioClient.dio.post(
        'customer/google-login',
        data: {
          'id_token': idToken,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'];
        final userData = response.data['user'];
        
        // Create AuthUserModel from response
        final userModel = AuthUserModel.fromJson({
          'id': userData['id'],
          'ref_code': userData['ref_code'] ?? '',
          'ref_by': userData['ref_by'],
          'name': userData['name'],
          'user_name': userData['user_name'],
          'gender': userData['gender'],
          'date_of_birth': userData['date_of_birth'],
          'country': userData['country'],
          'state': userData['state'],
          'city': userData['city'],
          'post_code': userData['post_code'],
          'email': userData['email'],
          'phone': userData['phone'],
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
          'role': userData['role'],
          'status': userData['status']?.toString() ?? 'active',
          'otp_created_at': userData['otp_created_at'],
          'step': userData['step'] ?? 0,
          'otp': userData['otp'],
          'created_at': userData['created_at'] ?? DateTime.now().toIso8601String(),
          'updated_at': userData['updated_at'] ?? DateTime.now().toIso8601String(),
          'description': userData['description'],
          'facebook_url': userData['facebook_url'],
          'instagram_url': userData['instagram_url'],
          'twitter_url': userData['twitter_url'],
          'whatsapp_number': userData['whatsapp_number'],
          'youtube_url': userData['youtube_url'],
          'linkedin_url': userData['linkedin_url'],
          'service_id': userData['service_id'],
        });
        
        // Store auth using saveAuth method
        final appStore = sl<AppStore>();
        await appStore.saveAuth(AuthResponseModel(
          token: token,
          user: userModel,
        ));
        
        // Notify bloc
        sl<AuthBloc>().add(GoogleLoginSuccessEvent(token: token, user: userData));
        
        if (mounted) {
          context.goNamed(AppRouterNames.home);
        }
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Google sign-in failed: ${e.toString()}',
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
                            verticalMargin24,
                            Row(
                              children: [
                                Expanded(child: Divider(color: lightGreyColor)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              onTap: isGoogleSignInLoading ? null : _handleGoogleSignIn,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
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
