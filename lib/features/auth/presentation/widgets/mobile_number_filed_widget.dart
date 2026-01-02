import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/countries.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/auth/domain/entities/country.dart';
import 'package:grow_first/features/auth/presentation/widgets/country_picker_sheet.dart';

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
  late String _countryCode;
  late String _flagAsset;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.initialCountryCode;
    _flagAsset = widget.initialFlagAsset;
  }

  String? _validate(String value, Country country) {
    if (value.isEmpty) return "Please enter a mobile number";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only digits are allowed";
    }
    if (value.length > country.maxLength) {
      return "Number must be less than ${country.maxLength + 1}";
    }
    if (value.length < country.minLength) {
      return "Number must be between ${country.minLength} and ${country.maxLength} digits";
    }
    return null;
  }

  // Get the currently selected country from your local list
  Country _getSelectedCountry() {
    return kCountriesList.firstWhere(
      (c) => c.code == _countryCode,
      orElse: () => kCountriesList.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = _getSelectedCountry();

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
                child: Text(_flagAsset),
              ),
              horizontalMargin8,
              InkWell(
                onTap: () async {
                  final Country? selected = await showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    isScrollControlled: true,
                    backgroundColor: whiteColor,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) {
                      return const CountryPickerSheet();
                    },
                  );

                  if (selected != null) {
                    _countryCode = selected.code;
                    _flagAsset = selected.flag;

                    widget.onCountryChanged?.call(_countryCode);

                    final error = _validate(
                      widget.controller.text.trim(),
                      _getSelectedCountry(),
                    );
                    setState(() => _errorText = error);
                  }
                },
                child: Row(
                  children: [
                    Text(_countryCode, style: context.bodySmall),
                    horizontalMargin4,
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
              ),
              horizontalMargin16,
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: widget.controller,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      keyboardType: TextInputType.phone,
                      style: context.bodySmall,
                      decoration: InputDecoration(
                        hintText: "1234567890",
                        hintStyle: TextStyle(color: lightGreyColor),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (value) {
                        final error = _validate(value, selectedCountry);
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
