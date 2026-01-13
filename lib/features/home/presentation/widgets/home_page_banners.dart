import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class HomePageBanners extends StatefulWidget {
  const HomePageBanners({
    super.key,
    required this.height,
    required this.images,
  });

  final double height;
  final List<String> images;

  @override
  State<HomePageBanners> createState() => _HomePageBannersState();
}

class _HomePageBannersState extends State<HomePageBanners> {
  late CarouselController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();

    _controller.addListener(() {
      final offset = _controller.offset;
      final itemExtent = context.width;

      if (itemExtent == 0) return;

      final index = (offset / itemExtent).round();
      if (index != _currentIndex) {
        setState(() => _currentIndex = index);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: CarouselView(
            controller: _controller,
            itemSnapping: true,
            itemExtent: context.width,
            children: widget.images.map((img) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(imageUrl: img, fit: BoxFit.cover),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: verticalPadding4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final active = index == _currentIndex;
              return Container(
                // duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 12 : 8,
                height: active ? 12 : 8,
                decoration: BoxDecoration(
                  color: active ? aquaBlueColor : lightGreyColor,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
