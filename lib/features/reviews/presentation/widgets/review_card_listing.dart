import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class ReviewCardListing extends StatelessWidget {
  const ReviewCardListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: topPadding12,
      padding: topPadding16 + horizontalPadding12 + bottomPadding2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: CachedNetworkImageProvider(
                  "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
              horizontalMargin8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suraj Jamdade", style: context.labelLarge),
                    Row(
                      children: [
                        Text(
                          "2 days ago • Excellent service!",
                          style: context.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: verticalPadding4 + horizontalPadding16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "5",
                  style: context.labelMedium.copyWith(color: whiteColor),
                ),
              ),
            ],
          ),
          verticalMargin12,
          Text(
            "The electricians were prompt, professional, and resolved our issues quickly. "
            "Did a fantastic job upgrading our electrical panel. Highly recommend them for any electrical work.",
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          Padding(
            padding: horizontalPadding24,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                  child: Text(
                    "Reply",
                    style: context.labelMedium.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                  child: Text(
                    "Like",
                    style: context.labelMedium.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                  child: Text(
                    "Dislike",
                    style: context.labelMedium.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "45",
                  style: context.labelMedium.copyWith(
                    color: lightGreyTextColor,
                  ),
                ),
                horizontalMargin16,
                Text(
                  "21",
                  style: context.labelMedium.copyWith(
                    color: lightGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
