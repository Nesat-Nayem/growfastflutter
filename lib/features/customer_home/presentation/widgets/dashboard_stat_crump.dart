import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class DashboardStatCrump extends StatelessWidget {
  const DashboardStatCrump({
    super.key,
    required this.title,
    required this.backgroundIconColor,
    required this.icon,
    required this.percent,
    required this.isProfit,
    this.displayCurrency = false,
    required this.statValue,
  });

  final String title;
  final Color backgroundIconColor;
  final String icon;
  final String percent;
  final bool isProfit;
  final bool displayCurrency;
  final String statValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width / 2.6,
      padding: verticalPadding12 + horizontalPadding12,
      decoration: BoxDecoration(
        border: Border.all(color: lightGreyColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: allPadding4,
                decoration: BoxDecoration(
                  color: backgroundIconColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SvgPicture.asset(icon, height: 19),
              ),
              Container(
                padding: verticalPadding4 / 2 + horizontalPadding8,
                decoration: BoxDecoration(
                  color: isProfit ? aquaGreenColor : lavaRedColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Icon(
                      isProfit
                          ? Icons.arrow_circle_up_sharp
                          : Icons.arrow_circle_down_sharp,
                      color: whiteColor,
                      size: 16,
                    ),
                    horizontalMargin4,
                    Text(
                      percent,
                      style: context.labelSmall.copyWith(color: whiteColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalMargin16,
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FittedBox(
                child: Text(
                  title,
                  style: context.labelMedium.copyWith(
                    color: lightGreyTextColor,
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: displayCurrency ? "₹" : "",
                  children: [
                    TextSpan(
                      text: statValue,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
