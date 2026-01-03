import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';
import 'package:grow_first/features/categories/presentation/widgets/sub_categories_pop_up.dart';
import 'package:grow_first/features/home/presentation/bloc/home_page_bloc.dart';
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

  @override
  void initState() {
    super.initState();
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
          IconButton.filled(
            icon: Icon(Icons.notifications_rounded),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(lightGreyColor),
            ),
            onPressed: () {},
          ),
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
        padding: horizontalPadding16,
        child: ListView(
          key: _pageKey,
          children: [
            verticalMargin24,
            BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return AppShimmer();
                } else if (state is HomePageLoaded) {
                  return HomePageBanners(
                    height: context.height * 0.22,
                    images: List.generate(state.bannerImages.length, (index) {
                      return "${sl<AppConfig>().imageBaseUrl}/uploads/${state.bannerImages[index]}";
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
                                final categoryBloc = context.read<CategoryBloc>();
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
                                      child: SubCategoriesPopUp(
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width / 3.5,
                    padding: verticalPadding8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          "https://images.unsplash.com/photo-1756567579726-ff8c0f14b77a?q=80&w=3175&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: AlignmentGeometry.bottomCenter,
                      child: Text(
                        "Dentist",
                        style: context.bodySmall.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => horizontalMargin12,
                itemCount: 4,
              ),
            ),
            verticalMargin32,
            verticalMargin32,
            verticalMargin32,
          ],
        ),
      ),
    );
  }
}
