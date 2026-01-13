import 'dart:developer' as developer;

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
  const ListingPage({
    super.key,
    this.categoryId,
    this.subcategoryId,
    this.serviceType,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? serviceType;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  bool isGridView = true;
  late final ListingBloc _listingBloc;

  @override
  void initState() {
    super.initState();
    developer.log(
      'ListingPage.initState -> categoryId=${widget.categoryId}, subcategoryId=${widget.subcategoryId}, serviceType=${widget.serviceType}',
      name: 'ListingPage',
    );
    _listingBloc = sl<ListingBloc>();
    developer.log(
      'ListingPage.initState -> obtained ListingBloc hash=${_listingBloc.hashCode}',
      name: 'ListingPage',
    );
    _listingBloc.add(
      LoadListings(
        GetListingsParams(
          categories: widget.categoryId != null
              ? [int.tryParse(widget.categoryId ?? "") ?? 0]
              : null,
          subcategory: widget.subcategoryId != null
              ? int.tryParse(widget.subcategoryId ?? "")
              : null,
          serviceType: widget.serviceType,
          page: 1,
        ),
      ),
    );
    developer.log(
      'ListingPage.initState -> LoadListings event dispatched',
      name: 'ListingPage',
    );
  }

  @override
  void dispose() {
    _listingBloc.close();
    super.dispose();
  }

  Widget get _mainContent {
    return BlocBuilder<ListingBloc, ListingState>(
      bloc: _listingBloc,
      builder: (context, state) {
        developer.log(
          'ListingPage._mainContent -> builder invoked | isLoading=${state.isLoading} | total=${state.totalNumberOfListings} | listingsLen=${state.listings.length} | error=${state.error}',
          name: 'ListingPage',
        );
        if (state.isLoading) {
          developer.log(
            'ListingPage._mainContent -> showing loader',
            name: 'ListingPage',
          );
          return Expanded(child: Center(child: CircularProgressIndicator()));
        } else if (state.listings.isEmpty) {
          developer.log(
            'ListingPage._mainContent -> listings empty, showing empty state',
            name: 'ListingPage',
          );
          return Expanded(
            child: Center(
              child: Text("No listings found", style: context.labelLarge),
            ),
          );
        }
        developer.log(
          'ListingPage._mainContent -> rendering ${state.listings.length} items in ${isGridView ? "grid" : "list"} mode',
          name: 'ListingPage',
        );
        return Expanded(
          child: isGridView
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
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
    return BlocProvider<ListingBloc>.value(
      value: _listingBloc,
      child: Scaffold(
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
          padding: horizontalPadding3 + horizontalPadding3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ListingBloc, ListingState>(
                bloc: _listingBloc,
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
                      textStyle: context.labelMedium.copyWith(
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
