import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerBookingCard extends StatelessWidget {
  const CustomerBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12 + horizontalPadding4,
      margin: verticalPadding8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            height: min(240, context.height * 0.25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl:
                    "http://laravel.test/storage/services/XizJH1aguhYRN9BQovGI9AwBTUGkpenPQuo8vRoZ.jpg",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          verticalMargin24,
          Row(
            children: [
              Text(
                "AC Services",
                style: context.bodySmall.copyWith(letterSpacing: 1.1),
              ),
              horizontalMargin12,
              StatusButton(
                title: "Cancelled",
                backgroundColor: lavaRedColor.withValues(alpha: 0.11),
                titleColor: lavaRedColor,
                textStyle: context.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          verticalMargin16,
          _BookingDetails(),
        ],
      ),
    );
  }
}

class _BookingDetails extends StatelessWidget {
  const _BookingDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BookingRowTile(
          title: "Booking Date",
          value: "02 Sep 2022, 17:00-18:00",
        ),
        verticalMargin8,
        _BookingRowTile(
          title: "Amount",
          value: "₹ 2500.00",
          extraValueContent: StatusButton(
            title: "Paypal",
            backgroundColor: Color(0XFF245F9E).withValues(alpha: 0.16),
            titleColor: Color(0XFF245F9E),
          ),
        ),
        verticalMargin8,
        _BookingRowTile(title: "Location", value: "Pune"),
        verticalMargin8,
        _BookingRowTile(
          title: "Provider",
          value: "HP Engineering",
          keepExtraContentFirst: true,
          extraValueContent: Image.asset(
            "assets/images/g_logo.png",
            height: 18,
          ),
        ),
        verticalMargin8,
        Row(
          children: [
            Icon(Icons.email_outlined, size: 17),
            horizontalMargin4,
            Text(
              "info@hp.com",
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: lightGreyTextColor,
              ),
            ),
            horizontalMargin16,
            Icon(Icons.local_phone_outlined, size: 17),
            horizontalMargin4,
            Text(
              "+91 9989887767",
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: lightGreyTextColor,
              ),
            ),
          ],
        ),
        verticalMargin16,
        Row(
          children: [
            GradientButton(
              text: "Reschedule",
              onTap: () {},
              borderRadius: 5,
              padding: verticalPadding12 + horizontalPadding24,
              textStyle: context.labelMedium.copyWith(color: whiteColor),
            ),
            horizontalMargin8,
            GradientButton(
              text: "Cancel",
              onTap: () {},
              borderRadius: 5,
              hideGradient: true,
              backgroundColor: greyButttonColor,
              padding: verticalPadding12 + horizontalPadding24,
              textStyle: context.labelMedium.copyWith(
                color: textBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BookingRowTile extends StatelessWidget {
  const _BookingRowTile({
    required this.title,
    this.extraValueContent,
    required this.value,
    this.keepExtraContentFirst = false,
  });

  final String title;
  final String value;
  final Widget? extraValueContent;
  final bool keepExtraContentFirst;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(":"),
            ],
          ),
        ),
        horizontalMargin12,
        Expanded(
          flex: 2,
          child: Row(
            children: [
              if (keepExtraContentFirst) ...[
                ?extraValueContent,
                horizontalMargin8,
                Text(
                  value,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: lightGreyTextColor,
                  ),
                ),
              ] else ...[
                Text(
                  value,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: lightGreyTextColor,
                  ),
                ),
                if (extraValueContent != null) ...[
                  horizontalMargin12,
                  ?extraValueContent,
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
