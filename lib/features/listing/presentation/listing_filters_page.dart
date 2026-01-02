import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ListingFiltersPage extends StatefulWidget {
  const ListingFiltersPage({super.key});

  @override
  State<ListingFiltersPage> createState() => _ListingFiltersPageState();
}

class _ListingFiltersPageState extends State<ListingFiltersPage> {
  bool showMoreCategories = false;
  bool expandCategories = true;

  List<String> categories = [
    "All Categories",
    "Construction",
    "Car Wash",
    "Electrical",
    "Cleaning",
    "Plumbing",
    "Painting",
    "Gardening",
  ];

  Map<String, bool> selected = {};

  @override
  void initState() {
    super.initState();
    for (var c in categories) {
      selected[c] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Filters"),
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
            verticalMargin24,
            const Divider(height: 1, color: lightGreyColor),
            _buildNavigateTile("Sub Categories"),
            const Divider(height: 1, color: lightGreyColor),
            _buildNavigateTile("Location"),
            const Divider(height: 1, color: lightGreyColor),
            _buildNavigateTile("Price Range"),
            const Divider(height: 1, color: lightGreyColor),
            _buildNavigateTile("Rating"),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .end,
            children: [
              GradientButton(
                text: "Confirm Changes",
                onTap: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  // 🔍 Search Bar UI
  Widget _buildSearchBox() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0XFFEFF1F3)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Color(0XFF7D8FAB)),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
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
    final visibleItems = showMoreCategories ? categories : categories.take(5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => expandCategories = !expandCategories),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categories", style: context.labelLarge),
              Icon(
                expandCategories
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        horizontalMargin16,
        if (expandCategories) ...[
          Column(
            children: [
              verticalMargin4,
              for (String item in visibleItems) _buildCheckboxTile(item),

              if (!showMoreCategories && categories.length > 5) ...[
                GestureDetector(
                  onTap: () => setState(() => showMoreCategories = true),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          "View More",
                          style: context.labelLarge.copyWith(
                            color: textBlackColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),

                if (showMoreCategories)
                  GestureDetector(
                    onTap: () => setState(() => showMoreCategories = false),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "View Less",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up),
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxTile(String label) {
    return Padding(
      padding: verticalPadding4 / 2 + verticalPadding8,
      child: Row(
        children: [
          CheckboxTheme(
            data: CheckboxThemeData(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(5),
              ),
            ),
            child: Checkbox(
              value: selected[label],
              onChanged: (v) => setState(() => selected[label] = v!),
            ),
          ),
          horizontalMargin12,
          Text(
            label,
            style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigateTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: context.labelLarge),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
