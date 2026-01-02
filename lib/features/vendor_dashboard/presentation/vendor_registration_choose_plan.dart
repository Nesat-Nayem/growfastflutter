import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class VendorRegistrationChoosePlan extends StatelessWidget {
  const VendorRegistrationChoosePlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              GradientButton(
                text: "Next",
                onTap: () {
                  context.pushNamed('vendorKycForm');
                },
                // iconWithTitle: Padding(
                //   padding: horizontalPadding4 / 2,
                //   child: Icon(
                //     Icons.arrow_outward_rounded,
                //     color: whiteColor,
                //     size: 17,
                //   ),
                // ),
                textStyle: context.labelLarge.copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StepProgressHeader(
              currentStep: 1,
              steps: const [
                StepItem(label: "Basic Info", icon: Icons.info_outline),
                StepItem(label: "Choose Plan", icon: Icons.cast_outlined),
                StepItem(
                  label: "KYC Details",
                  icon: Icons.description_outlined,
                ),
                StepItem(label: "Confirmation", icon: Icons.check),
              ],
            ),
            Expanded(child: SingleChildScrollView(child: PricingPage())),
          ],
        ),
      ),
    );
  }
}

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  bool isMonthlySelected = true;

  Widget _toggleItem(String text, bool selected) {
    return InkWell(
      onTap: () {
        setState(() {
          isMonthlySelected = !isMonthlySelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF1FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.black, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  bool chooseStandard = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Pricing Plan",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Affordable plans designed to match your\nneeds and budget.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textLightColor,
            ),
          ),
          const SizedBox(height: 20),

          /// Monthly / Yearly Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleItem("Monthly", isMonthlySelected),
                _toggleItem("Yearly", !isMonthlySelected),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// Pricing Card
          InkWell(
            onTap: () {
              setState(() {
                chooseStandard = !chooseStandard;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                gradient: !chooseStandard
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5FA8C8), Color(0xFF9ED2E0)],
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Icon
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
                      ),
                    ),
                    child: const Icon(Icons.track_changes, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Basic Plan",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Unleash the Power of Your Business with Basic Plan.",
                    style: TextStyle(
                      color: chooseStandard ? Colors.grey : null,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Price
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "₹2500.00",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "  per month",
                          style: TextStyle(
                            color: chooseStandard ? Colors.grey : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(color: lightBlackTextColor),

                  const SizedBox(height: 16),

                  _featureItem("1 Bathroom cleaning"),
                  _featureItem("Up to 3 bedrooms cleaning"),
                  _featureItem("Full Furnished Room Cleaning"),
                  _featureItem("Additional 05 Rooms"),
                  _featureItem("Small Kitchen (0–150 ft²)"),

                  const SizedBox(height: 30),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text(
                        "Choose Plan",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          verticalMargin32,
          InkWell(
            onTap: () {
              setState(() {
                chooseStandard = !chooseStandard;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                gradient: chooseStandard
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5FA8C8), Color(0xFF9ED2E0)],
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  /// Curved light overlay (right side)
                  chooseStandard
                      ? Positioned(
                          top: -30,
                          right: 10,
                          child: Container(
                            height: 700,
                            width: 700,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF5FA8C8), Color(0xFF9ED2E0)],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.diamond_outlined,
                              color: Color(0xFF1F2A44),
                              size: 28,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: chooseStandard
                                    ? Colors.white
                                    : textBlackColor,
                              ),
                            ),
                            child: Text(
                              "Best offer",
                              style: TextStyle(
                                fontSize: 12,
                                color: chooseStandard ? Colors.white : null,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// Title
                      const Text(
                        "Standard",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2A44),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Take Your Business to the Next Level with Business Plan.",
                        style: TextStyle(
                          color: Color(0xFF1F2A44),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Price
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "₹2500.00",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2A44),
                              ),
                            ),
                            TextSpan(
                              text: "  per month",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2A44),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.white),

                      const SizedBox(height: 20),

                      _feature("24/7 Customer Support"),
                      _feature("Live Chat Assistance"),
                      _feature("Secure Payment Options"),
                      _feature("Instant Booking & Tracking"),
                      _feature("Multiple City Leads"),

                      const SizedBox(height: 40),

                      /// Button
                      GradientButton(
                        backgroundColor: chooseStandard ? null : whiteColor,
                        text: "Choose Plan",
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF1F2A44),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF1F2A44), fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
