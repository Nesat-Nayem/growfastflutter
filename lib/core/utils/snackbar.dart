import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = textBlackColor,
    EdgeInsetsGeometry? padding,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.labelLarge.copyWith(
            fontWeight: FontWeight.w400,
            color: whiteColor,
          ),
        ),
        backgroundColor: backgroundColor,
        padding: padding ?? horizontalPadding16 + verticalPadding24,
        duration: duration,
      ),
    );
  }
}
