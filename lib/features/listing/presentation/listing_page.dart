import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/listing/domain/entities/listing_filter_params.dart';
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
    this.keyword,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? serviceType;
  final String? keyword;

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  bool isGridView = true;
  late final ListingBloc _listingBloc;
  late final ScrollController _scrollController;
  ListingFilterParams _currentFilters = const ListingFilterParams();
  String? _currentSortBy;

  @override
  void initState() {
    super.initState();
    developer.log(
      'ListingPage.initState -> categoryId=${widget.categoryId}, subcategoryId=${widget.subcategoryId}, serviceType=${widget.serviceType}, keyword=${widget.keyword}',
      name: 'ListingPage',
    );
    _listingBloc = sl<ListingBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Initialize filters from route parameters
    final categoryId = int.tryParse(widget.categoryId ?? "");
    final subcategoryId = int.tryParse(widget.subcategoryId ?? "");

    _currentFilters = ListingFilterParams(
      selectedCategories: categoryId != null ? [categoryId] : [],
      selectedSubcategories: subcategoryId != null ? [subcategoryId] : [],
      keyword: widget.keyword,
    );

    _listingBloc.add(const LoadAboutUsBanners());
    _loadListings();
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreListings();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  GetListingsParams _buildParams({int page = 1}) {
    return GetListingsParams(
      categories: _currentFilters.selectedCategories.isNotEmpty
          ? _currentFilters.selectedCategories
          : null,
      subcategory: _currentFilters.selectedSubcategories.isNotEmpty
          ? _currentFilters.selectedSubcategories.first
          : null,
      keyword: _currentFilters.keyword,
      location: _currentFilters.location,
      minPrice: _currentFilters.minPrice?.toInt(),
      maxPrice: _currentFilters.maxPrice?.toInt(),
      sort: _currentSortBy ?? _currentFilters.sortBy,
      ratings: _currentFilters.selectedRatings.isNotEmpty
          ? _currentFilters.selectedRatings
          : null,
      serviceType: widget.serviceType,
      page: page,
      perPage: 10,
    );
  }

  void _loadListings() {
    final params = _buildParams(page: 1);
    developer.log(
      'ListingPage._loadListings -> params: ${params.toQuery()}',
      name: 'ListingPage',
    );
    _listingBloc.add(LoadListings(params));
  }

  void _loadMoreListings() {
    final params = _buildParams();
    _listingBloc.add(LoadMoreListings(params));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _listingBloc.close();
    super.dispose();
  }

  void _openFilters() async {
    final result = await context.pushNamed<ListingFilterParams>(
      AppRouterNames.listingsFilters,
      extra: _currentFilters,
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
      });
      _loadListings();
    }
  }

  void _openSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SortBottomSheet(
        currentSort: _currentSortBy ?? _currentFilters.sortBy,
        onSortSelected: (sortBy) {
          setState(() {
            _currentSortBy = sortBy;
          });
          _loadListings();
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters = const ListingFilterParams();
      _currentSortBy = null;
    });
    _loadListings();
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
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (state.error != null) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  verticalMargin16,
                  Text(
                    "Something went wrong",
                    style: context.labelLarge,
                  ),
                  verticalMargin8,
                  TextButton(
                    onPressed: _loadListings,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }
        
        if (state.listings.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: lightGreyTextColor,
                  ),
                  verticalMargin16,
                  Text("No listings found", style: context.labelLarge),
                  if (_currentFilters.hasActiveFilters ||
                      _currentSortBy != null) ...[
                    verticalMargin8,
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text("Clear Filters"),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: isGridView ? _buildGridView(state) : _buildListView(state),
        );
      },
    );
  }

  Widget _buildGridView(ListingState state) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: state.listings.length + (state.hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.listings.length) {
          return _buildLoadMoreIndicator(state);
        }
        return ListingTile(
          isGridView: true,
          listing: state.listings[index],
        );
      },
    );
  }

  Widget _buildListView(ListingState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.listings.length + (state.hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.listings.length) {
          return _buildLoadMoreIndicator(state);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                AppRouterNames.listingDetail,
                pathParameters: {
                  "listingId": state.listings[index].id.toString(),
                },
              );
            },
            child: ListingTile(
              isGridView: false,
              listing: state.listings[index],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreIndicator(ListingState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: state.isLoadingMore
          ? const CircularProgressIndicator()
          : TextButton(
              onPressed: _loadMoreListings,
              child: const Text("Load More"),
            ),
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
                context.push('/search');
              },
              icon: const Icon(Icons.search, size: 26),
            ),
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
                  if (state.banners.isEmpty) return const SizedBox();
                  return SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.banners.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              state.banners[index],
                              width: 397,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<ListingBloc, ListingState>(
                bloc: _listingBloc,
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
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
                      ),
                      if (_currentFilters.hasActiveFilters ||
                          _currentSortBy != null)
                        TextButton.icon(
                          onPressed: _clearAllFilters,
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text("Clear"),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  );
                },
              ),
              // Active filters chips
              if (_currentFilters.hasActiveFilters ||
                  _currentSortBy != null) ...[
                verticalMargin8,
                _buildActiveFiltersChips(),
              ],
              verticalMargin12,
              _mainContent,
              verticalMargin8,
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      text: _currentSortBy != null ? "Sorted" : "Sort",
                      onTap: _openSortOptions,
                      hideGradient: true,
                      iconWithTitle: Icon(
                        Icons.swap_vert,
                        size: 20,
                        color: _currentSortBy != null ? aquaBlueColor : null,
                      ),
                      borderRadius: 6,
                      backgroundColor: greyButttonColor,
                      textStyle: context.labelMedium.copyWith(
                        color: _currentSortBy != null ? aquaBlueColor : null,
                      ),
                    ),
                  ),
                  horizontalMargin12,
                  Expanded(
                    child: Stack(
                      children: [
                        GradientButton(
                          text: "Filter",
                          onTap: _openFilters,
                          iconWithTitle: const Icon(
                            Icons.filter_alt_outlined,
                            size: 20,
                            color: whiteColor,
                          ),
                          borderRadius: 6,
                          textStyle: context.labelMedium.copyWith(
                            color: whiteColor,
                          ),
                        ),
                        if (_currentFilters.activeFilterCount > 0)
                          Positioned(
                            right: 8,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${_currentFilters.activeFilterCount}",
                                style: context.labelSmall.copyWith(
                                  color: whiteColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildActiveFiltersChips() {
    final chips = <Widget>[];

    if (_currentFilters.keyword != null &&
        _currentFilters.keyword!.isNotEmpty) {
      chips.add(_buildFilterChip(
        'Search: ${_currentFilters.keyword}',
        () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(clearKeyword: true);
          });
          _loadListings();
        },
      ));
    }

    if (_currentFilters.location != null &&
        _currentFilters.location!.isNotEmpty) {
      chips.add(_buildFilterChip(
        'Location: ${_currentFilters.location}',
        () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(clearLocation: true);
          });
          _loadListings();
        },
      ));
    }

    if (_currentFilters.minPrice != null || _currentFilters.maxPrice != null) {
      final priceText = _currentFilters.minPrice != null &&
              _currentFilters.maxPrice != null
          ? '₹${_currentFilters.minPrice!.toInt()} - ₹${_currentFilters.maxPrice!.toInt()}'
          : _currentFilters.minPrice != null
              ? 'Min: ₹${_currentFilters.minPrice!.toInt()}'
              : 'Max: ₹${_currentFilters.maxPrice!.toInt()}';
      chips.add(_buildFilterChip(
        priceText,
        () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(
              clearMinPrice: true,
              clearMaxPrice: true,
            );
          });
          _loadListings();
        },
      ));
    }

    if (_currentFilters.selectedCategories.isNotEmpty) {
      chips.add(_buildFilterChip(
        '${_currentFilters.selectedCategories.length} Categories',
        () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(selectedCategories: []);
          });
          _loadListings();
        },
      ));
    }

    if (_currentFilters.selectedSubcategories.isNotEmpty) {
      chips.add(_buildFilterChip(
        '${_currentFilters.selectedSubcategories.length} Subcategories',
        () {
          setState(() {
            _currentFilters =
                _currentFilters.copyWith(selectedSubcategories: []);
          });
          _loadListings();
        },
      ));
    }

    if (_currentFilters.selectedRatings.isNotEmpty) {
      chips.add(_buildFilterChip(
        '${_currentFilters.selectedRatings.length} Ratings',
        () {
          setState(() {
            _currentFilters = _currentFilters.copyWith(selectedRatings: []);
          });
          _loadListings();
        },
      ));
    }

    if (_currentSortBy != null) {
      chips.add(_buildFilterChip(
        'Sort: ${_getSortLabel(_currentSortBy!)}',
        () {
          setState(() {
            _currentSortBy = null;
          });
          _loadListings();
        },
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'low_to_high':
        return 'Low to High';
      case 'high_to_low':
        return 'High to Low';
      case 'newest':
        return 'Newest';
      case 'rating':
        return 'Top Rated';
      default:
        return sortBy;
    }
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: context.labelSmall.copyWith(color: aquaBlueColor),
        ),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: aquaBlueColor.withOpacity(0.1),
        deleteIconColor: aquaBlueColor,
        side: BorderSide(color: aquaBlueColor.withOpacity(0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _SortBottomSheet extends StatelessWidget {
  final String? currentSort;
  final Function(String?) onSortSelected;

  const _SortBottomSheet({
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort By",
            style: context.titleSmall.copyWith(fontWeight: FontWeight.w700),
          ),
          verticalMargin16,
          _buildSortOption(context, "Price: Low to High", "low_to_high"),
          _buildSortOption(context, "Price: High to Low", "high_to_low"),
          _buildSortOption(context, "Newest First", "newest"),
          _buildSortOption(context, "Top Rated", "rating"),
          if (currentSort != null) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text("Clear Sort"),
              onTap: () => onSortSelected(null),
            ),
          ],
          verticalMargin16,
        ],
      ),
    );
  }

  Widget _buildSortOption(BuildContext context, String label, String value) {
    final isSelected = currentSort == value;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? aquaBlueColor : null,
      ),
      title: Text(
        label,
        style: context.labelLarge.copyWith(
          color: isSelected ? aquaBlueColor : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () => onSortSelected(value),
    );
  }
}
