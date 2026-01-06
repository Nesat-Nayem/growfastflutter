import 'package:flutter/material.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/app_drop_down_filed.dart';

class CountryStateSection extends StatefulWidget {
  const CountryStateSection({
    super.key,
    this.initialCountry,
    this.initialState,
    this.onCountryChanged,
    this.onStateChanged,
  });

  final String? initialCountry;
  final String? initialState;
  final ValueChanged<String?>? onCountryChanged;
  final ValueChanged<String?>? onStateChanged;

  @override
  State<CountryStateSection> createState() => _CountryStateSectionState();
}

class _CountryStateSectionState extends State<CountryStateSection> {
  String? selectedCountry;
  String? selectedState;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
    selectedState = widget.initialState;
  }

  @override
  void didUpdateWidget(CountryStateSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountry != oldWidget.initialCountry) {
      setState(() {
        selectedCountry = widget.initialCountry;
      });
    }
    if (widget.initialState != oldWidget.initialState) {
      setState(() {
        selectedState = widget.initialState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Country",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              AppDropdownField(
                label: "Country",
                items: const ["India", "USA", "UK", "Canada"],
                value: selectedCountry,
                onChanged: (value) {
                  setState(() => selectedCountry = value);
                  widget.onCountryChanged?.call(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "State",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              AppDropdownField(
                label: "State",
                items: const [
                  "Maharashtra",
                  "Gujarat",
                  "Punjab",
                  "Karnataka",
                  "Delhi",
                ],
                value: selectedState,
                onChanged: (value) {
                  setState(() => selectedState = value);
                  widget.onStateChanged?.call(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
