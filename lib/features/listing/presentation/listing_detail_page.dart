import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/domain/entities/listing.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/listing/presentation/widgets/send_enquiry_pop_up.dart';
import 'package:grow_first/features/reviews/presentation/widgets/review_card_listing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListingDetailPage extends StatefulWidget {
  const ListingDetailPage({super.key, required this.listingId});

  final String listingId;

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  @override
  void initState() {
    super.initState();
    sl.get<ListingBloc>().add(LoadListingDetail(widget.listingId));
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
📞 Phone: ${listing.user.phone}

View details:
https://growfirst.org/service/${listing.slug}
''';

    SharePlus.instance.share(
      ShareParams(text: text, subject: 'Check out this service on GrowFirst!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomerHomeAppBar(singleTitle: "Detail"),
      body: BlocBuilder<ListingBloc, ListingState>(
        bloc: sl.get<ListingBloc>(),
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
                            "https://growfirst.org/storage/${listing?.gallery.first.img}",
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
                                    "https://growfirst.org/storage/${url}",
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
                      ReviewBuilder(),
                    ],
                  ),
                  verticalMargin16,
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        "Pune",
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
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          "${listing?.user.companyName}",
                          style: context.bodyMedium.copyWith(
                            color: lightGreyTextColor,
                          ),
                        ),
                        verticalMargin8,
                        ReviewBuilder(),
                      ],
                    ),
                  ),
                  verticalMargin16,
                  if (user != null) ...[
                    _detailRow("Member Since", formatDate(user.createdAt)),
                    _detailRow(
                      "Address",
                      user.address.isNotEmpty ? user.address : "N/A",
                    ),
                    _detailRow(
                      "Email",
                      user.email.isNotEmpty ? user.email : "N/A",
                    ),
                    _detailRow(
                      "Phone",
                      user.phone.isNotEmpty ? user.phone : "N/A",
                    ),
                    _detailRow("GST", listing?.gstNumber ?? "N/A"),
                    _detailRow(
                      "No of Listings",
                      '', // pass from API / state
                    ),
                  ],

                  verticalMargin16,
                  verticalMargin2,
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
                      crossAxisAlignment: .stretch,
                      children: [
                        Text(
                          "Location",
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        verticalMargin12,
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: greyButttonColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                  ReviewsWidget(),
                  verticalMargin24,
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ListingBloc, ListingState>(
        bloc: sl.get<ListingBloc>(),
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
                      final isLoggedIn = await sl<ISecureStore>().read("isLoggedIn") == "true";
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
  const ReviewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        const Icon(Icons.star, color: Colors.amber),
        horizontalMargin4,
        Text.rich(
          style: context.labelMedium,
          TextSpan(
            text: "4.9 ",
            children: [
              TextSpan(
                text: "(255 reviews)",
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
  const ReviewsWidget({super.key});

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  bool loadMore = false;

  @override
  Widget build(BuildContext context) {
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
              Text(
                "Reviews (45)",
                style: context.bodySmall.copyWith(fontWeight: FontWeight.w700),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: horizontalPadding12 + verticalPadding4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                  ],
                ),
                verticalMargin8,
                Text(
                  "(4.9 out of 5.0)",
                  style: context.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: lightGreyTextColor,
                  ),
                ),
                verticalMargin12,
                Text(
                  "Based On 2,459 Reviews",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          verticalMargin12,
          _ratingRow(context, "5 Star Ratings", 0.9, "2,547"),
          _ratingRow(context, "4 Star Ratings", 0.75, "1,245"),
          _ratingRow(context, "3 Star Ratings", 0.5, "600"),
          _ratingRow(context, "2 Star Ratings", 0.45, "560"),
          _ratingRow(context, "1 Star Ratings", 0.3, "400"),
          verticalMargin8,
          if (loadMore) ...[
            ...List.generate(7, (index) => ReviewCardListing()),
          ] else ...[
            ReviewCardListing(),
            verticalMargin12,
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greyButttonColor,
                  minimumSize: Size(0, 0),
                  padding: verticalPadding8 + horizontalPadding12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    loadMore = !loadMore;
                  });
                },
                child: Text("Load More", style: context.labelSmall),
              ),
            ),
          ],
          verticalMargin8,
          if (loadMore) ...[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greyButttonColor,
                  minimumSize: Size(0, 0),
                  padding: verticalPadding8 + horizontalPadding12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    loadMore = !loadMore;
                  });
                },
                child: Text("Show Less", style: context.labelSmall),
              ),
            ),
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
              value: percent,
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.grey.shade300,
              color: Colors.amber,
              minHeight: 8,
            ),
          ),
          horizontalMargin8,
          Expanded(
            flex: 1,
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
