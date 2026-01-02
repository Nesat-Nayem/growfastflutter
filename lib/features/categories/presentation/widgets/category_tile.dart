import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/domain/entities/category.dart';
import 'package:grow_first/features/categories/domain/entities/subcategory.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    this.category,
    this.subcategory,
    this.isSubcategory = false,
  });

  final Category? category;
  final Subcategory? subcategory;
  final bool isSubcategory;

  String get imageUrl {
    if (isSubcategory) {
      return "https://www.growfirst.org/storage/" + (subcategory?.image ?? "");
    } else {
      return "https://www.growfirst.org/storage/" + (category?.image ?? "");
    }
  }

  String get title {
    if (isSubcategory) {
      return subcategory?.title ?? "";
    } else {
      return category?.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      padding: horizontalPadding4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C76A1), Color(0xFF132E65)],
        ),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          CachedNetworkImage(imageUrl: imageUrl, height: 45, width: 45),
          verticalMargin4,
          Text(
            title,
            style: context.labelSmall.copyWith(color: whiteColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
