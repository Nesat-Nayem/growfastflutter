import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/reviews/domain/entities.dart/review.dart';

class ReviewCardListing extends StatelessWidget {
  final Review review;

  const ReviewCardListing({
    super.key,
    required this.review,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: CachedNetworkImageProvider(
                  review.userImage,
                ),
              ),
              horizontalMargin8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: context.labelLarge),
                    Text(
                      review.time,
                      style: context.labelSmall,
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
                  review.rating,
                  style: context.labelMedium.copyWith(color: whiteColor),
                ),
              ),
            ],
          ),
          verticalMargin12,
          Text(
            review.description,
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

