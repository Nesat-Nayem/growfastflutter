import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

class PaymentModePage extends StatefulWidget {
  const PaymentModePage({super.key});

  @override
  _PaymentModePageState createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage> {
  bool? selectedPaytm = true;
  bool? selectedPhonePay = false;
  bool? selectedGooglePay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Payment"),
      body: Padding(
        padding: verticalPadding12 + horizontalPadding16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Payment Types", style: context.labelLarge),
              verticalMargin16,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedPaytm == true
                        ? Color(0XFFFE8C00)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: verticalPadding12 + horizontalPadding12,
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.paytmSvg, height: 8),
                    horizontalMargin16,
                    Expanded(child: Text("Paytm", style: context.labelLarge)),
                    Radio<bool>(
                      value: true,
                      groupValue: selectedPaytm,
                      onChanged: (val) {
                        setState(() {
                          selectedPaytm = val;
                          selectedPhonePay = false;
                          selectedGooglePay = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              verticalMargin16,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedPhonePay == true
                        ? Color(0XFFFE8C00)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: verticalPadding12 + horizontalPadding12,
                child: Row(
                  children: [
                    Image.asset(AppAssets.phonePaySvg),
                    horizontalMargin12,
                    Expanded(child: Text("Phonepe", style: context.labelLarge)),
                    Radio<bool>(
                      value: true,
                      groupValue: selectedPhonePay,
                      onChanged: (val) {
                        setState(() {
                          selectedPhonePay = val;
                          selectedPaytm = false;
                          selectedGooglePay = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              verticalMargin16,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedGooglePay == true
                        ? Color(0XFFFE8C00)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: verticalPadding12 + horizontalPadding12,
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.googlePaySvg, height: 28),
                    horizontalMargin16,
                    Expanded(
                      child: Text("Google pay", style: context.labelLarge),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: selectedGooglePay,
                      onChanged: (val) {
                        setState(() {
                          selectedGooglePay = val;
                          selectedPhonePay = false;
                          selectedPaytm = false;
                        });
                      },
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

                  // PAY BUTTON
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        title1: "Pay ₹2575",
        title2: "Back to Cart",
        showIcon: false,
        onPressedOne: () {
          context.pushNamed(AppRouterNames.customerBookingConfirmed);
        },
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
