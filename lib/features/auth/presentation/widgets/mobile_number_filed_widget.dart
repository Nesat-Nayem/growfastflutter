import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class MobileNumberField extends StatefulWidget {
  final String initialCountryCode;
  final String initialFlagAsset;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final ValueChanged<bool>? onValidChanged;
  final ValueChanged<String>? onCountryChanged;

  const MobileNumberField({
    super.key,
    required this.initialCountryCode,
    required this.initialFlagAsset,
    this.onChanged,
    required this.controller,
    this.onValidChanged,
    this.onCountryChanged,
  });

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  // Fixed to India only
  final String _countryCode = 'IN';
  final String _flagAsset = '🇮🇳';
  final String _dialCode = '+91';
  String? _errorText;

  String? _validate(String value) {
    if (value.isEmpty) return "Please enter a mobile number";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only digits are allowed";
    }
    // Indian mobile numbers are exactly 10 digits
    if (value.length != 10) {
      return "Mobile number must be 10 digits";
    }
    // Indian mobile numbers start with 6, 7, 8, or 9
    if (!RegExp(r'^[6-9]').hasMatch(value)) {
      return "Invalid Indian mobile number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: lightGreyColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: verticalPadding12 + horizontalPadding12,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Text(_flagAsset, style: const TextStyle(fontSize: 20)),
              ),
              horizontalMargin8,
              // Country code display (non-clickable - India only)
              Row(
                children: [
                  Text(_dialCode, style: context.bodySmall),
                  horizontalMargin4,
                ],
              ),
              horizontalMargin8,
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: widget.controller,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: context.bodySmall,
                      decoration: InputDecoration(
                        hintText: "Enter 10 digit mobile number",
                        hintStyle: TextStyle(color: lightGreyColor),
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '', // Hide character counter
                      ),
                      onChanged: (value) {
                        final error = _validate(value);
                        setState(() => _errorText = error);
                        widget.onValidChanged?.call(error == null);
                        widget.onChanged?.call(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        verticalMargin4,
        Row(
          children: [
            Expanded(child: emptyBox),
            Expanded(
              flex: 3,
              child: Text(
                _errorText ?? "",
                style: context.labelMedium.copyWith(color: lavaRedColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
