import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class VendorUploadKycPage extends StatefulWidget {
  const VendorUploadKycPage({super.key});

  @override
  State<VendorUploadKycPage> createState() => _VendorUploadKycPageState();
}

class _VendorUploadKycPageState extends State<VendorUploadKycPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              GradientButton(
                text: "Next",
                onTap: () {
                  context.goNamed('vendorConfirmRegistration');
                },
                textStyle: context.labelLarge.copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StepProgressHeader(
              currentStep: 2,
              steps: const [
                StepItem(label: "Basic Info", icon: Icons.info_outline),
                StepItem(label: "Choose Plan", icon: Icons.cast_outlined),
                StepItem(
                  label: "KYC Details",
                  icon: Icons.description_outlined,
                ),
                StepItem(label: "Confirmation", icon: Icons.check),
              ],
            ),
            verticalMargin24,
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [AadhaarUploadCard()]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AadhaarUploadCard extends StatelessWidget {
  const AadhaarUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Upload Aadhar Card (Front + Back)",
            style: context.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Add your documents here, and you can upload...",
            style: context.labelMedium.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: shipGreyColor1,
            ),
          ),

          const SizedBox(height: 20),

          DottedBorder(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    "No File Chosen",
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: shipGreyColor1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(Icons.cloud_upload_outlined, color: whiteColor),
                    label: Text(
                      "Upload",
                      style: context.labelSmall.copyWith(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Only support .jpg and .png less than 1MB",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 20),

          /// Uploading Progress
          _uploadingCard(context),

          const SizedBox(height: 16),

          /// Uploaded Files
          _fileItem("Aadhar_front.jpg", "500kb", context),
          const SizedBox(height: 12),
          _fileItem("Aadhar_back.jpg", "500kb", context),
        ],
      ),
    );
  }

  /// Uploading card
  Widget _uploadingCard(BuildContext context) {
    return Container(
      padding: verticalPadding4 + horizontalPadding8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Uploading...",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.pause_circle_outline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "65% • 30 seconds remaining",
            style: context.labelSmall.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4DB6C6)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// File item
  Widget _fileItem(String name, String size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  size,
                  style: context.labelSmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: () {}),
        ],
      ),
    );
  }
}
