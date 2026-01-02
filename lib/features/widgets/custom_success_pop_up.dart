import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class CustomSuccessPopUp extends StatelessWidget {
  const CustomSuccessPopUp({
    super.key,
    required this.title,
    required this.description,
    this.onClosePressed,
    required this.onOkayPressed,
  });

  final String title;
  final String description;
  final VoidCallback? onClosePressed;
  final VoidCallback onOkayPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, minWidth: 300),
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: verticalPadding12 + horizontalPadding4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: rightPadding8,
                child: Align(
                  alignment: AlignmentGeometry.topRight,
                  child: InkWell(
                    onTap: onClosePressed ?? () => context.pop(),
                    child: Icon(Icons.cancel_outlined, size: 24),
                  ),
                ),
              ),
              Padding(
                padding: verticalPadding16 + horizontalPadding32,
                child: Column(
                  children: [
                    SvgPicture.asset(AppAssets.successCheckMarkSvg),
                    verticalMargin4,
                    Text(
                      title,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalMargin8,
                    Text(
                      description,
                      style: context.labelSmall.copyWith(
                        color: lightGreyTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalMargin32,
                    GradientButton(text: "Okay", onTap: onOkayPressed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
