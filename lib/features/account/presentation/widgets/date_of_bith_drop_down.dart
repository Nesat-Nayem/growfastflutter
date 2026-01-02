import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({super.key});

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null
                  ? "dd-mm-yyyy"
                  : "${selectedDate!.day.toString().padLeft(2, '0')}-"
                        "${selectedDate!.month.toString().padLeft(2, '0')}-"
                        "${selectedDate!.year}",
              style: TextStyle(
                fontSize: 16,
                color: selectedDate == null
                    ? lightGreyTextColor.withValues(alpha: 0.4)
                    : Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 22),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }
}
