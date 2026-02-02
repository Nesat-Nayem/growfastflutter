import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/kyc_upload_dto.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_event.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_state.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:image_picker/image_picker.dart';

class VendorUploadKycPage extends StatefulWidget {
  const VendorUploadKycPage({super.key});

  @override
  State<VendorUploadKycPage> createState() => _VendorUploadKycPageState();
}

class _VendorUploadKycPageState extends State<VendorUploadKycPage> {
  final ImagePicker _picker = ImagePicker();
  
  File? aadharFile;
  File? panFile;
  File? passportFile;
  final TextEditingController idCardController = TextEditingController();

  @override
  void dispose() {
    idCardController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        switch (type) {
          case 'aadhar':
            aadharFile = File(image.path);
            break;
          case 'pan':
            panFile = File(image.path);
            break;
          case 'passport':
            passportFile = File(image.path);
            break;
        }
      });
    }
  }

  void _submitKyc() {
    if (aadharFile == null && panFile == null && passportFile == null && idCardController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one document'), backgroundColor: Colors.red),
      );
      return;
    }

    final request = KycUploadRequest(
      aadhar: aadharFile,
      pan: panFile,
      passport: passportFile,
      idCard: idCardController.text.trim().isEmpty ? null : idCardController.text.trim(),
    );

    sl<VendorBloc>().add(UploadKyc(request));
  }

  void _skipKyc() {
    context.goNamed(AppRouterNames.vendorChoosePlan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      body: BlocConsumer<VendorBloc, VendorState>(
        bloc: sl<VendorBloc>(),
        listener: (context, state) {
          if (state.kycSuccess) {
            context.goNamed(AppRouterNames.vendorChoosePlan);
          }
          if (state.kycError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.kycError!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StepProgressHeader(
                  currentStep: 1,
                  steps: const [
                    StepItem(label: "Basic Info", icon: Icons.info_outline),
                    StepItem(label: "KYC Details", icon: Icons.description_outlined),
                    StepItem(label: "Choose\nPlan", icon: Icons.cast_outlined),
                    StepItem(label: "Confirm\non", icon: Icons.check),
                  ],
                ),
                verticalMargin24,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildUploadCard("Aadhar Card", "Upload your Aadhar card (front + back)", aadharFile, () => _pickImage('aadhar')),
                        verticalMargin16,
                        _buildUploadCard("PAN Card", "Upload your PAN card", panFile, () => _pickImage('pan')),
                        verticalMargin16,
                        _buildUploadCard("Passport (Optional)", "Upload your passport", passportFile, () => _pickImage('passport')),
                        verticalMargin16,
                        _buildIdCardField(),
                        verticalMargin24,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: bottomPadding12 + horizontalPadding16,
          child: BlocBuilder<VendorBloc, VendorState>(
            bloc: sl<VendorBloc>(),
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientButton(
                    text: state.isUploadingKyc ? "Uploading..." : "Submit KYC",
                    onTap: state.isUploadingKyc ? null : _submitKyc,
                    textStyle: context.labelLarge.copyWith(color: whiteColor),
                  ),
                  verticalMargin8,
                  TextButton(
                    onPressed: state.isUploadingKyc ? null : _skipKyc,
                    child: Text("Skip for now", style: context.labelMedium.copyWith(color: textLightColor)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard(String title, String subtitle, File? file, VoidCallback onUpload) {
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
          Text(title, style: context.labelLarge.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(subtitle, style: context.labelMedium.copyWith(fontWeight: FontWeight.w500, letterSpacing: 1, color: shipGreyColor1)),
          const SizedBox(height: 20),
          
          if (file != null)
            _buildFilePreview(file, () => setState(() {
              if (title.contains("Aadhar")) aadharFile = null;
              else if (title.contains("PAN")) panFile = null;
              else passportFile = null;
            }))
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text("No File Chosen", style: context.labelMedium.copyWith(fontWeight: FontWeight.w500, letterSpacing: 1, color: shipGreyColor1)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.cloud_upload_outlined, color: whiteColor),
                    label: Text("Upload", style: context.labelSmall.copyWith(color: whiteColor)),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 12),
          const Text("Only support .jpg and .png less than 1MB", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFilePreview(File file, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(file, height: 60, width: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.path.split('/').last, style: context.labelMedium.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                const Text("Uploaded", style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: onRemove),
        ],
      ),
    );
  }

  Widget _buildIdCardField() {
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
          Text("ID Card Number (Optional)", style: context.labelLarge.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text("Enter your government ID card number", style: context.labelMedium.copyWith(fontWeight: FontWeight.w500, letterSpacing: 1, color: shipGreyColor1)),
          const SizedBox(height: 16),
          TextField(
            controller: idCardController,
            decoration: InputDecoration(
              hintText: "Enter ID card number",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
