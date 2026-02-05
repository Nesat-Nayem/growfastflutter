import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/home/data/model/service_section_model.dart';
import 'package:grow_first/features/listing/presentation/widgets/contact_supplier_simple_popup.dart';
import 'package:grow_first/features/widgets/shimmer.dart';

class HomeServiceSection extends StatelessWidget {
  final String title;
  final String serviceType;
  final List<ServiceSectionModel> services;
  final bool isLoading;

  const HomeServiceSection({
    super.key,
    required this.title,
    required this.serviceType,
    required this.services,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer(context);
    }

    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate card dimensions to match listing page grid view
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = 6.0; // horizontalPadding3 * 2
    final cardGap = 8.0;
    final cardWidth = (screenWidth - horizontalPadding - cardGap) / 2;
    // Use same aspect ratio as listing page (0.58)
    final cardHeight = cardWidth / 0.58;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              onPressed: () {
                context.pushNamed(
                  AppRouterNames.listings,
                  queryParameters: {'service_type': serviceType},
                );
              },
              icon: Icon(
                Icons.keyboard_arrow_right_sharp,
                color: Color(0XFF7D8FAB),
                size: 32,
              ),
            ),
          ],
        ),
        verticalMargin8,
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: min(10, services.length),
            separatorBuilder: (_, __) => SizedBox(width: cardGap),
            itemBuilder: (context, index) {
              return _ServiceSectionCard(
                service: services[index],
                cardWidth: cardWidth,
              );
            },
          ),
        ),
        verticalMargin16,
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppShimmer(width: 150, height: 20)),
            horizontalMargin8,
            AppShimmer(width: 32, height: 32),
          ],
        ),
        verticalMargin8,
        SizedBox(
          height: 340,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) => AppShimmer(width: 200, height: 330),
            separatorBuilder: (_, __) => horizontalMargin12,
            itemCount: 3,
          ),
        ),
        verticalMargin16,
      ],
    );
  }
}

class _ServiceSectionCard extends StatelessWidget {
  final ServiceSectionModel service;
  final double? cardWidth;

  const _ServiceSectionCard({required this.service, this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl();
    // Calculate card width: (screen width - horizontal padding - gap between cards) / 2
    final screenWidth = MediaQuery.sizeOf(context).width;
    final calculatedWidth = cardWidth ?? ((screenWidth - 6 - 8) / 2); // 6 = horizontalPadding3*2, 8 = gap

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouterNames.listingDetail,
          pathParameters: {"listingId": service.id.toString()},
        );
      },
      child: Container(
        width: calculatedWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with location badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.3,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        )
                      : Container(
                          color: lightGreySnowColor,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                ),
                // Location badge
                if (service.city != null && service.city!.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
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
                            service.city!,
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
                    // Rating row
                    Row(
                      children: [
                        const Spacer(),
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
                      service.title,
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
                      "₹${service.price}",
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // Book Now Button
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
                                pathParameters: {"listingId": service.id.toString()},
                              );
                            } else {
                              context.pushNamed(
                                AppRouterNames.signIn,
                                extra: {
                                  "redirectTo": AppRouterNames.customerSelectBookingLocation,
                                  "listingId": service.id.toString(),
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
                    // Contact Supplier Button
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContactSupplierSimplePopup(
                                serviceId: service.id,
                                serviceTitle: service.title,
                                servicePrice: service.price,
                                serviceCity: service.city ?? '',
                                serviceImageUrl: _resolveImageUrl(),
                              ),
                            ),
                          );
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _resolveImageUrl() {
    // First try gallery images (same as listing page)
    // API returns gallery with "img" field like: "services/NC0odNeEFjgLhGXvfY5lHYFXt143N4CE0APrCIqq.webp"
    if (service.gallery.isNotEmpty) {
      final raw = service.gallery.first.img;
      if (raw.isNotEmpty) {
        if (raw.startsWith('http')) {
          return raw;
        }
        // Gallery images are stored in storage folder
        return "https://growfirst.org/storage/$raw";
      }
    }

    // Then try service_image
    if (service.serviceImage != null && service.serviceImage!.isNotEmpty) {
      final raw = service.serviceImage!;
      if (raw.startsWith('http')) {
        return raw;
      }
      final normalized = raw.startsWith('storage/')
          ? raw.replaceFirst('storage/', '')
          : raw;
      return "https://growfirst.org/storage/$normalized";
    }

    // Finally try image field
    if (service.image != null && service.image!.isNotEmpty) {
      final raw = service.image!;
      if (raw.startsWith('http')) {
        return raw;
      }
      final normalized = raw.startsWith('storage/')
          ? raw.replaceFirst('storage/', '')
          : raw;
      return "https://growfirst.org/storage/$normalized";
    }

    return null;
  }
}
