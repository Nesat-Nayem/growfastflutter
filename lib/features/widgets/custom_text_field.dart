import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.contentPadding,
    required this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lightGreyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: verticalPadding12 + horizontalPadding12,
      child: TextFormField(
        controller: controller,
        onTapOutside: (event) {
          return FocusManager.instance.primaryFocus?.unfocus();
        },
        keyboardType: keyboardType,
        style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          errorStyle: context.labelSmall.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          hintStyle: context.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            color: lightGreyTextColor.withValues(alpha: 0.7),
          ),
          border: InputBorder.none,
          isDense: true,

          contentPadding: contentPadding,
        ),
        validator: validator,
        onChanged: (value) {},
      ),
    );
  }
}
