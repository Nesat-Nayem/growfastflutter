import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_location.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_staff.dart';

class CustomerBooking extends StatelessWidget {
  const CustomerBooking({
    super.key,
    this.showEmail,
    this.statusButtonText,
    this.showLocation = true,
    this.isMainSelectLocationCard = false,
    this.bookingLocation,
    this.bookingStaff,
    this.isSelected = false,
    this.onSelected,
  });

  final String? showEmail;
  final String? statusButtonText;
  final bool showLocation;
  final bool isMainSelectLocationCard;
  final BookingLocation? bookingLocation;
  final BookingStaff? bookingStaff;
  final bool isSelected;
  final ValueChanged<bool?>? onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected != null ? () => onSelected!(!isSelected) : null,
      child: Container(
        margin: bottomPadding16,
        padding: allPadding16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? aquaGreenColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                horizontalMargin12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(),
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_getSubtitle() != null) ...[
                        verticalMargin4,
                        Text(
                          _getSubtitle()!,
                          style: context.labelSmall.copyWith(
                            color: lightGreyTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                CheckboxTheme(
                  data: CheckboxThemeData(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    checkColor: WidgetStatePropertyAll(whiteColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Checkbox(
                    fillColor: WidgetStatePropertyAll(aquaGreenColor),
                    value: isSelected,
                    onChanged: onSelected,
                  ),
                ),
              ],
            ),
            if (showLocation && bookingLocation != null) ...[
              verticalMargin12,
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: Colors.black87,
                  ),
                  horizontalMargin4,
                  Expanded(
                    child: Text(
                      "${bookingLocation?.address}",
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            verticalMargin2,
            Divider(color: greyButttonColor),
            verticalMargin2,
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfff0f6ff),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.red),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _getStatusText(),
                            style: context.labelSmall.copyWith(
                              color: violetBlueColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalMargin8,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      _getRating(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrl() {
    if (isMainSelectLocationCard && bookingLocation?.serviceImage != null) {
      return bookingLocation!.serviceImage!;
    }
    if (bookingStaff?.image != null && bookingStaff!.image.isNotEmpty) {
      return bookingStaff!.image;
    }
    return 'https://via.placeholder.com/100x100?text=No+Image';
  }

  String _getTitle() {
    if (isMainSelectLocationCard) {
      return bookingLocation?.serviceTitle ?? bookingLocation?.name ?? 'Service';
    }
    return bookingStaff?.name ?? 'Staff Name';
  }

  String? _getSubtitle() {
    if (!isMainSelectLocationCard && bookingStaff != null) {
      return bookingStaff!.email;
    }
    return null;
  }

  String _getStatusText() {
    if (isMainSelectLocationCard) {
      return '${bookingLocation?.staffCount ?? 0} Staffs';
    }
    return '${bookingStaff?.noOfServices ?? 0} Services';
  }

  String _getRating() {
    if (isMainSelectLocationCard && bookingLocation?.serviceRating != null) {
      return bookingLocation!.serviceRating!.toStringAsFixed(1);
    }
    if (bookingStaff != null) {
      return bookingStaff!.overAllReview.toStringAsFixed(1);
    }
    return '0.0';
  }
}
