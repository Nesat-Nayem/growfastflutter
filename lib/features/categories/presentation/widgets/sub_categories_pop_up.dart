import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/domain/entities/category.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';

// class SubCategoriesPopUp extends StatefulWidget {
//   const SubCategoriesPopUp({super.key, required this.category});

//   final Category category;

//   @override
//   State<SubCategoriesPopUp> createState() => _SubCategoriesPopUpState();
// }

// class _SubCategoriesPopUpState extends State<SubCategoriesPopUp> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryBloc>().add(LoadSubcategories(widget.category.id));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: Material(
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           width: MediaQuery.sizeOf(context).width * 0.85,
//           height: MediaQuery.sizeOf(context).height * 0.55,
//           margin: horizontalPadding12,
//           padding: topPadding8,
//           decoration: BoxDecoration(color: Colors.white),
//           child: BlocBuilder<CategoryBloc, CategoryState>(
//             bloc: context.read<CategoryBloc>(),
//             builder: (_, state) {
//               if (state.isSubcategoriesLoading == true) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (state.subcategories.isEmpty) {
//                 return Center(
//                   child: Text(
//                     "No subcategories found",
//                     style: context.bodySmall,
//                   ),
//                 );
//               }
//               return Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.category.name,
//                           style: context.bodySmall,
//                           maxLines: 2,
//                         ),
//                       ),
//                       IconButton.outlined(
//                         onPressed: () => context.pop(),
//                         icon: Icon(Icons.close),
//                       ),
//                     ],
//                   ),
//                   verticalMargin12,
//                   Expanded(
//                     child: GridView.builder(
//                       padding: verticalPadding8,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 13,
//                         mainAxisSpacing: 13,
//                       ),
//                       itemCount: state.subcategories.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             context.pop();
//                             context.pushNamed(
//                               AppRouterNames.listings,
//                               queryParameters: {
//                                 "categoryId": widget.category.id.toString(),
//                                 "subcategoryId": state.subcategories[index].id
//                                     .toString(),
//                               },
//                             );
//                           },
//                           child: CategoryTile(
//                             isSubcategory: true,
//                             subcategory: state.subcategories[index],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final Category category;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

// class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryBloc>().add(LoadSubcategories(widget.category.id));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category.name),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: Padding(
//         padding: horizontalPadding12,
//         child: BlocBuilder<CategoryBloc, CategoryState>(
//           bloc: context.read<CategoryBloc>(),
//           builder: (_, state) {
//             if (state.isSubcategoriesLoading == true) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state.subcategories.isEmpty) {
//               return Center(
//                 child: Text("No subcategories found", style: context.bodySmall),
//               );
//             }

//             return GridView.builder(
//               padding: verticalPadding8,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 13,
//                 mainAxisSpacing: 13,
//               ),
//               itemCount: state.subcategories.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     context.pop();
//                     context.pushNamed(
//                       AppRouterNames.listings,
//                       queryParameters: {
//                         "categoryId": widget.category.id.toString(),
//                         "subcategoryId": state.subcategories[index].id
//                             .toString(),
//                       },
//                     );
//                   },
//                   child: CategoryTile(
//                     isSubcategory: true,
//                     subcategory: state.subcategories[index],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  bool _redirected = false; // important to avoid multiple redirects

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadSubcategories(widget.category.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name, style: TextStyle(fontSize: 15)),
        leading: Padding(
          padding: const EdgeInsets.all(14.0), // AppBar spacing fix
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: textBlackColor, width: 0.7),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ),

      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back),
      //   onPressed: () => context.pop(),
      // ),
      body: Padding(
        padding: horizontalPadding12,
        child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            /// ✅ DATA LOAD HO GAYA
            if (!state.isSubcategoriesLoading &&
                state.subcategories.isEmpty &&
                !_redirected) {
              _redirected = true;

              /// 👉 Direct listings page
              context.pop(); // close dialog/screen
              context.pushNamed(
                AppRouterNames.listings,
                queryParameters: {"categoryId": widget.category.id.toString()},
              );
            }
          },
          builder: (context, state) {
            if (state.isSubcategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.subcategories.isEmpty) {
              // UI flash avoid karne ke liye empty widget
              return const SizedBox.shrink();
            }

            return GridView.builder(
              padding: verticalPadding8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
              ),
              itemCount: state.subcategories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      AppRouterNames.listings,
                      queryParameters: {
                        "categoryId": widget.category.id.toString(),
                        "subcategoryId": state.subcategories[index].id
                            .toString(),
                      },
                    );
                  },
                  child: CategoryTile(
                    isSubcategory: true,
                    subcategory: state.subcategories[index],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
