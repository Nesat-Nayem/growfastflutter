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
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = DashboardCubit(
      DashboardRemoteDataSourceImpl(sl<Dio>()),
    );
    if (_appStore.isLoggedIn) {
      _dashboardCubit.loadDashboard();
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final dio = sl<Dio>();
      final response = await dio.get('customer/profile');
      if (response.data['status'] == 'success') {
        setState(() {
          _userData = response.data['user'];
        });
        // Update AppStore with fresh data
        await _appStore.updateUser(response.data['user']);
      }
    } catch (e) {
      // Silently fail, use cached data
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
    // Use fresh data if available, otherwise fall back to AppStore
    final userName = _userData?['name'] ?? _appStore.user?.name ?? 'Guest';
    final userEmail = _userData?['email'] ?? _appStore.user?.email;
    final userPhone = _userData?['phone'] ?? _appStore.user?.phone;
    final userImage = _userData?['image'] ?? _appStore.user?.image;
    final userContact = userEmail ?? userPhone ?? '';

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
                            backgroundColor: Colors.grey[200],
                            backgroundImage: userImage != null && userImage.toString().isNotEmpty
                                ? CachedNetworkImageProvider(
                                    userImage.toString().startsWith('http') 
                                        ? userImage.toString() 
                                        : _getImageUrl(userImage.toString())
                                  )
                                : null,
                            child: userImage == null || userImage.toString().isEmpty
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
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
                                      text: userName,
                                      style: context.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: aquaBlueColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                userContact,
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
                            DashboardStatCrump(
                              title: "Total Orders",
                              icon: AppAssets.iconCartSvg,
                              percent: "",
                              isProfit: true,
                              statValue: totalBookings,
                              displayCurrency: false,
                              backgroundIconColor: lightPastelPinkColor,
                            ),
                            // Wallet Balance - Hidden for now
                            // Expanded(
                            //   child: DashboardStatCrump(
                            //     title: "Wallet\nBalance",
                            //     icon: AppAssets.iconWalletSvg,
                            //     percent: "",
                            //     isProfit: true,
                            //     statValue: walletBalance,
                            //     displayCurrency: true,
                            //     backgroundIconColor: lightPastelGreenColor,
                            //   ),
                            // ),
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
