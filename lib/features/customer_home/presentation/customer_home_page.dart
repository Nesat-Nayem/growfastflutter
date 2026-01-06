import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_home/data/remote_datasource/dashboard_remote_datasource.dart';
import 'package:grow_first/features/customer_home/presentation/bloc/dashboard_cubit.dart';
import 'package:grow_first/features/customer_home/presentation/widgets/dashboard_stat_crump.dart';
import 'package:grow_first/features/customer_home/presentation/widgets/recent_booking_tile.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late DashboardCubit _dashboardCubit;
  final AppStore _appStore = sl<AppStore>();

  @override
  void initState() {
    super.initState();
    _dashboardCubit = DashboardCubit(
      DashboardRemoteDataSourceImpl(sl<Dio>()),
    );
    if (_appStore.isLoggedIn) {
      _dashboardCubit.loadDashboard();
    }
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  String _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    final config = sl<AppConfig>();
    return '${config.imageBaseUrl}/storage/$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final user = _appStore.user;
    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        appBar: CustomerHomeAppBar(),
        drawer: ModernCustomerDrawer(),
        body: Padding(
          padding: horizontalPadding16,
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              // Default values
              String totalBookings = '0';
              String walletBalance = '0';
              List<dynamic> recentBookings = [];

              if (state is DashboardLoaded) {
                totalBookings = (state.data['total_bookings'] ?? 0).toString();
                walletBalance = (state.data['wallet_balance'] ?? 0).toString();
                recentBookings = state.data['recent_bookings'] ?? [];
              }

              return ListView(
                children: [
                  verticalMargin16,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Section
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: user?.image != null
                                ? CachedNetworkImageProvider(_getImageUrl(user!.image))
                                : const CachedNetworkImageProvider(
                                    "https://via.placeholder.com/100x100?text=User",
                                  ),
                          ),
                          horizontalMargin12,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                style: context.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                TextSpan(
                                  text: "Hey, ",
                                  children: [
                                    TextSpan(
                                      text: user?.name ?? 'Guest',
                                      style: context.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: aquaBlueColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                user?.email ?? user?.phone ?? '',
                                style: context.labelLarge.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalMargin24,
                      // Dashboard Stats Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                            style: context.labelLarge.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          verticalMargin16,
                          if (state is DashboardLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: DashboardStatCrump(
                                    title: "Total\nOrders",
                                    icon: AppAssets.iconCartSvg,
                                    percent: "",
                                    isProfit: true,
                                    statValue: totalBookings,
                                    displayCurrency: false,
                                    backgroundIconColor: lightPastelPinkColor,
                                  ),
                                ),
                                Expanded(
                                  child: DashboardStatCrump(
                                    title: "Wallet\nBalance",
                                    icon: AppAssets.iconWalletSvg,
                                    percent: "",
                                    isProfit: true,
                                    statValue: walletBalance,
                                    displayCurrency: true,
                                    backgroundIconColor: lightPastelGreenColor,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      verticalMargin24,
                      // Recent Bookings Section
                      Text(
                        "Recent Bookings",
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalMargin8,
                      if (state is DashboardLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (recentBookings.isEmpty)
                        Container(
                          padding: allPadding16,
                          child: Center(
                            child: Text(
                              'No bookings yet',
                              style: context.bodyMedium.copyWith(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...recentBookings.take(5).map((booking) {
                          final service = booking['service'];
                          final gallery = service?['gallery'] as List?;
                          String? imageUrl;
                          if (gallery != null && gallery.isNotEmpty) {
                            imageUrl = _getImageUrl(gallery[0]['img']);
                          }
                          return RecentBookingTile(
                            title: service?['title'] ?? 'Service',
                            date: booking['created_at']?.toString().split('T')[0] ?? '',
                            imageUrl: imageUrl,
                          );
                        }),
                      verticalMargin48,
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
