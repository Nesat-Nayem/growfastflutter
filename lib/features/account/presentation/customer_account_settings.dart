import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/account/presentation/widgets/country_state_selection.dart';
import 'package:grow_first/features/account/presentation/widgets/date_of_bith_drop_down.dart';
import 'package:grow_first/features/account/presentation/widgets/gender_drop_down.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';
import 'package:grow_first/features/widgets/custom_textfield.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:sizer/sizer.dart';

class CustomerAccountSettings extends StatelessWidget {
  CustomerAccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Account Settings"),
      drawer: ModernCustomerDrawer(),
      body: ListView(
        padding: horizontalPadding16,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              verticalMargin8,
              Row(
                crossAxisAlignment: .start,
                children: [
                  CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://www.growfirst.org/storage/blogs/XWWB6kBSSDqCLp3oC5LKSOvGR2P903976KfwIR0A.jpg",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  horizontalMargin16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  allPadding8 +
                                  horizontalPadding12 +
                                  verticalPadding4 / 2,
                              decoration: BoxDecoration(
                                color: textBlackColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.iconUploadCloudSvg,
                                    height: 18,
                                  ),
                                  horizontalMargin8,
                                  Text(
                                    "Upload",
                                    style: context.labelSmall.copyWith(
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalMargin12,
                            Container(
                              padding:
                                  allPadding8 +
                                  horizontalPadding24 +
                                  verticalPadding4 / 2,
                              decoration: BoxDecoration(
                                color: greyButttonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text("Remove", style: context.labelSmall),
                            ),
                          ],
                        ),
                        verticalMargin8,
                        Text(
                          "*Image size should be at least 320px big and less that 500kb. Allowed files .png and .jpg",
                          style: context.labelSmall.copyWith(
                            color: lavaRedColor.withValues(alpha: 0.4),
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalMargin16,
              Text(
                "General Information",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              Text(
                "Name",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(hintText: "suraj"),
              verticalMargin16,
              Text(
                "User Name",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(hintText: "Suraj0809"),
              verticalMargin16,
              Text(
                "Email",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(hintText: "suraj@gmail.com"),
              verticalMargin16,
              Text(
                "Mobile Number",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(hintText: "+91 0000000000"),
              verticalMargin16,
              Text(
                "Gender",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              GenderDropdown(),
              verticalMargin16,
              Text(
                "Date of Birth",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              DatePickerField(),
              verticalMargin16,
              Text(
                "Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              Text(
                "Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              CustomTextfield(
                hintText: "6391 Elgin St. Celina, Delaware 10299",
              ),
              verticalMargin16,
              CountryStateSection(),
              verticalMargin16,
              Text(
                "City",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              CustomTextfield(hintText: "Pune"),
              verticalMargin16,
              Text(
                "Postal Code",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              CustomTextfield(hintText: "411001"),
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
              verticalMargin48,
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        padding: horizontalPadding16,
        color: whiteColor,
        child: Column(
          mainAxisAlignment: .end,
          mainAxisSize: .min,
          children: [
            GradientButton(text: "Save Changes", onTap: () {}),
            verticalMargin24,
            GradientButton(
              text: "Cancel",
              onTap: () {},
              hideGradient: true,
              backgroundColor: const Color(0XFFEBECED),
              textStyle: context.labelLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalMargin32,
          ],
        ),
      ),
    );
  }
}
