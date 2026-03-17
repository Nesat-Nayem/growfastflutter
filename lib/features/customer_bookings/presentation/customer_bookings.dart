import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource/bookings_remote_datasource.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_list_cubit.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_card.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/skeleton_loader.dart';

class CustomerBookingsPage extends StatefulWidget {
  const CustomerBookingsPage({super.key});

  @override
  State<CustomerBookingsPage> createState() => _CustomerBookingsPageState();
}

class _CustomerBookingsPageState extends State<CustomerBookingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BookingsListCubit _bookingsListCubit;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _bookingsListCubit = BookingsListCubit(
      BookingsRemoteDataSourceImpl(sl<Dio>()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBookingsIfLoggedIn();
  }

  void _loadBookingsIfLoggedIn() {
    final appStore = sl<AppStore>();
    if (!appStore.isLoggedIn) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.goNamed(AppRouterNames.signIn);
        });
      }
    } else {
      _bookingsListCubit.loadBookings();
    }
  }

  void _handleUnauthorized() async {
    await sl<AppStore>().clear();
    if (mounted) {
      context.goNamed(AppRouterNames.signIn);
    }
  }

  Future<void> _onRefresh() async {
    await _bookingsListCubit.loadBookings();
  }

  @override
  void dispose() {
    _bookingsListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookingsListCubit,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomerHomeAppBar(
          singleTitle: "Booking List",
          backOpensDrawer: true,
          actions: [
            BlocBuilder<BookingsListCubit, BookingsListState>(
              builder: (context, state) {
                final isLoading = state is BookingsListLoading;
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
        body: BlocConsumer<BookingsListCubit, BookingsListState>(
          listener: (context, state) {
            if (state is BookingsListUnauthorized) {
              _handleUnauthorized();
            }
          },
          builder: (context, state) {
            if (state is BookingsListLoading) {
              return _buildSkeletonLoading();
            }

            if (state is BookingsListUnauthorized) {
              return _buildSkeletonLoading();
            }

            if (state is BookingsListError) {
              return _buildErrorState(state.message);
            }

            if (state is BookingsListLoaded) {
              if (state.bookings.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: aquaBlueColor,
                child: ListView.separated(
                  padding: horizontalPadding16 + verticalPadding16,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];
                    return CustomerBookingCard(
                      booking: booking,
                      onRefresh: _onRefresh,
                    );
                  },
                  separatorBuilder: (context, index) => verticalMargin12,
                  itemCount: state.bookings.length,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.separated(
      padding: horizontalPadding16 + verticalPadding16,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => verticalMargin12,
      itemBuilder: (context, index) => const BookingCardSkeleton(),
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

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: aquaBlueColor,
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: allPadding24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event_busy_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
                verticalMargin24,
                Text(
                  'No Bookings Yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalMargin8,
                Text(
                  'Your bookings will appear here\nPull down to refresh',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
