import 'package:flutter/material.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class StatusButton extends StatelessWidget {
  const StatusButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.titleColor,
    this.textStyle,
  });

  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding4 + horizontalPadding4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style:
            textStyle?.copyWith(color: titleColor) ??
            context.labelSmall.copyWith(color: titleColor),
      ),
    );
  }
}
