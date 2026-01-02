import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/presentation/widgets/send_enquiry_pop_up.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ListingTile extends StatelessWidget {
  const ListingTile({
    super.key,
    required this.isGridView,
    this.showActionButtons = true,
    this.listing,
  });

  final bool isGridView;
  final bool showActionButtons;
  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouterNames.listingDetail,
          pathParameters: {"listingId": listing?.id.toString() ?? ""},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: isGridView
              ? emptyPadding
              : verticalPadding12 + horizontalPadding12,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              if (isGridView) ...[
                Stack(
                  children: [
                    _ServiceImage(isGridView: true, listing: listing),
                    _ListingLocation(location: listing?.city ?? ""),
                  ],
                ),
                verticalMargin8,
                Padding(
                  padding: horizontalPadding12,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _ListingOrganizationAndRating(listing: listing),
                      verticalMargin4,
                      _ListingNameWithPrice(isGridView: true, listing: listing),
                      verticalMargin8,
                      if (showActionButtons) ...[
                        GradientButton(
                          text: "Buy Now",
                          onTap: () {
                            context.pushNamed(
                              AppRouterNames.contactSupplier,
                              pathParameters: {"listingId": "r567uyi"},
                            );
                          },
                          padding: verticalPadding12,
                          borderRadius: 6,
                          textStyle: context.labelMedium.copyWith(
                            color: whiteColor,
                          ),
                        ),
                        verticalMargin8,
                        GradientButton(
                          text: "Contact Supplier",
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: "Dismiss",
                              barrierColor: Colors.black54,
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder: (context, animation1, animation2) {
                                return SendEnquiryPopUp(onSubmit: () {});
                              },
                            );
                          },
                          hideGradient: true,
                          padding: verticalPadding12,
                          borderRadius: 6,
                          backgroundColor: greyButttonColor,
                          textStyle: context.labelMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                _ListingOrganizationAndRating(listing: listing),
                verticalMargin8,
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    _ServiceImage(isGridView: false, listing: listing),
                    horizontalMargin16,
                    _ListingNameWithPrice(isGridView: false, listing: listing),
                  ],
                ),
                verticalMargin12,
                if (showActionButtons) ...[
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: "Contact Supplier",
                          onTap: () {},
                          hideGradient: true,
                          padding: verticalPadding12,
                          borderRadius: 6,
                          backgroundColor: whiteColor,
                          textStyle: context.labelLarge.copyWith(
                            color: textBlackColor,
                          ),
                          enableBorder: true,
                          borderColor: aquaBlueColor,
                        ),
                      ),
                      horizontalMargin8,
                      Expanded(
                        child: GradientButton(
                          text: "Buy Now",
                          onTap: () {},
                          padding: verticalPadding12,
                          borderRadius: 6,
                          textStyle: context.labelLarge.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  const _ServiceImage({required this.isGridView, this.listing});

  final bool isGridView;
  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isGridView
          ? BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )
          : BorderRadiusGeometry.circular(16),
      child: CachedNetworkImage(
        imageUrl:
            "https://growfirst.org/storage/${listing?.gallery.first.img}" ??
            "https://plus.unsplash.com/premium_photo-1664536392896-cd1743f9c02c?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW4lMjBiZWluZ3N8ZW58MHx8MHx8fDA%3D",
        height: isGridView ? 135 : 65,
        width: isGridView ? double.infinity : 65,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ListingLocation extends StatelessWidget {
  const _ListingLocation({this.location});

  final String? location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: allPadding4 + allPadding4 / 2,
      child: Container(
        padding: allPadding4 / 2,
        decoration: BoxDecoration(
          color: lightGreySnowColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(Icons.location_on_outlined, size: 18),
            horizontalMargin2,
            Text(
              location ?? "",
              style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingOrganizationAndRating extends StatelessWidget {
  const _ListingOrganizationAndRating({required this.listing});

  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        Expanded(
          child: Text(
            "",
            style: context.labelSmall.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 16, color: selectiveYellowColor),
            Text(
              "(4.5)",
              style: context.labelSmall.copyWith(color: lightGreyTextColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _ListingNameWithPrice extends StatelessWidget {
  const _ListingNameWithPrice({required this.isGridView, this.listing});

  final bool isGridView;
  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    TextStyle style = isGridView ? context.labelMedium : context.labelLarge;

    Widget child = Column(
      crossAxisAlignment: .start,
      children: [
        if (!isGridView) ...[verticalMargin8],
        Text(
          listing?.title ?? "Split AC Repair Service, in On Site",
          style: style.copyWith(fontWeight: FontWeight.w600),
          maxLines: isGridView ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        verticalMargin4,
        Text.rich(
          TextSpan(
            text: "₹",
            style: context.labelMedium.copyWith(fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: listing?.price ?? "2500.00",
                style: context.bodySmall.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (!isGridView) ...[
          verticalMargin4,
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18),
              horizontalMargin2,
              Text(
                listing?.city ?? "Pune",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ],
    );

    if (isGridView) {
      return child;
    }
    return Expanded(child: child);
  }
}
