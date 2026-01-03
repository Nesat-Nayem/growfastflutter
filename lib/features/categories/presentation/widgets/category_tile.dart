import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/config/app_config.dart';
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

  String? get imageUrl {
    final image = isSubcategory ? subcategory?.image : category?.image;
    if (image == null || image.isEmpty) return null;
    if (image.startsWith('http')) return image;
    return "${sl<AppConfig>().imageBaseUrl}/storage/$image";
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
          imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  height: 45,
                  width: 45,
                  errorWidget: (context, url, error) => Icon(
                    CupertinoIcons.photo,
                    size: 45,
                    color: whiteColor.withOpacity(0.5),
                  ),
                  placeholder: (context, url) => Icon(
                    CupertinoIcons.photo,
                    size: 45,
                    color: whiteColor.withOpacity(0.3),
                  ),
                )
              : Icon(
                  CupertinoIcons.photo,
                  size: 45,
                  color: whiteColor.withOpacity(0.5),
                ),
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
