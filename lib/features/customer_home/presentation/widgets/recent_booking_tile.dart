import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class RecentBookingTile extends StatelessWidget {
  const RecentBookingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12,
      margin: verticalPadding8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              "https://plus.unsplash.com/premium_photo-1664536392896-cd1743f9c02c?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW4lMjBiZWluZ3N8ZW58MHx8MHx8fDA%3D",
              cacheManager: CachedNetworkImageProvider.defaultCacheManager,
            ),
          ),
          horizontalMargin8,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "John Smith",
                  style: context.labelLarge.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "John@gmail.com",
                  style: context.labelSmall.copyWith(
                    letterSpacing: 1.1,
                    color: lightGreyTextColor,
                  ),
                ),
                verticalMargin12,
                Text(
                  "Computer Repair",
                  style: context.labelMedium.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: lightGreyTextColor,
                    ),
                    horizontalMargin4,
                    Text(
                      "22 Sep 2023",
                      style: context.labelMedium.copyWith(
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w400,
                        color: lightGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              GradientButton(
                text: "Accept",
                padding: verticalPadding8 + horizontalPadding24,
                onTap: () {},
                borderRadius: 5,
                textStyle: context.labelLarge.copyWith(color: whiteColor),
              ),
              verticalMargin8,
              GradientButton(
                text: "Cancel",
                padding: verticalPadding8 + horizontalPadding24,
                onTap: () {},
                borderRadius: 5,
                hideGradient: true,
                textStyle: context.labelLarge.copyWith(color: textBlackColor),
                backgroundColor: greyButttonColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
