import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/listing/domain/usecases/params/listing_param.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/listing/presentation/widgets/listing_tile.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key, this.categoryId, this.subcategoryId});

  final String? categoryId;
  final String? subcategoryId;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    sl.get<ListingBloc>().add(
      LoadListings(
        GetListingsParams(
          categories: widget.categoryId != null
              ? [int.tryParse(widget.categoryId ?? "") ?? 0]
              : [],
          subcategory: widget.subcategoryId != null
              ? int.tryParse(widget.subcategoryId ?? "")
              : null,
          page: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget get _mainContent {
    return BlocBuilder<ListingBloc, ListingState>(
      bloc: sl.get<ListingBloc>(),
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        } else if (state.listings.isEmpty) {
          return Expanded(
            child: Center(
              child: Text("No listings found", style: context.labelLarge),
            ),
          );
        }
        return Expanded(
          child: isGridView
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.54,
                    crossAxisSpacing: 21,
                    mainAxisSpacing: 21,
                  ),
                  itemCount: state.listings.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRouterNames.listingDetail,
                        pathParameters: {
                          "listingId": state.listings[index].id.toString(),
                        },
                      );
                    },
                    child: ListingTile(
                      isGridView: true,
                      listing: state.listings[index],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: state.listings.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListingTile(
                      isGridView: false,
                      listing: state.listings[index],
                    ),
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(
        singleTitle: "Listing",
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isGridView = true);
            },
            icon: Icon(
              Icons.grid_view_outlined,
              size: 28,
              color: isGridView ? aquaBlueColor : null,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => isGridView = false);
            },
            icon: Icon(
              Icons.list,
              size: 35,
              color: !isGridView ? aquaBlueColor : null,
            ),
          ),
          horizontalMargin8,
        ],
      ),
      body: Padding(
        padding: horizontalPadding16 + verticalPadding16,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            BlocBuilder<ListingBloc, ListingState>(
              bloc: sl.get<ListingBloc>(),
              builder: (context, state) {
                return Text.rich(
                  TextSpan(
                    text: "Found | ",
                    children: [
                      TextSpan(
                        text: "${state.totalNumberOfListings} Services",
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          color: lightGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            verticalMargin12,
            _mainContent,
            verticalMargin8,
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: "Sort",
                    onTap: () {
                      context.pushNamed(AppRouterNames.listingsFilters);
                    },
                    hideGradient: true,
                    iconWithTitle: Icon(Icons.swap_vert, size: 20),
                    borderRadius: 6,
                    backgroundColor: greyButttonColor,
                    textStyle: context.labelMedium,
                  ),
                ),
                horizontalMargin12,
                Expanded(
                  child: GradientButton(
                    text: "Filter",
                    onTap: () {},
                    iconWithTitle: Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                      color: whiteColor,
                    ),
                    borderRadius: 6,
                    textStyle: context.labelMedium.copyWith(color: whiteColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
