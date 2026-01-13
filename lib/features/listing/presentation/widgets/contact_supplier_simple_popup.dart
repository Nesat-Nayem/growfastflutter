import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/network.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_success_pop_up.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

/// A simplified contact supplier popup that works with basic service info
/// Used when full Listing entity is not available (e.g., home page service sections)
class ContactSupplierSimplePopup extends StatefulWidget {
  const ContactSupplierSimplePopup({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
    required this.servicePrice,
    required this.serviceCity,
    this.serviceImageUrl,
    this.vendorName,
    this.rating,
    this.onCancel,
  });

  final int serviceId;
  final String serviceTitle;
  final String servicePrice;
  final String serviceCity;
  final String? serviceImageUrl;
  final String? vendorName;
  final double? rating;
  final VoidCallback? onCancel;

  @override
  State<ContactSupplierSimplePopup> createState() =>
      _ContactSupplierSimplePopupState();
}

class _ContactSupplierSimplePopupState
    extends State<ContactSupplierSimplePopup> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _submitContact() async {
    final mobile = _mobileController.text.trim();

    if (mobile.isEmpty) {
      setState(() => _errorMessage = 'Please enter your mobile number');
      return;
    }

    if (mobile.length != 10) {
      setState(
          () => _errorMessage = 'Please enter a valid 10-digit mobile number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = sl<Dio>();
      final response = await NetworkHelper.sendRequest(
        dio,
        RequestType.post,
        'customer/contact-supplier',
        data: {
          'mobile': mobile,
          'service_id': widget.serviceId,
        },
      );

      if (!mounted) return;

      if (response['success'] == true) {
        context.pop();
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Something went wrong';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, animation1, animation2) {
        return CustomSuccessPopUp(
          title: "Success!",
          description: "Your request has been sent to the supplier!",
          onOkayPressed: () => ctx.pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onCancel ?? () => context.pop(),
        ),
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: horizontalPadding16 + verticalPadding16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Text(
                "Login to get best\ndeals instantly",
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              verticalMargin8,
              Text(
                "Just One Step to Connect with Verified Seller",
                style: context.labelMedium.copyWith(
                  color: lightGreyTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              verticalMargin24,

              // Service Card
              Container(
                padding: allPadding12,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vendor name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.vendorName ?? '',
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                size: 16, color: selectiveYellowColor),
                            Text(
                              "(${(widget.rating ?? 4.5).toStringAsFixed(1)})",
                              style: context.labelSmall
                                  .copyWith(color: lightGreyTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalMargin12,
                    // Service details row
                    Row(
                      children: [
                        // Service image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.serviceImageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: widget.serviceImageUrl!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    height: 70,
                                    width: 70,
                                    color: lightGreySnowColor,
                                    child: const Icon(
                                        Icons.image_not_supported_outlined),
                                  ),
                                )
                              : Container(
                                  height: 70,
                                  width: 70,
                                  color: lightGreySnowColor,
                                  child: const Icon(
                                      Icons.image_not_supported_outlined),
                                ),
                        ),
                        horizontalMargin12,
                        // Service info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceTitle,
                                style: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              verticalMargin4,
                              Text(
                                "₹${widget.servicePrice}",
                                style: context.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              verticalMargin4,
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 16, color: lightGreyTextColor),
                                  horizontalMargin4,
                                  Text(
                                    widget.serviceCity,
                                    style: context.labelSmall.copyWith(
                                      color: lightGreyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalMargin32,

              // Mobile Number Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mobile Number",
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              verticalMargin8,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Country code
                    Container(
                      padding: horizontalPadding12 + verticalPadding12,
                      child: Row(
                        children: [
                          Image.network(
                            'https://flagcdn.com/w40/in.png',
                            width: 24,
                            height: 16,
                            errorBuilder: (_, __, ___) => const Text('🇮🇳'),
                          ),
                          horizontalMargin8,
                          Text(
                            "+91",
                            style: context.labelMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          horizontalMargin4,
                          Icon(Icons.keyboard_arrow_down,
                              size: 20, color: lightGreyTextColor),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    // Phone input
                    Expanded(
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: "",
                          hintStyle: context.labelMedium.copyWith(
                            color: lightGreyTextColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: horizontalPadding12,
                        ),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (_errorMessage != null) ...[
                verticalMargin8,
                Text(
                  _errorMessage!,
                  style: context.labelSmall.copyWith(color: Colors.red),
                ),
              ],

              const Spacer(),

              // Continue Button
              GradientButton(
                text: _isLoading ? "Submitting..." : "Continue",
                onTap: _isLoading ? null : _submitContact,
              ),
              verticalMargin16,

              // Country info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 18, color: lightGreyTextColor),
                  horizontalMargin8,
                  Text(
                    "Your Country is ",
                    style: context.labelSmall.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                  Text(
                    "India",
                    style: context.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 16, color: lightGreyTextColor),
                ],
              ),
              verticalMargin16,

              // Disclaimer
              Text(
                "We don't call, only genuine seller\nwill contact you",
                style: context.labelSmall.copyWith(
                  color: lightGreyTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              verticalMargin8,
              Text(
                "Almost done! Just verify your mobile",
                style: context.labelSmall.copyWith(
                  color: aquaBlueColor,
                ),
                textAlign: TextAlign.center,
              ),
              verticalMargin16,
            ],
          ),
        ),
      ),
    );
  }
}
