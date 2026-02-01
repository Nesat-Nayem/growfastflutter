import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
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
import 'package:grow_first/features/widgets/skeleton_loader.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late DashboardCubit _dashboardCubit;
  final AppStore _appStore = sl<AppStore>();
  Map<String, dynamic>? _userData;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = DashboardCubit(
      DashboardRemoteDataSourceImpl(sl<Dio>()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLoginAndLoadData();
  }

  void _checkLoginAndLoadData() {
    if (!_appStore.isLoggedIn) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.goNamed(AppRouterNames.signIn);
        });
      }
    } else {
      _dashboardCubit.loadDashboard();
      _loadUserProfile();
    }
  }

  void _handleUnauthorized() async {
    await _appStore.clear();
    if (mounted) {
      context.goNamed(AppRouterNames.signIn);
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final dio = sl<Dio>();
      final response = await dio.get('customer/profile');
      if (response.data['status'] == 'success' && mounted) {
        setState(() {
          _userData = response.data['user'];
        });
        await _appStore.updateUser(response.data['user']);
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        await _appStore.clear();
        if (mounted) {
          context.goNamed(AppRouterNames.signIn);
        }
      }
    }
  }

  Future<void> _onRefresh() async {
    _dashboardCubit.loadDashboard();
    await _loadUserProfile();
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
    final userName = _userData?['name'] ?? _appStore.user?.name ?? 'Guest';
    final userEmail = _userData?['email'] ?? _appStore.user?.email;
    final userPhone = _userData?['phone'] ?? _appStore.user?.phone;
    final userImage = _userData?['image'] ?? _appStore.user?.image;
    final userContact = userEmail ?? userPhone ?? '';

    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        appBar: CustomerHomeAppBar(
          backOpensDrawer: true,
          actions: [
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                final isLoading = state is DashboardLoading;
                return IconButton(
                  onPressed: isLoading ? null : _onRefresh,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: aquaBlueColor,
                            ),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            color: aquaBlueColor,
                            key: const ValueKey('refresh'),
                          ),
                  ),
                  tooltip: 'Refresh',
                );
              },
            ),
            horizontalMargin8,
          ],
        ),
        body: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state is DashboardUnauthorized) {
              _handleUnauthorized();
            }
          },
          builder: (context, state) {
            if (state is DashboardLoading) {
              return _buildSkeletonLoading();
            }

            if (state is DashboardError) {
              return _buildErrorState(state.message);
            }

            String totalBookings = '0';
            List<dynamic> recentBookings = [];

            if (state is DashboardLoaded) {
              totalBookings = (state.data['total_bookings'] ?? 0).toString();
              recentBookings = state.data['recent_bookings'] ?? [];
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: aquaBlueColor,
              child: ListView(
                padding: horizontalPadding16,
                children: [
                  verticalMargin16,
                  _buildUserInfoSection(userName, userContact, userImage),
                  verticalMargin24,
                  _buildDashboardSection(totalBookings),
                  verticalMargin24,
                  _buildRecentBookingsSection(recentBookings),
                  verticalMargin48,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Padding(
      padding: horizontalPadding16,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 16),
          DashboardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: horizontalPadding24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: allPadding24,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            verticalMargin24,
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            verticalMargin8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            verticalMargin24,
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: aquaBlueColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(String userName, String userContact, dynamic userImage) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          backgroundImage: userImage != null && userImage.toString().isNotEmpty
              ? CachedNetworkImageProvider(
                  userImage.toString().startsWith('http')
                      ? userImage.toString()
                      : _getImageUrl(userImage.toString()),
                )
              : null,
          child: userImage == null || userImage.toString().isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        horizontalMargin12,
        Expanded(
          child: Column(
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
              if (userContact.isNotEmpty)
                Text(
                  userContact,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardSection(String totalBookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dashboard",
          style: context.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalMargin16,
        DashboardStatCrump(
          title: "Total Orders",
          icon: AppAssets.iconCartSvg,
          percent: "",
          isProfit: true,
          statValue: totalBookings,
          displayCurrency: false,
          backgroundIconColor: lightPastelPinkColor,
        ),
      ],
    );
  }

  Widget _buildRecentBookingsSection(List<dynamic> recentBookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Bookings",
          style: context.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalMargin12,
        if (recentBookings.isEmpty)
          Container(
            padding: allPadding24,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  verticalMargin8,
                  Text(
                    'No bookings yet',
                    style: context.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RecentBookingTile(
                title: service?['title'] ?? 'Service',
                date: booking['created_at']?.toString().split('T')[0] ?? '',
                imageUrl: imageUrl,
              ),
            );
          }),
      ],
    );
  }
}
