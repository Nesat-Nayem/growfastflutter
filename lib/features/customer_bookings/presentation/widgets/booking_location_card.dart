import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/domain/entities/booking_location.dart';

class CustomerBooking extends StatelessWidget {
  const CustomerBooking({
    super.key,
    this.showEmail,
    this.statusButtonText,
    this.showLocation = true,
    this.isMainSelectLocationCard = false,
    this.bookingLocation,
    this.isSelected = false,
    this.onSelected,
  });

  final String? showEmail;
  final String? statusButtonText;
  final bool showLocation;
  final bool isMainSelectLocationCard;
  final BookingLocation? bookingLocation;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                horizontalMargin12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMainSelectLocationCard
                            ? (bookingLocation?.name ?? "Location")
                            : (showEmail ?? "Staff Name"),
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (showEmail != null && isMainSelectLocationCard) ...[
                        verticalMargin4,
                        Text(
                          showEmail!,
                          style: context.labelSmall.copyWith(
                            color: lightGreyTextColor,
                          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfff0f6ff),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        isMainSelectLocationCard
                            ? "${bookingLocation?.staffCount ?? 0} Staff"
                            : statusButtonText ?? "12 Staff",
                        style: context.labelSmall.copyWith(
                          color: violetBlueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      "4.9",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "(255 reviews)",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
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
}
