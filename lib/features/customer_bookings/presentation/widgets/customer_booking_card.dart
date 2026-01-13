import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerBookingCard extends StatelessWidget {
  const CustomerBookingCard({super.key, this.booking});

  final Map<String, dynamic>? booking;

  String _getServiceImage() {
    final config = sl<AppConfig>();
    final baseUrl = config.imageBaseUrl;

    // Try to get the first gallery image from service
    final service = booking?['service'];
    if (service != null) {
      // Check if gallery exists and has images
      final gallery = service['gallery'];
      if (gallery != null && gallery is List && gallery.isNotEmpty) {
        final firstImage = gallery[0];
        if (firstImage != null && firstImage['img'] != null) {
          final imagePath = firstImage['img'].toString();
          // If the path already contains http/https, return as is
          if (imagePath.startsWith('http')) {
            return imagePath;
          }
          // Otherwise, construct the full URL with Laravel storage URL
          return '$baseUrl/storage/$imagePath';
        }
      }

      // Fallback to service image if available
      if (service['image'] != null) {
        final imagePath = service['image'].toString();
        if (imagePath.startsWith('http')) {
          return imagePath;
        }
        return '$baseUrl/storage/$imagePath';
      }
    }

    // Default placeholder image
    return 'https://via.placeholder.com/400x300?text=No+Image';
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return lavaRedColor;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

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
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: _getServiceImage(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text('No Image', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          verticalMargin24,
          Row(
            children: [
              Container(
                height: 100,
                width: 250,
                child: Text(
                  booking?['service']?['title'] ?? "Service",
                  style: context.bodySmall.copyWith(letterSpacing: 1.1),
                ),
              ),

              horizontalMargin12,
              StatusButton(
                title: booking?['status'] ?? "Pending",
                backgroundColor: _getStatusColor(
                  booking?['status'],
                ).withValues(alpha: 0.11),
                titleColor: _getStatusColor(booking?['status']),
                textStyle: context.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          verticalMargin16,
          _BookingDetails(booking: booking),
        ],
      ),
    );
  }
}

class _BookingDetails extends StatelessWidget {
  const _BookingDetails({this.booking});

  final Map<String, dynamic>? booking;

  String _formatBookingDateTime() {
    final date = booking?['booking_date'];
    final slots = booking?['booking_slots'];

    if (date == null) return 'N/A';

    // If slots is null or empty, just return the date
    if (slots == null ||
        slots.toString().isEmpty ||
        slots.toString() == 'null') {
      return date.toString();
    }

    // Return date with time slots
    return '$date, $slots';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (booking?['booking_date'] != null)
          _BookingRowTile(
            title: "Booking Date",
            value: _formatBookingDateTime(),
          ),
        verticalMargin8,
        _BookingRowTile(
          title: "Amount",
          value: "₹ ${booking?['total_price'] ?? '0.00'}",
          extraValueContent: StatusButton(
            title: booking?['payment_method'] ?? "Cash",
            backgroundColor: Color(0XFF245F9E).withValues(alpha: 0.16),
            titleColor: Color(0XFF245F9E),
          ),
        ),
        verticalMargin8,
        _BookingRowTile(
          title: "Status",
          value: booking?['payment_status'] ?? 'Pending',
        ),
        verticalMargin8,
        _BookingRowTile(
          title: "Provider",
          value: booking?['service']?['user']?['name'] ?? 'N/A',
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
              booking?['service']?['user']?['email'] ?? 'N/A',
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
            Icon(Icons.local_phone_outlined, size: 17),
            horizontalMargin4,
            Text(
              booking?['service']?['user']?['phone'] ?? 'N/A',
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: lightGreyTextColor,
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     GradientButton(
        //       text: "Reschedule",
        //       onTap: () {},
        //       borderRadius: 5,
        //       padding: verticalPadding12 + horizontalPadding24,
        //       textStyle: context.labelMedium.copyWith(color: whiteColor),
        //     ),
        //     horizontalMargin8,
        //     GradientButton(
        //       text: "Cancel",
        //       onTap: () {},
        //       borderRadius: 5,
        //       hideGradient: true,
        //       backgroundColor: greyButttonColor,
        //       padding: verticalPadding12 + horizontalPadding24,
        //       textStyle: context.labelMedium.copyWith(
        //         color: textBlackColor,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ],
        // ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(":"),
            ],
          ),
        ),
        horizontalMargin12,
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (keepExtraContentFirst) ...[
                if (extraValueContent != null) extraValueContent!,
                if (extraValueContent != null) horizontalMargin8,
                Expanded(
                  child: Text(
                    value,
                    style: context.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightGreyTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    value,
                    style: context.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightGreyTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (extraValueContent != null) ...[
                  horizontalMargin12,
                  extraValueContent!,
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
