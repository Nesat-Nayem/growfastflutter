import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class CustomBottomNavNextBackBtns extends StatelessWidget {
  const CustomBottomNavNextBackBtns({
    super.key,
    this.showSelectAnyoneOption = false,
    this.title1,
    this.title2,
    this.showIcon = true,
    this.onPressedOne,
    this.onPressedTwo,
  });

  final bool showSelectAnyoneOption;
  final String? title1;
  final String? title2;
  final bool showIcon;
  final VoidCallback? onPressedOne;
  final VoidCallback? onPressedTwo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: bottomPadding12 + horizontalPadding16,
        child: Column(
          mainAxisAlignment: .end,
          mainAxisSize: .min,
          children: [
            if (showSelectAnyoneOption) ...[
              Row(
                children: [
                  CheckboxTheme(
                    data: CheckboxThemeData(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      checkColor: WidgetStatePropertyAll(whiteColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(5),
                      ),
                    ),
                    child: Checkbox(
                      fillColor: WidgetStatePropertyAll(aquaGreenColor),
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  horizontalMargin8,
                  Text(
                    "Select Anyone for this Booking",
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              verticalMargin16,
            ],
            GradientButton(
              text: title1 ?? "Next",
              onTap: onPressedOne ?? () {},
              iconWithTitle: Padding(
                padding: horizontalPadding4 / 2,
                child: showIcon
                    ? Icon(
                        Icons.arrow_outward_rounded,
                        color: whiteColor,
                        size: 17,
                      )
                    : null,
              ),
              textStyle: context.labelLarge.copyWith(color: whiteColor),
            ),
            verticalMargin16,
            GradientButton(
              text: title2 ?? "Back",
              onTap: onPressedTwo ?? () {},
              hideGradient: true,
              backgroundColor: greyButttonColor,
              textStyle: context.labelLarge.copyWith(color: lightGreyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
