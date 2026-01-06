import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';

class GenderDropdown extends StatefulWidget {
  const GenderDropdown({
    super.key,
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  @override
  void didUpdateWidget(GenderDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedGender = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightGreyColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedGender,
          dropdownColor: whiteColor,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
          hint: const Text("Select Gender"),
          items: const [
            DropdownMenuItem(value: "male", child: Text("Male")),
            DropdownMenuItem(value: "female", child: Text("Female")),
            DropdownMenuItem(value: "other", child: Text("Other")),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
