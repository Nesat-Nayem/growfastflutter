import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/listing/presentation/widgets/listing_tile.dart';
import 'package:grow_first/features/widgets/custom_success_pop_up.dart';
import 'package:grow_first/features/widgets/custom_text_field.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class SendEnquiryPopUp extends StatefulWidget {
  const SendEnquiryPopUp({super.key, this.onCancel, required this.onSubmit});

  final VoidCallback? onCancel;
  final VoidCallback onSubmit;

  @override
  State<SendEnquiryPopUp> createState() => _SendEnquiryPopUpState();
}

class _SendEnquiryPopUpState extends State<SendEnquiryPopUp> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: verticalPadding12 + horizontalPadding12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text("Send Enquiry", style: context.labelLarge),
                    ),
                    InkWell(
                      onTap: widget.onCancel ?? () => context.pop(),
                      child: Icon(Icons.cancel_outlined, size: 24),
                    ),
                  ],
                ),
                verticalMargin16,
                ListingTile(isGridView: false, showActionButtons: false),
                verticalMargin24,
                Text(
                  "Name",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "suraj3894",
                  keyboardType: TextInputType.text,
                ),
                verticalMargin16,
                Text(
                  "Email Address",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "youremail@domain.com",
                  keyboardType: TextInputType.text,
                ),
                verticalMargin16,
                Text(
                  "Phone Number",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "+91 1234568790",
                  keyboardType: TextInputType.phone,
                ),
                verticalMargin16,
                Text(
                  "Write us a Message",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                CustomTextField(
                  controller: TextEditingController(),
                  hintText: "Lorem ipsum is a dummy text",
                  contentPadding: verticalPadding24,
                  keyboardType: TextInputType.text,
                ),
                verticalMargin16,
                GradientButton(
                  text: "Submit",
                  onTap: () {
                    context.pop();
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Dismiss",
                      barrierColor: Colors.black54,
                      transitionDuration: Duration(milliseconds: 300),
                      pageBuilder: (context, animation1, animation2) {
                        return CustomSuccessPopUp(
                          title: "Enquiry Submitted",
                          description:
                              "Your request has been sent to the supplier!",
                          onOkayPressed: () {
                            context.pop();
                            context.goNamed(AppRouterNames.home);
                          },
                        );
                      },
                    );
                  },
                ),
                verticalMargin12,
                GradientButton(
                  text: "Cancel",
                  onTap: () => context.pop(),
                  hideGradient: true,
                  backgroundColor: greyButttonColor,
                  textStyle: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
