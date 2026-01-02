import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Cart"),
      body: Padding(
        padding: horizontalPadding16,
        child: Column(
          children: [
            CartItem(),
            verticalMargin24,
            GradientButton(
              text: "Add New Booking",
              onTap: () {},
              hideGradient: true,
              iconWithTitle: Icon(Icons.add_circle_outline_rounded, size: 15),
              showIconFirst: true,
              backgroundColor: greyButttonColor,
              borderRadius: 8,
              textStyle: context.labelMedium,
              padding: verticalPadding16,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        onPressedOne: () {
          context.pushNamed(AppRouterNames.customerPaymentMode);
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: topPadding16,
      decoration: BoxDecoration(
        border: Border.all(color: greyButttonColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: horizontalPadding16,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: .start,
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
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "AC Services - Kothrud Shop",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        verticalMargin4,
                        Text(
                          "30 min",
                          style: context.labelLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: lightGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalMargin4,
                Divider(color: greyButttonColor),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Employee", style: context.labelLarge),
                          verticalMargin8,
                          Text(
                            "Suraj Jamdade",
                            style: context.labelMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Date & Time", style: context.labelLarge),
                          verticalMargin8,
                          Text(
                            "Fri, 12 Sep 2025 at 11:00AM",
                            style: context.labelMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: greyButttonColor),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Location", style: context.labelLarge),
                          verticalMargin8,
                          Text(
                            "8502 Preston Rd. Inglewood, Maine 98380",
                            style: context.labelMedium.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalMargin8,
                Row(
                  children: [
                    Expanded(child: Text("Amount", style: context.labelLarge)),
                    Text.rich(
                      TextSpan(
                        text: "₹ ",
                        children: [
                          TextSpan(
                            text: "2500",
                            style: context.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        style: context.bodyLarge.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalMargin8,
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: GradientButton(
              text: "Remove",
              onTap: () {},
              borderRadius: 0,
              textStyle: context.labelLarge.copyWith(color: lavaRedColor),
              hideGradient: true,
              iconWithTitle: Icon(
                Icons.delete_forever,
                size: 18,
                color: lavaRedColor,
              ),
              showIconFirst: true,
              backgroundColor: lavaRedColor.withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
    );
  }
}
