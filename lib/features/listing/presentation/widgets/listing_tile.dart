import 'package:grow_first/core/app_store/app_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/presentation/widgets/contact_supplier_popup.dart';
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: whiteColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: isGridView ? _buildGridCard(context) : _buildListCard(context),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with location badge
        Stack(
          children: [
            _ServiceImage(isGridView: true, listing: listing),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey.shade700),
                    const SizedBox(width: 2),
                    Text(
                      listing?.city ?? "",
                      style: context.labelSmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company name and rating row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing?.user?.companyName ?? "",
                        style: context.labelSmall.copyWith(
                          color: lightGreyTextColor,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star, size: 14, color: selectiveYellowColor),
                    const SizedBox(width: 2),
                    Text(
                      "(4.5)",
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  listing?.title ?? "Service Title",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price
                Text(
                  "₹${listing?.price ?? '0.00'}",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                // Buttons
                if (showActionButtons) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C6C6), Color(0xFF0099CC)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final appStore = sl<AppStore>();
                          if (appStore.isLoggedIn) {
                            context.pushNamed(
                              AppRouterNames.customerSelectBookingLocation,
                              pathParameters: {
                                "listingId": listing?.id.toString() ?? "",
                              },
                            );
                          } else {
                            context.pushNamed(
                              AppRouterNames.signIn,
                              extra: {
                                "redirectTo": AppRouterNames.customerSelectBookingLocation,
                                "listingId": listing?.id.toString() ?? "",
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: whiteColor,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Book Now",
                          style: context.labelSmall.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: OutlinedButton(
                      onPressed: () {
                        if (listing != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContactSupplierPopup(listing: listing!),
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textBlackColor,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Contact Supplier",
                          style: context.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Padding(
      padding: verticalPadding12 + horizontalPadding12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ListingOrganizationAndRating(listing: listing),
          verticalMargin8,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    onTap: () {
                      if (listing != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ContactSupplierPopup(listing: listing!),
                          ),
                        );
                      }
                    },
                    hideGradient: true,
                    padding: verticalPadding12,
                    borderRadius: 6,
                    backgroundColor: whiteColor,
                    textStyle: context.labelLarge.copyWith(color: textBlackColor),
                    enableBorder: true,
                    borderColor: aquaBlueColor,
                  ),
                ),
                horizontalMargin8,
                Expanded(
                  child: GradientButton(
                    text: "Book Now",
                    onTap: () {
                      final appStore = sl<AppStore>();
                      if (appStore.isLoggedIn) {
                        context.pushNamed(
                          AppRouterNames.customerSelectBookingLocation,
                          pathParameters: {
                            "listingId": listing?.id.toString() ?? "",
                          },
                        );
                      } else {
                        context.pushNamed(
                          AppRouterNames.signIn,
                          extra: {
                            "redirectTo": AppRouterNames.customerSelectBookingLocation,
                            "listingId": listing?.id.toString() ?? "",
                          },
                        );
                      }
                    },
                    padding: verticalPadding12,
                    borderRadius: 6,
                    textStyle: context.labelLarge.copyWith(color: whiteColor),
                  ),
                ),
              ],
            ),
          ],
        ],
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
    final imageUrl = _resolveImageUrl();

    if (isGridView) {
      return AspectRatio(
        aspectRatio: 1.3,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Container(
                color: lightGreySnowColor,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: 65,
              width: 65,
              fit: BoxFit.cover,
            )
          : Container(
              height: 65,
              width: 65,
              color: lightGreySnowColor,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported_outlined),
            ),
    );
  }

  String? _resolveImageUrl() {
    String? raw;

    final gallery = listing?.gallery;
    if (gallery != null && gallery.isNotEmpty) {
      raw = gallery.first.img;
    } else if ((listing?.image ?? '').isNotEmpty) {
      raw = listing?.image;
    }

    if (raw == null || raw.isEmpty) {
      return null;
    }

    if (raw.startsWith('http')) {
      return raw;
    }

    final normalized = raw.startsWith('storage/')
        ? raw.replaceFirst('storage/', '')
        : raw;

    return "${sl<AppConfig>().imageBaseUrl}/storage/$normalized";
  }
}

class _ListingOrganizationAndRating extends StatelessWidget {
  const _ListingOrganizationAndRating({required this.listing});

  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isGridView) ...[verticalMargin8],
        Text(
          listing?.title ?? "Split AC Repair Service, in On Site",
          style: style.copyWith(fontWeight: FontWeight.w600),
          maxLines: isGridView ? 1 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
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
