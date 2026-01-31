import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/location_service.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';
import 'package:grow_first/features/categories/presentation/widgets/sub_categories_pop_up.dart';
import 'package:grow_first/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grow_first/features/home/presentation/bloc/service_sections_bloc.dart';
import 'package:grow_first/features/home/presentation/static_design.dart';
import 'package:grow_first/features/home/presentation/widgets/home_page_banners.dart';
import 'package:grow_first/features/home/presentation/widgets/home_service_section.dart';
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

        // ServiceSectionsBloc
        BlocProvider<ServiceSectionsBloc>(
          create: (_) => sl<ServiceSectionsBloc>()..add(LoadAllServiceSections()),
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
  final LocationService _locationService = LocationService();
  
  String _city = "Fetching...";
  String _address = "Getting your location";
  bool _isLoadingLocation = true;
  LocationStatus? _locationStatus;
  
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
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isLoadingLocation = true);
    
    final status = await _locationService.checkAndRequestPermission();
    _locationStatus = status;
    
    if (status == LocationStatus.granted) {
      final location = await _locationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          if (location != null) {
            _city = location.city;
            _address = location.pincode.isNotEmpty 
                ? "${location.address}, ${location.pincode}"
                : location.address;
          } else {
            _city = "Location unavailable";
            _address = "Tap to retry";
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _city = "Location unavailable";
          _address = "Tap to enable location";
        });
      }
    }
  }

  Future<void> _handleLocationTap() async {
    if (_locationStatus == LocationStatus.granted) {
      // Already have permission, just refresh
      await _fetchLocation();
    } else if (_locationStatus == LocationStatus.serviceDisabled) {
      // Location service is off, open location settings
      await _locationService.openLocationSettings();
      // Retry after returning from settings
      await Future.delayed(const Duration(milliseconds: 500));
      await _fetchLocation();
    } else if (_locationStatus == LocationStatus.deniedForever) {
      // Permission permanently denied, open app settings
      await _locationService.openAppSettings();
      // Retry after returning from settings
      await Future.delayed(const Duration(milliseconds: 500));
      await _fetchLocation();
    } else {
      // Permission denied or not requested yet, request again
      await _fetchLocation();
    }
  }

  @override
  void dispose() {
    banner.dispose();
    super.dispose();
  }

  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ModernCustomerDrawer(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _openDrawer(context),
        ),
        title: GestureDetector(
          onTap: _handleLocationTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_city, style: context.labelSmall),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _isLoadingLocation ? "Getting your location" : _address,
                      style: context.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  horizontalMargin4,
                  Icon(Icons.arrow_right_sharp),
                ],
              ),
            ],
          ),
        ),
        actions: [
          horizontalMargin12,
          IconButton.filled(
            icon: Icon(Icons.search),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(lightGreyColor),
            ),
            onPressed: () {
              context.push('/search');
            },
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
                      // Container(
                      //   height: 50,
                      //   width: double.infinity,
                      //   child: AdWidget(ad: banner),
                      // ),
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate tile width to fit exactly 3 tiles with spacing
                            final screenWidth = MediaQuery.sizeOf(context).width;
                            final horizontalPadding = 6.0; // horizontalPadding3 = 3 on each side
                            final availableWidth = screenWidth - horizontalPadding;
                            final spacing = 12.0;
                            final tileWidth = (availableWidth - (spacing * 2)) / 3;
                            
                            return ListView.separated(
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
                                  child: SizedBox(
                                    width: tileWidth,
                                    child: CategoryTile(
                                      category: state.categories[index],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  horizontalMargin12,
                              itemCount: state.categories.length > 25
                                  ? 25
                                  : state.categories.length,
                            );
                          },
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
            // Recent Searches Section - Hidden for now
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Recent Searches",
            //       style: context.bodyMedium.copyWith(
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.keyboard_arrow_right_sharp,
            //         color: Color(0XFF7D8FAB),
            //         size: 32,
            //       ),
            //     ),
            //   ],
            // ),
            // verticalMargin12,
            // SizedBox(
            //   height: min(115, MediaQuery.sizeOf(context).height * 0.18),
            //   child: BlocBuilder<HomePageBloc, HomePageState>(
            //     builder: (context, state) {
            //       if (state is HomePageLoaded &&
            //           state.recentSearches.isNotEmpty) {
            //         return SizedBox(
            //           height: min(
            //             115,
            //             MediaQuery.sizeOf(context).height * 0.18,
            //           ),
            //           child: ListView.separated(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: state.recentSearches.length,
            //             separatorBuilder: (_, __) => horizontalMargin12,
            //             itemBuilder: (context, index) {
            //               final item = state.recentSearches[index];
            //               final imageUrl = item.image != null
            //                   ? "https://growfirst.org/${item.image}"
            //                   : "https://via.placeholder.com/300";
            //
            //               return Container(
            //                 width: MediaQuery.sizeOf(context).width / 3.5,
            //                 padding: verticalPadding8,
            //                 decoration: BoxDecoration(
            //                   image: DecorationImage(
            //                     image: CachedNetworkImageProvider(imageUrl),
            //                     fit: BoxFit.cover,
            //                   ),
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //                 child: Align(
            //                   alignment: Alignment.bottomCenter,
            //                   child: Text(
            //                     item.title ?? '',
            //                     maxLines: 1,
            //                     overflow: TextOverflow.ellipsis,
            //                     style: context.bodySmall.copyWith(
            //                       color: whiteColor,
            //                       fontWeight: FontWeight.w400,
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       }
            //       return emptyBox;
            //     },
            //   ),
            // ),
            verticalMargin16,
            // 6 Service Sections
            BlocBuilder<ServiceSectionsBloc, ServiceSectionsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // Featured Services
                    HomeServiceSection(
                      title: "Our Featured Services",
                      serviceType: "featured",
                      services: state.featuredServices,
                      isLoading: state.isLoading,
                    ),

                    // Popular Services
                    HomeServiceSection(
                      title: "Popular Services",
                      serviceType: "popular",
                      services: state.popularServices,
                      isLoading: state.isLoading,
                    ),

                    // Emergency Services
                    HomeServiceSection(
                      title: "Emergency Services",
                      serviceType: "emergency",
                      services: state.emergencyServices,
                      isLoading: state.isLoading,
                    ),

                    // Newly Onboarded
                    HomeServiceSection(
                      title: "Newly Onboarded",
                      serviceType: "newly_onboarded",
                      services: state.newlyOnboardedServices,
                      isLoading: state.isLoading,
                    ),

                    // Recommended for You
                    HomeServiceSection(
                      title: "Recommended for You",
                      serviceType: "recommended",
                      services: state.recommendedServices,
                      isLoading: state.isLoading,
                    ),

                    // Seasonal / Festive Services
                    HomeServiceSection(
                      title: "Seasonal / Festive Services",
                      serviceType: "seasonal",
                      services: state.seasonalServices,
                      isLoading: state.isLoading,
                    ),
                  ],
                );
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
