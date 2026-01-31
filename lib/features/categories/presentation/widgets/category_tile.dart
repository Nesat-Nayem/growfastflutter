import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    
    // Already a full URL
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    
    final baseUrl = sl<AppConfig>().imageBaseUrl;
    
    // Handle paths that already include 'storage/'
    if (image.startsWith('storage/')) {
      return "$baseUrl/$image";
    }
    
    // Handle paths starting with '/'
    final normalizedImage = image.startsWith('/') ? image.substring(1) : image;
    
    return "$baseUrl/storage/$normalizedImage";
  }

  bool get isSvg {
    final url = imageUrl;
    if (url == null) return false;
    return url.toLowerCase().endsWith('.svg');
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
    final url = imageUrl;
    
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImage(url),
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

  Widget _buildImage(String? url) {
    if (url == null) {
      return _buildPlaceholder();
    }

    if (isSvg) {
      return SvgPicture.network(
        url,
        height: 45,
        width: 45,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => _buildLoadingIndicator(),
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      height: 45,
      width: 45,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      memCacheHeight: 90,
      memCacheWidth: 90,
      errorWidget: (context, url, error) => _buildPlaceholder(),
      placeholder: (context, url) => _buildLoadingIndicator(),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      CupertinoIcons.photo,
      size: 45,
      color: whiteColor.withValues(alpha: 0.5),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 45,
      width: 45,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: whiteColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
