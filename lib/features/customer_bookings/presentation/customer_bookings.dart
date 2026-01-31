import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource/bookings_remote_datasource.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_list_cubit.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_card.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

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
        appBar: CustomerHomeAppBar(singleTitle: "Booking List", backOpensDrawer: true),
        body: BlocConsumer<BookingsListCubit, BookingsListState>(
          listener: (context, state) {
            if (state is BookingsListUnauthorized) {
              _handleUnauthorized();
            }
          },
          builder: (context, state) {
            if (state is BookingsListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingsListUnauthorized) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingsListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    verticalMargin16,
                    Text(
                      'Failed to load bookings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    verticalMargin8,
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    verticalMargin16,
                    ElevatedButton(
                      onPressed: () => _bookingsListCubit.loadBookings(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is BookingsListLoaded) {
              if (state.bookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Colors.grey,
                      ),
                      verticalMargin16,
                      Text(
                        'No Bookings Yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      verticalMargin8,
                      Text(
                        'Your bookings will appear here',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _bookingsListCubit.loadBookings(),
                child: ListView.separated(
                  padding: horizontalPadding16,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];
                    return InkWell(
                      child: CustomerBookingCard(booking: booking),
                    );
                  },
                  separatorBuilder: (context, index) => verticalMargin8,
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
}
