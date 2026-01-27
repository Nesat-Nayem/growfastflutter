import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/wallet/presentation/widgets/customer_wallet_transaction.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerWalletPage extends StatelessWidget {
  const CustomerWalletPage({super.key});

  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ModernCustomerDrawer(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _openDrawer(context),
        ),
        title: Text(
          "Wallet",
          style: context.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: whiteColor,
      ),
      body: Padding(
        padding: horizontalPadding16,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                verticalMargin12,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: allPadding8 + verticalPadding4,
                        decoration: BoxDecoration(
                          border: Border.all(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Container(
                              padding: allPadding4,
                              decoration: BoxDecoration(
                                color: Color(0XFF30D3D9),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: SvgPicture.asset(
                                AppAssets.iconCartSvg,
                                height: 19,
                              ),
                            ),
                            verticalMargin8,
                            Text(
                              "Wallet Balance",
                              style: context.labelMedium.copyWith(
                                color: lightGreyTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalMargin8,
                            Text.rich(
                              TextSpan(
                                text: "₹",
                                style: context.labelLarge.copyWith(
                                  color: lightGreyTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "3510.04",
                                    style: context.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    horizontalMargin24,
                    Expanded(
                      child: Container(
                        padding: allPadding8 + verticalPadding4,
                        decoration: BoxDecoration(
                          border: Border.all(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Container(
                              padding: allPadding4,
                              decoration: BoxDecoration(
                                color: lightPastelGreenColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: SvgPicture.asset(
                                AppAssets.iconCreditSvg,
                                height: 19,
                              ),
                            ),
                            verticalMargin8,
                            Text(
                              "Total Credit",
                              style: context.labelMedium.copyWith(
                                color: lightGreyTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalMargin8,
                            Text.rich(
                              TextSpan(
                                text: "₹",
                                style: context.labelLarge.copyWith(
                                  color: lightGreyTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "3510.04",
                                    style: context.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                verticalMargin16,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: allPadding8 + verticalPadding4,
                        decoration: BoxDecoration(
                          border: Border.all(color: lightGreyColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Container(
                              padding: allPadding4,
                              decoration: BoxDecoration(
                                color: lightPastelPinkColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: SvgPicture.asset(
                                AppAssets.iconDebitSvg,
                                height: 19,
                              ),
                            ),
                            verticalMargin8,
                            Row(
                              crossAxisAlignment: .start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Debit",
                                    style: context.labelMedium.copyWith(
                                      color: lightGreyTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: "₹",
                                    style: context.labelLarge.copyWith(
                                      color: lightGreyTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "3510.04",
                                        style: context.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                horizontalMargin16,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                verticalMargin24,
                Text(
                  "Wallet Transaction",
                  style: context.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                verticalMargin16,
                CustomerWalletTransaction(),
                CustomerWalletTransaction(),
                CustomerWalletTransaction(),
                CustomerWalletTransaction(),
                CustomerWalletTransaction(),
                CustomerWalletTransaction(),
                verticalMargin48,
                verticalMargin48,
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: allPadding16,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0XFF10326B), Color(0XFF10326B), Color(0XFF30D3D9)],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          Icons.add,
          size: 37,
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
