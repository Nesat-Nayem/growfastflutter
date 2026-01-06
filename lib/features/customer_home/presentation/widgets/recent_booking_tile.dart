import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class RecentBookingTile extends StatelessWidget {
  const RecentBookingTile({
    super.key,
    required this.title,
    required this.date,
    this.imageUrl,
  });

  final String title;
  final String date;
  final String? imageUrl;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
          horizontalMargin12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.labelLarge.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalMargin4,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: lightGreyTextColor,
                    ),
                    horizontalMargin4,
                    Text(
                      date,
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
        ],
      ),
    );
  }
}
