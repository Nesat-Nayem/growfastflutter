import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';
import 'package:grow_first/features/categories/presentation/widgets/sub_categories_pop_up.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/shimmer.dart';

class ExploreCategoriesPage extends StatelessWidget {
  const ExploreCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<CategoryBloc>()..add(LoadCategories()),
      child: const _ExploreCategoriesView(),
    );
  }
}

class _ExploreCategoriesView extends StatelessWidget {
  const _ExploreCategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(),
      body: Padding(
        padding: horizontalPadding16 + topPadding24,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Explore our categories",
                    style: context.bodySmall,
                  ),
                ),
              ],
            ),
            verticalMargin12,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Expanded(
                    child: GridView.builder(
                      padding: verticalPadding8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 13,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return AppShimmer(
                          width: 120,
                          height: context.height * 0.11,
                        );
                      },
                    ),
                  );
                } else if (state.categories.isNotEmpty) {
                  return Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate item width to fit 3 items per row
                        final spacing = 13.0;
                        final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;
                        final itemHeight = itemWidth * 1.1; // Maintain aspect ratio
                        
                        return GridView.builder(
                          padding: verticalPadding8,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: itemWidth / itemHeight,
                          ),
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                final categoryBloc = context.read<CategoryBloc>();
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: "Dismiss",
                                  barrierColor: Colors.black54,
                                  transitionDuration: Duration(milliseconds: 300),
                                  pageBuilder: (context, animation1, animation2) {
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
                        );
                      },
                    ),
                  );
                }
                return emptyBox;
              },
            ),
          ],
        ),
      ),
    );
  }
}
