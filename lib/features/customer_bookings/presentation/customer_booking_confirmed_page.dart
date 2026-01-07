import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

class CustomerBookingConfirmedPage extends StatefulWidget {
  final String? bookingDate;
  final String? bookingTime;
  final String? bookingRef;

  const CustomerBookingConfirmedPage({
    super.key,
    this.bookingDate,
    this.bookingTime,
    this.bookingRef,
  });

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
                    verticalMargin32,
                    SvgPicture.asset(AppAssets.successCheckMarkSvg, height: 80),
                    verticalMargin32,
                    Text(
                      "Booking Confirmed!",
                      style: context.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalMargin16,
                    Text(
                      "Your booking has been successfully confirmed.\nThank you for choosing our service!",
                      style: context.bodyLarge.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalMargin32,
                    
                    // View Booking Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushNamed(AppRouterNames.customerBookings);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: violetBlueColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "View Bookings",
                          style: context.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    verticalMargin16,
                    
                    // Go to Home Button
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.goNamed(AppRouterNames.home);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: violetBlueColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Go to Home",
                          style: context.labelLarge.copyWith(
                            color: violetBlueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    verticalMargin48,
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
