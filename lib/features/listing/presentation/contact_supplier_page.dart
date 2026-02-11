import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:grow_first/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';
import 'package:grow_first/features/auth/presentation/widgets/mobile_number_filed_widget.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/listing/presentation/widgets/listing_tile.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ContactSupplierPage extends StatefulWidget {
  const ContactSupplierPage({super.key, required this.listingId});

  final String listingId;

  @override
  State<ContactSupplierPage> createState() => _ContactSupplierPageState();
}

class _ContactSupplierPageState extends State<ContactSupplierPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  bool isOtpBtnEnabled = false;
  String selectedCountryCode = "";

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: ""),
      body: Padding(
        padding: horizontalPadding16,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: .center,
              children: [
                Text(
                  "Login To Get Best\nDeals Instantly",
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalMargin12,
                Text(
                  "Just One Step to Connect with Verified Seller",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: lightGreyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalMargin24,
                BlocBuilder<ListingBloc, ListingState>(
                  bloc: sl<ListingBloc>(),
                  builder: (context, state) {
                    if (state.isSelectedListingLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.selectedListing == null) {
                      return const Text("No listing found");
                    } else {
                      return ListingTile(
                        isGridView: false,
                        showActionButtons: false,
                        listing: state.selectedListing!,
                      );
                    }
                  },
                ),
                verticalMargin32,
                Column(
                  crossAxisAlignment: .center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mobile Number",
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    verticalMargin12,
                    BlocBuilder<CountryCubit, CountryState>(
                      bloc: sl<CountryCubit>(),
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
                              controller: mobileNumberController,
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
                              onCountryChanged: (countryCode) {
                                selectedCountryCode = countryCode;
                              },
                            ),
                          );
                        }

                        return emptyBox;
                      },
                    ),

                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state.isOtpSent) {
                          context.pushNamed(
                            AppRouterNames.verifyOtp,
                            pathParameters: {
                              "process_initiated_on":
                                  "$selectedCountryCode${mobileNumberController.text.trim()}",
                            },
                          );
                          sl<AuthBloc>().add(ResetOtpSentEvent());
                        }
                      },
                      bloc: sl<AuthBloc>(),
                      builder: (context, state) {
                        return GradientButton(
                          showLoadingIndicator: state.isLoading,
                          text: "Continue",
                          onTap:
                              isOtpBtnEnabled ||
                                  mobileNumberController.text.trim().isEmpty
                              ? () {
                                  sl<AuthBloc>().add(
                                    SendOtpEvent(
                                      "$selectedCountryCode${mobileNumberController.text.trim()}",
                                    ),
                                  );

                                  if (sl<AuthBloc>().state.isOtpSent) {
                                    context.pushNamed(
                                      AppRouterNames.verifyOtp,
                                      pathParameters: {
                                        "process_initiated_on":
                                            " ${mobileNumberController.text.trim()}",
                                      },
                                    );
                                  }

                                  // showGeneralDialog(
                                  //   context: context,
                                  //   barrierDismissible: true,
                                  //   barrierLabel: "Dismiss",
                                  //   barrierColor: Colors.black54,
                                  //   transitionDuration: Duration(milliseconds: 300),
                                  //   pageBuilder: (context, animation1, animation2) {
                                  //     return CustomSuccessPopUp(
                                  //       title: "Success!",
                                  //       description:
                                  //           "Your request has been sent to the supplier!",
                                  //       onOkayPressed: () => context.pop(),
                                  //     );
                                  //   },
                                  // );
                                  // showGeneralDialog(
                                  //   context: context,
                                  //   barrierDismissible: true,
                                  //   barrierLabel: "Dismiss",
                                  //   barrierColor: Colors.black54,
                                  //   transitionDuration: Duration(milliseconds: 300),
                                  //   pageBuilder: (context, animation1, animation2) {
                                  //     return CustomSuccessPopUp(
                                  //       title: "Enquiry Submitted",
                                  //       description:
                                  //           "Your request has been sent to the supplier!",
                                  //       onOkayPressed: () => context.pop(),
                                  //     );
                                  //   },
                                  // );
                                  // showGeneralDialog(
                                  //   context: context,
                                  //   barrierDismissible: true,
                                  //   barrierLabel: "Dismiss",
                                  //   barrierColor: Colors.black54,
                                  //   transitionDuration: Duration(milliseconds: 300),
                                  //   pageBuilder: (context, animation1, animation2) {
                                  //     return SendEnquiryPopUp(onSubmit: () {});
                                  //   },
                                  // );
                                }
                              : null,
                          padding: verticalPadding16,
                        );
                      },
                    ),
                    verticalMargin12,
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.language, size: 20),
                        horizontalMargin8,
                        Text.rich(
                          TextSpan(
                            text: "Your Country is ",
                            children: [
                              TextSpan(
                                text: "india",
                                style: context.labelSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          style: context.labelSmall.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    verticalMargin48,
                    Text(
                      "We don't call, only genuine seller\nwill contact you",
                      style: context.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        color: lightGreyTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding48,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              Text(
                "Almost done! Just verify your mobile",
                style: context.labelLarge.copyWith(
                  color: lightGreyTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
