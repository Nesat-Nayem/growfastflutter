import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';
import 'package:grow_first/features/categories/presentation/widgets/sub_categories_pop_up.dart';
import 'package:grow_first/features/home/data/model/home_service_model.dart';
import 'package:grow_first/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grow_first/features/home/presentation/static_design.dart';
import 'package:grow_first/features/home/presentation/widgets/home_page_banners.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';
import 'package:grow_first/features/widgets/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HomePageBloc
        BlocProvider<HomePageBloc>(
          create: (_) => sl<HomePageBloc>()..add(LoadHomePage()),
        ),

        // CategoryBloc
        BlocProvider<CategoryBloc>(
          create: (_) => sl<CategoryBloc>()..add(LoadCategories()),
        ),
      ],
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final PageStorageKey _pageKey = PageStorageKey("customer-home-scroll");
  BannerAd banner = BannerAd(
    size: AdSize.banner,
    adUnitId: 'ca-app-pub-3940256099942544/9214589741',
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        print("banner is loading");
      },
      onAdFailedToLoad: (Ad ad, error) {
        print("failed to load $error");
        ad.dispose();
      },
    ),
    request: AdRequest(),
  );

  @override
  void initState() {
    super.initState();
    banner.load();
  }

  void dispose() {
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ModernCustomerDrawer(),
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Pune", style: context.labelSmall),
            Row(
              children: [
                Text("BTM Layout, 500628", style: context.labelSmall),
                horizontalMargin4,
                Icon(Icons.arrow_right_sharp),
              ],
            ),
          ],
        ),
        actions: [
          // IconButton.filled(
          //   icon: Icon(Icons.notifications_rounded),
          //   style: ButtonStyle(
          //     backgroundColor: WidgetStatePropertyAll(lightGreyColor),
          //   ),
          //   onPressed: () {},
          // ),
          horizontalMargin12,
          IconButton.filled(
            icon: Icon(Icons.search),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(lightGreyColor),
            ),
            onPressed: () {},
          ),
          horizontalMargin16,
        ],
      ),
      body: Padding(
        padding: horizontalPadding3,
        child: ListView(
          key: _pageKey,
          children: [
            verticalMargin8,
            BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return AppShimmer();
                } else if (state is HomePageLoaded) {
                  return HomePageBanners(
                    height: context.height * 0.22,
                    images: List.generate(state.bannerImages.length, (index) {
                      print("home banner api is :${state.bannerImages[index]}");
                      return "https://www.growfirst.org/${state.bannerImages[index]}";
                    }),
                  );
                }
                return emptyBox;
              },
            ),
            verticalMargin8,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: rightPadding16,
                          child: AppShimmer(
                            width: 120,
                            height: context.height * 0.11,
                          ),
                        );
                      }),
                    ),
                  );
                } else if (state.categories.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: AdWidget(ad: banner),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Explore our categories",
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.pushNamed(
                                AppRouterNames.exploreCategories,
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
                      verticalMargin12,
                      SizedBox(
                        height: min(
                          125,
                          MediaQuery.sizeOf(context).height * 0.17,
                        ),
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                final categoryBloc = context
                                    .read<CategoryBloc>();
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: "Dismiss",
                                  barrierColor: Colors.black54,
                                  transitionDuration: Duration(
                                    milliseconds: 300,
                                  ),
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                        return BlocProvider<CategoryBloc>.value(
                                          value: categoryBloc,
                                          child: SubCategoriesScreen(
                                            category: state.categories[index],
                                          ),
                                        );
                                      },
                                );
                              },
                              child: CategoryTile(
                                category: state.categories[index],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              horizontalMargin12,
                          itemCount: state.categories.length > 25
                              ? 25
                              : state.categories.length,
                        ),
                      ),
                    ],
                  );
                }
                return emptyBox;
              },
            ),
            verticalMargin24,
            SizedBox(
              height: 190,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://static.vecteezy.com/system/resources/previews/011/826/370/large_2x/maldives-islands-ocean-tropical-beach-exotic-sea-lagoon-palm-trees-over-white-sand-idyllic-nature-landscape-amazing-beach-scenic-shore-bright-tropical-summer-sun-and-blue-sky-with-light-clouds-photo.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  horizontalMargin12,
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://picsum.photos/seed/grow1/400/300",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        verticalMargin16,
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://picsum.photos/seed/grow2/400/300",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalMargin24,
            HomePageBanners(
              height: context.height * 0.20,
              images: [
                "https://picsum.photos/seed/blog1/800/400",
                "https://picsum.photos/seed/blog2/800/400",
                "https://picsum.photos/seed/blog3/800/400",
                "https://picsum.photos/seed/blog4/800/400",
                "https://picsum.photos/seed/blog5/800/400",
              ],
            ),
            verticalMargin8,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: Color(0XFF7D8FAB),
                    size: 32,
                  ),
                ),
              ],
            ),
            verticalMargin12,
            SizedBox(
              height: min(115, MediaQuery.sizeOf(context).height * 0.18),
              child: BlocBuilder<HomePageBloc, HomePageState>(
                builder: (context, state) {
                  if (state is HomePageLoaded &&
                      state.recentSearches.isNotEmpty) {
                    return SizedBox(
                      height: min(
                        115,
                        MediaQuery.sizeOf(context).height * 0.18,
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recentSearches.length,
                        separatorBuilder: (_, __) => horizontalMargin12,
                        itemBuilder: (context, index) {
                          final item = state.recentSearches[index];
                          final imageUrl = item.image != null
                              ? "https://growfirst.org/${item.image}"
                              : "https://via.placeholder.com/300";

                          return Container(
                            width: MediaQuery.sizeOf(context).width / 3.5,
                            padding: verticalPadding8,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                item!.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.bodySmall.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return emptyBox;
                },
              ),
            ),
            verticalMargin16,
            Column(
              children: [
                Text(
                  "Our Featured Services",
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalMargin8,
                Text(
                  "Highlighted services that bring you the best value and convenience.",
                  style: context.bodySmall.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            verticalMargin12,
            BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, __) =>
                          AppShimmer(width: 240, height: 160),
                      separatorBuilder: (_, __) => horizontalMargin12,
                      itemCount: 3,
                    ),
                  );
                }

                if (state is HomePageLoaded && state.services.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: min(10, state.services.length),
                          separatorBuilder: (_, __) => horizontalMargin12,
                          itemBuilder: (context, index) {
                            final service = state.services[index];

                            return _ServiceCard(service: service);
                          },
                        ),
                      ),
                    ],
                  );
                }

                return emptyBox;
              },
            ),

            verticalMargin16,
            HowItWorksSection(),
            verticalMargin32,
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final HomeServiceModel service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "${sl<AppConfig>().imageBaseUrl}/storage/${service.latestServiceImage}";

    print("image url is :$imageUrl");
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 115,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(height: 115, color: Colors.grey.shade200),
              errorWidget: (_, __, ___) => Container(
                height: 115,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "${service.serviceCount} Services",
                  style: context.labelSmall.copyWith(color: shipGreyColor1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
