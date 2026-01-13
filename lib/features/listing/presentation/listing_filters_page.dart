import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/domain/entities/category.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/listing/domain/entities/listing_filter_params.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_filter_cubit.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ListingFiltersPage extends StatefulWidget {
  final ListingFilterParams? initialFilters;

  const ListingFiltersPage({super.key, this.initialFilters});

  @override
  State<ListingFiltersPage> createState() => _ListingFiltersPageState();
}

class _ListingFiltersPageState extends State<ListingFiltersPage> {
  bool showMoreCategories = false;
  bool expandCategories = true;
  bool expandSubcategories = false;
  bool expandPriceRange = false;
  bool expandRating = false;
  bool expandSort = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  late ListingFilterCubit _filterCubit;
  late CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _filterCubit = ListingFilterCubit(widget.initialFilters);
    _categoryBloc = sl<CategoryBloc>();

    // Initialize text controllers with existing values
    if (widget.initialFilters != null) {
      _searchController.text = widget.initialFilters!.keyword ?? '';
      _locationController.text = widget.initialFilters!.location ?? '';
      if (widget.initialFilters!.minPrice != null) {
        _minPriceController.text =
            widget.initialFilters!.minPrice!.toStringAsFixed(0);
      }
      if (widget.initialFilters!.maxPrice != null) {
        _maxPriceController.text =
            widget.initialFilters!.maxPrice!.toStringAsFixed(0);
      }
    }

    // Load categories
    _categoryBloc.add(LoadCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _filterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _filterCubit),
        BlocProvider.value(value: _categoryBloc),
      ],
      child: Scaffold(
        appBar: CustomerHomeAppBar(
          singleTitle: "Filters",
          actions: [
            TextButton(
              onPressed: () {
                _filterCubit.clearAllFilters();
                _searchController.clear();
                _locationController.clear();
                _minPriceController.clear();
                _maxPriceController.clear();
              },
              child: Text(
                "Clear All",
                style: context.labelMedium.copyWith(color: aquaBlueColor),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalMargin8,
              Text(
                "Filters",
                style: context.titleSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              verticalMargin16,
              _buildSearchBox(),
              verticalMargin4,
              Divider(color: lightGreyColor),
              verticalMargin16,
              _buildCategorySection(),
              verticalMargin16,
              const Divider(height: 1, color: lightGreyColor),
              _buildSubcategorySection(),
              const Divider(height: 1, color: lightGreyColor),
              _buildLocationSection(),
              const Divider(height: 1, color: lightGreyColor),
              _buildPriceRangeSection(),
              const Divider(height: 1, color: lightGreyColor),
              _buildRatingSection(),
              const Divider(height: 1, color: lightGreyColor),
              _buildSortSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Padding(
            padding: bottomPadding12 + horizontalPadding16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<ListingFilterCubit, ListingFilterParams>(
                  bloc: _filterCubit,
                  builder: (context, filterState) {
                    return GradientButton(
                      text: filterState.hasActiveFilters
                          ? "Apply Filters (${filterState.activeFilterCount})"
                          : "Apply Filters",
                      onTap: () {
                        // Update keyword and location from text controllers
                        final keyword = _searchController.text.trim();
                        final location = _locationController.text.trim();
                        final minPrice =
                            double.tryParse(_minPriceController.text);
                        final maxPrice =
                            double.tryParse(_maxPriceController.text);

                        final finalFilters = filterState.copyWith(
                          keyword: keyword.isNotEmpty ? keyword : null,
                          location: location.isNotEmpty ? location : null,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          clearKeyword: keyword.isEmpty,
                          clearLocation: location.isEmpty,
                          clearMinPrice: minPrice == null,
                          clearMaxPrice: maxPrice == null,
                        );

                        context.pop(finalFilters);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0XFFEFF1F3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0XFF7D8FAB)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                hintText: "Search by keyword",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        final categories = categoryState.categories;

        if (categoryState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final visibleItems =
            showMoreCategories ? categories : categories.take(5).toList();

        return BlocBuilder<ListingFilterCubit, ListingFilterParams>(
          bloc: _filterCubit,
          builder: (context, filterState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () =>
                      setState(() => expandCategories = !expandCategories),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Categories", style: context.labelLarge),
                          if (filterState.selectedCategories.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: aquaBlueColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${filterState.selectedCategories.length}",
                                style: context.labelSmall
                                    .copyWith(color: whiteColor),
                              ),
                            ),
                        ],
                      ),
                      Icon(
                        expandCategories
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
                if (expandCategories) ...[
                  verticalMargin4,
                  for (Category category in visibleItems)
                    _buildCheckboxTile(
                      category.name,
                      filterState.selectedCategories.contains(category.id),
                      () {
                        _filterCubit.toggleCategory(category.id);
                        // Load subcategories when category is selected
                        if (!filterState.selectedCategories
                            .contains(category.id)) {
                          context
                              .read<CategoryBloc>()
                              .add(LoadSubcategories(category.id));
                        }
                      },
                    ),
                  if (!showMoreCategories && categories.length > 5)
                    GestureDetector(
                      onTap: () => setState(() => showMoreCategories = true),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "View More",
                              style: context.labelLarge.copyWith(
                                color: textBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  if (showMoreCategories && categories.length > 5)
                    GestureDetector(
                      onTap: () => setState(() => showMoreCategories = false),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "View Less",
                              style: context.labelLarge.copyWith(
                                color: textBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_up),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSubcategorySection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        return BlocBuilder<ListingFilterCubit, ListingFilterParams>(
          bloc: _filterCubit,
          builder: (context, filterState) {
            return _buildExpandableSection(
              title: "Sub Categories",
              isExpanded: expandSubcategories,
              onTap: () =>
                  setState(() => expandSubcategories = !expandSubcategories),
              badgeCount: filterState.selectedSubcategories.length,
              child: categoryState.isSubcategoriesLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : categoryState.subcategories.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Select a category first to see subcategories",
                            style: context.labelMedium.copyWith(
                              color: lightGreyTextColor,
                            ),
                          ),
                        )
                      : Column(
                          children: categoryState.subcategories
                              .map((subcategory) => _buildCheckboxTile(
                                    subcategory.title,
                                    filterState.selectedSubcategories
                                        .contains(subcategory.id),
                                    () => _filterCubit
                                        .toggleSubcategory(subcategory.id),
                                  ))
                              .toList(),
                        ),
            );
          },
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return _buildExpandableSection(
      title: "Location",
      isExpanded: false,
      onTap: () => _showLocationDialog(),
      badgeCount: _locationController.text.isNotEmpty ? 1 : 0,
      showArrow: true,
      child: const SizedBox.shrink(),
    );
  }

  void _showLocationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Location",
              style: context.titleSmall.copyWith(fontWeight: FontWeight.w700),
            ),
            verticalMargin16,
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: "City or Address",
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (_) => Navigator.pop(context),
            ),
            verticalMargin16,
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: "Apply",
                onTap: () => Navigator.pop(context),
              ),
            ),
            verticalMargin24,
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildExpandableSection(
      title: "Price Range",
      isExpanded: expandPriceRange,
      onTap: () => setState(() => expandPriceRange = !expandPriceRange),
      badgeCount: (_minPriceController.text.isNotEmpty ||
              _maxPriceController.text.isNotEmpty)
          ? 1
          : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Min",
                  prefixText: "₹ ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("-"),
            ),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Max",
                  prefixText: "₹ ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return BlocBuilder<ListingFilterCubit, ListingFilterParams>(
      bloc: _filterCubit,
      builder: (context, filterState) {
        return _buildExpandableSection(
          title: "Rating",
          isExpanded: expandRating,
          onTap: () => setState(() => expandRating = !expandRating),
          badgeCount: filterState.selectedRatings.length,
          child: Column(
            children: [5, 4, 3, 2, 1]
                .map((rating) => _buildRatingTile(
                      rating,
                      filterState.selectedRatings.contains(rating),
                      () => _filterCubit.toggleRating(rating),
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildRatingTile(int rating, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CheckboxTheme(
              data: CheckboxThemeData(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              ),
            ),
            horizontalMargin12,
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            horizontalMargin8,
            Text(
              "$rating & above",
              style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortSection() {
    return BlocBuilder<ListingFilterCubit, ListingFilterParams>(
      bloc: _filterCubit,
      builder: (context, filterState) {
        return _buildExpandableSection(
          title: "Sort By",
          isExpanded: expandSort,
          onTap: () => setState(() => expandSort = !expandSort),
          badgeCount: filterState.sortBy != null ? 1 : 0,
          child: Column(
            children: [
              _buildSortTile(
                "Price: Low to High",
                "low_to_high",
                filterState.sortBy == "low_to_high",
              ),
              _buildSortTile(
                "Price: High to Low",
                "high_to_low",
                filterState.sortBy == "high_to_low",
              ),
              _buildSortTile(
                "Newest First",
                "newest",
                filterState.sortBy == "newest",
              ),
              _buildSortTile(
                "Top Rated",
                "rating",
                filterState.sortBy == "rating",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortTile(String label, String value, bool isSelected) {
    return InkWell(
      onTap: () {
        if (isSelected) {
          _filterCubit.updateSortBy(null);
        } else {
          _filterCubit.updateSortBy(value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) {
                if (isSelected) {
                  _filterCubit.updateSortBy(null);
                } else {
                  _filterCubit.updateSortBy(value);
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            horizontalMargin12,
            Text(
              label,
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
    int badgeCount = 0,
    bool showArrow = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
          title: Row(
            children: [
              Text(title, style: context.labelLarge),
              if (badgeCount > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: aquaBlueColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$badgeCount",
                    style: context.labelSmall.copyWith(color: whiteColor),
                  ),
                ),
            ],
          ),
          trailing: showArrow
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
        ),
        if (isExpanded) child,
      ],
    );
  }

  Widget _buildCheckboxTile(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: verticalPadding4 / 2 + verticalPadding8,
        child: Row(
          children: [
            CheckboxTheme(
              data: CheckboxThemeData(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              ),
            ),
            horizontalMargin12,
            Text(
              label,
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
