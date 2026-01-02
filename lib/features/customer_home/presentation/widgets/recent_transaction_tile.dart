import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class RecentTransactionTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String time;
  final String iconUrl;

  const RecentTransactionTile({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12 + horizontalPadding4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Container(
            padding: allPadding4 + allPadding4 / 2,
            decoration: BoxDecoration(
              color: lightGreySnowColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(Icons.work_outline),
          ),
          horizontalMargin8,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Service Booking",
                  style: context.labelLarge.copyWith(letterSpacing: 1.1),
                ),
                verticalMargin8,
                Row(
                  children: [
                    Icon(Icons.date_range, size: 14),
                    horizontalMargin4,
                    Text(
                      "22 Sep 2023",
                      style: context.labelSmall.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    horizontalMargin8,
                    Icon(Icons.timer_sharp, size: 14),
                    horizontalMargin4,
                    Text(
                      "17:00",
                      style: context.labelSmall.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: .start,
            children: [
              Text.rich(
                TextSpan(
                  text: "\$",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: "364.00", style: context.bodySmall),
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
