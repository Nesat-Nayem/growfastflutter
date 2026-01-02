import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class GlobalReviewCard extends StatelessWidget {
  const GlobalReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 20),
        horizontalMargin4,
        Text(
          "4.9",
          style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
        ),
        horizontalMargin4,
        Text(
          "(255 reviews)",
          style: context.labelMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: lightGreyTextColor,
          ),
        ),
      ],
    );
  }
}
