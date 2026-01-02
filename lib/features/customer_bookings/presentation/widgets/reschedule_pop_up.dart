import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';

class ReschedulePopUp extends StatelessWidget {
  const ReschedulePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, minWidth: 300),
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Reschedule Appointment",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: 23,
                      ),
                    ],
                  ),
                  verticalMargin16,
                  Text(
                    "Appointment Date",
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalMargin8,
                  TextField(
                    decoration: InputDecoration(
                      enabled: false,
                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 16),
                      hint: Text(
                        "DD/MM/YYY",
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: lightGreyTextColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightGreyColor,
                          width: 0.2,
                        ),
                      ),
                      hintStyle: context.labelSmall,
                      contentPadding: horizontalPadding8 + verticalPadding8,
                    ),
                  ),
                  verticalMargin12,
                  Text(
                    "Appointment Time",
                    style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalMargin8,
                  TextField(
                    decoration: InputDecoration(
                      enabled: false,
                      suffixIcon: Icon(Icons.access_time_outlined, size: 17),
                      hint: Text(
                        "00:00:00",
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: lightGreyTextColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGreyColor),
                      ),
                      hintStyle: context.labelSmall,
                      contentPadding: horizontalPadding8 + verticalPadding8,
                    ),
                  ),
                  verticalMargin24,
                  GradientButton(onTap: () {}, text: "Save"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
