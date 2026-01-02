import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_home/presentation/widgets/dashboard_stat_crump.dart';
import 'package:grow_first/features/customer_home/presentation/widgets/recent_booking_tile.dart';
import 'package:grow_first/features/customer_home/presentation/widgets/recent_transaction_tile.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(),
      drawer: ModernCustomerDrawer(),
      body: Padding(
        padding: horizontalPadding16,
        child: ListView(
          children: [
            verticalMargin16,
            Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                    horizontalMargin12,
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text.rich(
                          style: context.bodyLarge.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                          TextSpan(
                            text: "Hey, ",
                            children: [
                              TextSpan(
                                text: "Suraj Jandade",
                                style: context.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: aquaBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "hey@lokesh.com",
                          style: context.labelLarge.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalMargin24,
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Dashboard",
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    verticalMargin16,
                    Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: DashboardStatCrump(
                            title: "Total\nOrder",
                            icon: AppAssets.iconCartSvg,
                            percent: "16%",
                            isProfit: true,
                            statValue: "27",
                            displayCurrency: true,
                            backgroundIconColor: lightPastelPinkColor,
                          ),
                        ),
                        Expanded(
                          child: DashboardStatCrump(
                            title: "Total\nSpend",
                            icon: AppAssets.iconTotalSpendingSvg,
                            percent: "5%",
                            isProfit: false,
                            statValue: "2500",
                            displayCurrency: true,
                            backgroundIconColor: lightGreySnowColor,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin16,
                    Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: DashboardStatCrump(
                            title: "Wallet\n",
                            icon: AppAssets.iconWalletSvg,
                            percent: "5%",
                            isProfit: true,
                            statValue: "250",
                            displayCurrency: true,
                            backgroundIconColor: lightPastelGreenColor,
                          ),
                        ),
                        Expanded(
                          child: DashboardStatCrump(
                            title: "Total\nSaving",
                            icon: AppAssets.iconTotalSavingSvg,
                            percent: "16%",
                            isProfit: true,
                            statValue: "364",
                            displayCurrency: true,
                            backgroundIconColor: lightPastelVioletColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalMargin24,
                Text(
                  "Recent Transcation",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                ...[
                  RecentTransactionTile(
                    title: "Service Booking",
                    amount: "364",
                    date: "22 Sep 2023",
                    time: "17:00",
                    iconUrl:
                        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS4QuIrCBUg6V7b-Txul-X_8LDGM9HsTavFdVai9rVzBN3ilX6P",
                  ),
                  RecentTransactionTile(
                    title: "Service Booking",
                    amount: "364",
                    date: "22 Sep 2023",
                    time: "17:00",
                    iconUrl:
                        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS4QuIrCBUg6V7b-Txul-X_8LDGM9HsTavFdVai9rVzBN3ilX6P",
                  ),
                  RecentTransactionTile(
                    title: "Service Booking",
                    amount: "364",
                    date: "22 Sep 2023",
                    time: "17:00",
                    iconUrl:
                        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS4QuIrCBUg6V7b-Txul-X_8LDGM9HsTavFdVai9rVzBN3ilX6P",
                  ),
                ],
                verticalMargin16,
                Text(
                  "Recent Booking",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                verticalMargin8,
                RecentBookingTile(),
                RecentBookingTile(),
                RecentBookingTile(),
                verticalMargin48,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
