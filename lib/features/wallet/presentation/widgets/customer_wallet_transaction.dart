import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerWalletTransaction extends StatelessWidget {
  const CustomerWalletTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12 + horizontalPadding4,
      margin: verticalPadding8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Type",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(child: Text("Amount", style: context.labelMedium)),
              Expanded(child: Text("Date & Time", style: context.labelMedium)),
            ],
          ),
          verticalMargin8,
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Wallet Topup",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "+₹ 80",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: aquaGreenColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "07 Aug 2025 11:22:02",
                  style: context.labelSmall.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          verticalMargin16,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Payment Type",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Status",
                  style: context.labelLarge.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(),
            ],
          ),
          verticalMargin8,
          Row(
            children: [
              Text(
                "Paypal",
                style: context.labelLarge.copyWith(fontWeight: FontWeight.w400),
              ),
              horizontalMargin48,
              horizontalMargin24,
              StatusButton(
                title: "Completed",
                backgroundColor: aquaGreenColor.withValues(alpha: 0.15),
                titleColor: aquaGreenColor,
              ),
              SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
