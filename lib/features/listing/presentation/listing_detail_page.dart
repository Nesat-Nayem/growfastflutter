import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/listing/presentation/widgets/contact_supplier_popup.dart';
import 'package:grow_first/features/reviews/presentation/add_review_popup.dart';
import 'package:grow_first/features/reviews/presentation/bloc/reviews_cubit.dart';
import 'package:grow_first/features/reviews/presentation/widgets/review_card_listing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListingDetailPage extends StatefulWidget {
  const ListingDetailPage({super.key, required this.listingId});

  final String listingId;

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  late final ListingBloc _listingBloc;

  @override
  void initState() {
    super.initState();
    _listingBloc = sl.get<ListingBloc>();
    _listingBloc.add(LoadListingDetail(widget.listingId));
  }

  @override
  void dispose() {
    _listingBloc.close();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_monthName(date.month)} "
        "${date.year}";
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void shareService({required Listing listing}) {
    final text =
        '''
${listing.title}

💰 Price: ₹${listing.price}
📍 Address: ${listing.address}
📞 Phone: ${listing.user?.phone ?? 'N/A'}

View details:
${sl<AppConfig>().imageBaseUrl}/service/${listing.slug}
''';

    SharePlus.instance.share(
      ShareParams(text: text, subject: 'Check out this service on GrowFirst!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _callPhone(String phone) async {
      final Uri uri = Uri(scheme: 'tel', path: phone);
      await launchUrl(uri);
    }

    Future<void> _openWebsite(String website) async {
      final Uri uri = Uri.parse(
        website.startsWith("http") ? website : "https://$website",
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Cannot open: $uri");
      }
    }

    Future<void> _openEmail(String email) async {
      final Uri uri = Uri(scheme: 'mailto', path: email);
      await launchUrl(uri);
    }

    Future<void> _openMap(String address) async {
      final Uri uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
      );
      await launchUrl(uri);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomerHomeAppBar(singleTitle: "Detail"),
      body: BlocBuilder<ListingBloc, ListingState>(
        bloc: _listingBloc,
        builder: (context, state) {
          if (state.isSelectedListingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.selectedListing == null) {
            return Center(child: Text("Listing not found"));
          }
          final Listing? listing = state.selectedListing;
          final user = listing?.user;

          final videoId = YoutubePlayer.convertUrlToId(
            listing?.videoLink ?? '',
          );

          Widget? videoChild;

          if (videoId != null) {
            videoChild = ServiceVideoDropDown(videoUrl: listing!.videoLink!);
          } else {
            videoChild = SizedBox.shrink();
          }

          return ListView(
            padding: horizontalPadding16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalMargin12,
                  if (listing?.gallery.length != 0) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${sl<AppConfig>().imageBaseUrl}/storage/${listing?.gallery.first.img}",
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    verticalMargin12,
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemCount: listing?.gallery.sublist(1).length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) {
                          final url = listing?.gallery[i + 1].img;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${sl<AppConfig>().imageBaseUrl}/storage/${url}",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    verticalMargin16,
                  ],
                  Row(
                    children: [
                      StatusButton(
                        title: "50% Offer",
                        backgroundColor: aquaGreenColor,
                        titleColor: whiteColor,
                      ),
                      const Spacer(),
                      Container(
                        padding: allPadding8,
                        decoration: BoxDecoration(
                          color: greyButttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.collections_bookmark_rounded,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text("6000+ Bookings", style: context.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalMargin8,
                  Text(
                    "${listing?.title}",
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalMargin12,
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Starts From",
                            style: context.labelSmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          verticalMargin4,
                          Text(
                            "₹ ${listing?.price}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ReviewBuilder(
                        rating: listing?.overAllRating ?? 0,
                        totalReviews: listing?.totalRatings ?? 0,
                      ),
                    ],
                  ),
                  verticalMargin16,
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        listing?.city ?? "Location",
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "View Location",
                        style: context.labelSmall.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF588540),
                          height: 1.5,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0XFF588540),
                        ),
                      ),
                    ],
                  ),
                  verticalMargin16,
                  Container(
                    width: double.infinity,
                    padding: verticalPadding24,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${listing?.user?.companyName ?? ''}",
                          style: context.bodyMedium.copyWith(
                            color: lightGreyTextColor,
                          ),
                        ),
                        verticalMargin8,
                        ReviewBuilder(
                          rating: listing?.overAllRating ?? 0,
                          totalReviews: listing?.totalRatings ?? 0,
                        ),
                      ],
                    ),
                  ),
                  verticalMargin16,
                  if (user != null) ...[
                    _detailRow("Member Since", formatDate(user.createdAt)),
                    InkWell(
                      onTap: user.address.isNotEmpty
                          ? () => _openMap(user.address)
                          : null,
                      child: _detailRow(
                        "Address",
                        user.address.isNotEmpty ? user.address : "N/A",
                      ),
                    ),
                    InkWell(
                      onTap: user.email.isNotEmpty
                          ? () => _openEmail(user.email)
                          : null,
                      child: _detailRow(
                        "Email",
                        user.email.isNotEmpty ? user.email : "N/A",
                      ),
                    ),

                    InkWell(
                      onTap: user.phone.isNotEmpty
                          ? () => _callPhone(user.phone)
                          : null,
                      child: _detailRow(
                        "Phone",
                        user.phone.isNotEmpty ? user.phone : "N/A",
                      ),
                    ),

                    if (listing != null)
                      InkWell(
                        onTap: listing.website != null &&
                                listing.website!.isNotEmpty
                            ? () => _openWebsite(listing.website!)
                            : null,
                        child: _detailRow("website", listing.website ?? "N/A"),
                      ),

                    _detailRow("GST", listing?.gstNumber ?? "N/A"),
                    _detailRow(
                      "No of Listings",
                      '', // pass from API / state
                    ),
                  ],

                  verticalMargin16,

                  InkWell(
                    onTap: () {
                      shareService(listing: listing!);
                    },
                    child: Container(
                      padding: horizontalPadding4 + verticalPadding8,
                      color: greyButttonColor,
                      child: Row(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            size: 19,
                            color: lightGreyTextColor,
                          ),
                          horizontalMargin8,
                          Expanded(
                            child: Text(
                              "Share Now",
                              style: context.labelMedium.copyWith(
                                fontWeight: FontWeight.w400,
                                color: lightGreyTextColor,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            AppAssets.iconWhatsAppSvg,
                            height: 26,
                            colorFilter: ColorFilter.mode(
                              lightGreyTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalMargin16,
                  Container(
                    padding: allPadding16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Location",
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        verticalMargin12,
                        LocationMapWidget(
                          latitude: listing?.latitude,
                          longitude: listing?.longitude,
                          address: listing?.address ?? '',
                        ),
                      ],
                    ),
                  ),
                  verticalMargin24,
                  IncludesDropdown(includes: listing?.includes),
                  verticalMargin24,
                  videoChild,
                  FaqSection(faqs: listing?.faqs),
                  verticalMargin24,
                  ReviewsWidget(
                    listing: listing!,
                    onReviewAdded: () {
                      _listingBloc.add(LoadListingDetail(listing.id.toString()));
                    },
                  ),

                  verticalMargin24,
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ListingBloc, ListingState>(
        bloc: _listingBloc,
        builder: (context, state) {
          if (state.selectedListing == null) {
            return SizedBox.shrink();
          }
          return SafeArea(
            bottom: true,
            child: Padding(
              padding: horizontalPadding16,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .end,
                children: [
                  GradientButton(
                    text: "Send Enquiry",
                    onTap: () {
                      if (state.selectedListing != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ContactSupplierPopup(
                              listing: state.selectedListing!,
                            ),
                          ),
                        );
                      }
                    },
                    iconWithTitle: Icon(
                      Icons.email_outlined,
                      color: whiteColor,
                    ),
                    showIconFirst: true,
                  ),
                  verticalMargin8,
                  GradientButton(
                    text: "Book Service",
                    onTap: () async {
                      final isLoggedIn =
                          await sl<ISecureStore>().read("isLoggedIn") == "true";
                      if (isLoggedIn) {
                        context.pushNamed(
                          AppRouterNames.customerSelectBookingLocation,
                          pathParameters: {
                            "listingId": state.selectedListing!.id.toString(),
                          },
                        );
                      } else {
                        context.pushNamed(
                          AppRouterNames.contactSupplier,
                          pathParameters: {
                            "listingId": state.selectedListing!.id.toString(),
                          },
                        );
                      }
                    },
                    padding: verticalPadding16,
                    iconWithTitle: Icon(
                      Icons.shopping_bag_rounded,
                      color: whiteColor,
                    ),
                    showIconFirst: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class IncludesDropdown extends StatefulWidget {
  const IncludesDropdown({super.key, this.includes});

  final List<Include>? includes;

  @override
  State<IncludesDropdown> createState() => _IncludesDropdownState();
}

class _IncludesDropdownState extends State<IncludesDropdown> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.includes == null || widget.includes!.isEmpty) {
      return emptyBox;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          maintainState: true,
          initiallyExpanded: isExpanded,

          // custom trailing icon that reflects expansion state
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black87,
          ),

          onExpansionChanged: (expanded) {
            setState(() => isExpanded = expanded);
          },

          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          title: Text("Includes", style: context.bodySmall),

          children: [
            Container(
              padding: allPadding16,
              decoration: BoxDecoration(
                color: offWhiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: widget.includes!
                    .map(
                      (include) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                include.title,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceVideoDropDown extends StatefulWidget {
  final String videoUrl;

  const ServiceVideoDropDown({required this.videoUrl, super.key});

  @override
  State<ServiceVideoDropDown> createState() => _ServiceVideoDropDownState();
}

class _ServiceVideoDropDownState extends State<ServiceVideoDropDown>
    with AutomaticKeepAliveClientMixin {
  late final YoutubePlayerController _controller;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 3)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          maintainState: true,
          onExpansionChanged: (value) {
            setState(() => _expanded = value);
            if (!value) _controller.pause();
          },
          title: Text("Video", style: Theme.of(context).textTheme.bodySmall),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            if (_expanded)
              Container(
                height: 270,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  ),
                  builder: (context, player) {
                    return player;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FaqSection extends StatefulWidget {
  const FaqSection({super.key, this.faqs});

  final List<Faq>? faqs;

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  late List<bool> expandedStates;

  @override
  void initState() {
    super.initState();
    expandedStates = List.filled(widget.faqs?.length ?? 0, false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final faqs = widget.faqs ?? [];

    if (faqs.isEmpty) {
      return const Center(child: Text("No FAQs available"));
    }

    return Column(
      children: List.generate(faqs.length, (index) {
        final isExpanded = expandedStates[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                initiallyExpanded: isExpanded,
                trailing: Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  size: 24,
                  color: Colors.black,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    expandedStates[index] = expanded;
                  });
                },
                title: Text(
                  faqs[index].question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Text(
                    faqs[index].answer,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ReviewBuilder extends StatelessWidget {
  final double rating;
  final int totalReviews;
  
  const ReviewBuilder({
    super.key,
    this.rating = 0,
    this.totalReviews = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber),
        horizontalMargin4,
        Text.rich(
          style: context.labelMedium,
          TextSpan(
            text: "${rating.toStringAsFixed(1)} ",
            children: [
              TextSpan(
                text: "($totalReviews reviews)",
                style: context.labelMedium.copyWith(color: lightGreyTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewsWidget extends StatefulWidget {
  final Listing listing;
  final VoidCallback? onReviewAdded;

  const ReviewsWidget({super.key, required this.listing, this.onReviewAdded});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  bool loadMore = false;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.listing.reviews;
    final visibleReviews = loadMore ? reviews : reviews.take(3).toList();
    final breakdown = widget.listing.reviewsBreakdown;
    final totalReviews = widget.listing.totalRatings;
    
    // Calculate percentages for rating bars
    double getPercent(int count) {
      if (totalReviews == 0) return 0;
      return count / totalReviews;
    }

    // Build star icons based on rating
    Widget buildStars(double rating) {
      final fullStars = rating.floor();
      final hasHalfStar = (rating - fullStars) >= 0.5;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          if (i < fullStars) {
            return const Icon(Icons.star, color: Colors.amber, size: 18);
          } else if (i == fullStars && hasHalfStar) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 18);
          } else {
            return Icon(Icons.star, color: Colors.grey.shade300, size: 18);
          }
        }),
      );
    }

    return Container(
      padding: allPadding16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reviews ($totalReviews)"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: horizontalPadding12 + verticalPadding4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: sl<ReviewsCubit>(),
                      child: AddReviewPopup(serviceId: widget.listing.id),
                    ),
                  );
                  if (result == true) {
                    widget.onReviewAdded?.call();
                  }
                },
                child: Text(
                  "Write a Review",
                  style: context.labelSmall.copyWith(color: whiteColor),
                ),
              ),
            ],
          ),
          verticalMargin16,
          Container(
            padding: verticalPadding24,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "Customer Reviews & Ratings",
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                buildStars(widget.listing.overAllRating),
                verticalMargin8,
                Text(
                  "(${widget.listing.overAllRating.toStringAsFixed(1)} out of 5.0)",
                  style: context.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: lightGreyTextColor,
                  ),
                ),
                verticalMargin12,
                Text(
                  "Based On $totalReviews Reviews",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          verticalMargin12,
          // Dynamic rating breakdown
          _ratingRow(
            context,
            "5 Star Ratings",
            getPercent(breakdown?.fiveStar ?? 0),
            "${breakdown?.fiveStar ?? 0}",
          ),
          _ratingRow(
            context,
            "4 Star Ratings",
            getPercent(breakdown?.fourStar ?? 0),
            "${breakdown?.fourStar ?? 0}",
          ),
          _ratingRow(
            context,
            "3 Star Ratings",
            getPercent(breakdown?.threeStar ?? 0),
            "${breakdown?.threeStar ?? 0}",
          ),
          _ratingRow(
            context,
            "2 Star Ratings",
            getPercent(breakdown?.twoStar ?? 0),
            "${breakdown?.twoStar ?? 0}",
          ),
          _ratingRow(
            context,
            "1 Star Ratings",
            getPercent(breakdown?.oneStar ?? 0),
            "${breakdown?.oneStar ?? 0}",
          ),
          verticalMargin16,

          if (reviews.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: Text("No reviews yet")),
            ),
          ] else ...[
            ...visibleReviews.map(
              (review) => ReviewCardListing(
                review: review,
                onReviewUpdated: widget.onReviewAdded,
              ),
            ),
            if (reviews.length > 3) ...[
              verticalMargin12,
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greyButttonColor,
                    padding: verticalPadding8 + horizontalPadding12,
                  ),
                  onPressed: () {
                    setState(() {
                      loadMore = !loadMore;
                    });
                  },
                  child: Text(
                    loadMore ? "Show Less" : "Load More (${reviews.length - 3} more)",
                    style: context.labelSmall,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _ratingRow(
    BuildContext context,
    String label,
    double percent,
    String count,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.labelSmall.copyWith(
                color: lightGreyTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          horizontalMargin8,
          Expanded(
            flex: 4,
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.grey.shade300,
              color: Colors.amber,
              minHeight: 8,
            ),
          ),
          horizontalMargin8,
          SizedBox(
            width: 40,
            child: Text(
              count,
              style: context.labelMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class LocationMapWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String address;

  const LocationMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    if (address.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: greyButttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Location not available',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return GestureDetector(
      onTap: _openInMaps,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 220,
          child: Stack(
            children: [
              // Map placeholder with address
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Stack(
                  children: [
                    // Use a network image of the map
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: _getStaticMapUrl(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 48, color: Colors.red),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  address,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to view on map',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Map pin overlay
                    const Center(
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              // Address bar at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions, size: 16, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Directions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStaticMapUrl() {
    // Using OpenStreetMap static map service (free, no API key)
    if (latitude != null && longitude != null && latitude != 0.0 && longitude != 0.0) {
      return 'https://staticmap.openstreetmap.de/staticmap.php?center=$latitude,$longitude&zoom=15&size=600x300&maptype=mapnik';
    }
    // Fallback: use nominatim to geocode address
    final encodedAddress = Uri.encodeComponent(address);
    return 'https://staticmap.openstreetmap.de/staticmap.php?center=$encodedAddress&zoom=15&size=600x300&maptype=mapnik';
  }

  Future<void> _openInMaps() async {
    String url;
    if (latitude != null && longitude != null && latitude != 0.0 && longitude != 0.0) {
      url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else {
      url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    }
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
