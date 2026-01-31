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
import 'package:grow_first/features/widgets/gradient_button.dart';
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
          height: min(340, MediaQuery.sizeOf(context).height * 0.45),
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: min(10, services.length),
            separatorBuilder: (_, __) => horizontalMargin12,
            itemBuilder: (context, index) {
              return _ServiceSectionCard(service: services[index]);
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

  const _ServiceSectionCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl();

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRouterNames.listingDetail,
          pathParameters: {"listingId": service.id.toString()},
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with location badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 135,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 135,
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 135,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        )
                      : Container(
                          height: 135,
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: lightGreySnowColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            service.city!,
                            style: context.labelSmall.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating row
                  Row(
                    children: [
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: selectiveYellowColor,
                      ),
                      Text(
                        "(4.5)",
                        style: context.labelSmall.copyWith(
                          color: lightGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                  verticalMargin4,
                  // Title
                  Text(
                    service.title,
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalMargin8,
                  // Price
                  Text.rich(
                    TextSpan(
                      text: "₹",
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: service.price,
                          style: context.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalMargin8,
                  // Book Now Button
                  GradientButton(
                    text: "Book Now",
                    onTap: () {
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
                            "redirectTo":
                                AppRouterNames.customerSelectBookingLocation,
                            "listingId": service.id.toString(),
                          },
                        );
                      }
                    },
                    padding: verticalPadding12,
                    borderRadius: 6,
                    textStyle: context.labelMedium.copyWith(color: whiteColor),
                  ),
                  verticalMargin8,
                  // Contact Supplier Button
                  GradientButton(
                    text: "Contact Supplier",
                    onTap: () {
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
                    hideGradient: true,
                    padding: verticalPadding12,
                    borderRadius: 6,
                    backgroundColor: greyButttonColor,
                    textStyle: context.labelMedium,
                  ),
                ],
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
