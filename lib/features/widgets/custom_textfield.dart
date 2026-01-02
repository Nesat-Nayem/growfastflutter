import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lightGreyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: verticalPadding8 + horizontalPadding12,
      child: TextFormField(
        controller: TextEditingController(),
        onTapOutside: (event) {
          return FocusManager.instance.primaryFocus?.unfocus();
        },

        keyboardType: TextInputType.phone,
        style: context.labelLarge.copyWith(
          fontWeight: FontWeight.w400,
          color: lightGreyTextColor.withValues(alpha: 0.4),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.labelLarge.copyWith(
            fontWeight: FontWeight.w400,
            color: lightGreyTextColor.withValues(alpha: 0.4),
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: (value) {},
        // validator: Validators.validatePassword,
      ),
    );
  }
}
