import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class CustomerBookingConfirmedPage extends StatefulWidget {
  const CustomerBookingConfirmedPage({super.key});

  @override
  State<CustomerBookingConfirmedPage> createState() =>
      _CustomerBookingConfirmedPageState();
}

class _CustomerBookingConfirmedPageState
    extends State<CustomerBookingConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Confirmed"),
      body: SingleChildScrollView(
        child: Padding(
          padding: verticalPadding12 + horizontalPadding16,
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(AppAssets.successCheckMarkSvg, height: 55),
                verticalMargin16,
                Text("Your Booking is Successfully", style: context.bodySmall),
                verticalMargin12,
                Text(
                  "Sun 16 July 2025 at 5:00pm",
                  style: context.labelMedium.copyWith(
                    color: lightGreyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                verticalMargin32,
                Container(
                  margin: bottomPadding16,
                  padding: allPadding16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      horizontalMargin12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "AC Services",
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Booking ref. #65742695",
                              style: context.labelSmall.copyWith(
                                color: lightGreyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                verticalMargin24,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemRow("Ac Services", "₹2500", "30 Min"),
                    const SizedBox(height: 16),
                    _buildItemRow("AC Cleaning", "₹200", "30 Min"),
                    const SizedBox(height: 16),
                    _buildItemRow("Switches Changes", "₹100", "30 Min"),

                    const SizedBox(height: 20),
                    const Divider(),

                    const SizedBox(height: 12),
                    _buildSummaryRow("Sub Total", "₹3757"),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Tax (GST 5%)", "₹60"),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Discount (15%)", "₹757"),

                    verticalMargin24,
                    _buildTotalRow("Total", "₹2757"),

                    verticalMargin24,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              GradientButton(
                text: "Go to Home",
                onTap: () {
                  context.goNamed(AppRouterNames.home);
                },
                iconWithTitle: Padding(
                  padding: horizontalPadding4 / 2,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: whiteColor,
                    size: 17,
                  ),
                ),
                textStyle: context.labelLarge.copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(String title, String price, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.labelMedium),
            verticalMargin2,
            Text(
              time,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Text(price, style: context.labelMedium),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.labelMedium),
        Text(value, style: context.labelMedium),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
