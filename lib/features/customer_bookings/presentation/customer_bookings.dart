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
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerBookingsPage extends StatefulWidget {
  const CustomerBookingsPage({super.key});

  @override
  State<CustomerBookingsPage> createState() => _CustomerBookingsPageState();
}

class _CustomerBookingsPageState extends State<CustomerBookingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BookingsListCubit _bookingsListCubit;

  @override
  void initState() {
    super.initState();
    _bookingsListCubit = BookingsListCubit(
      BookingsRemoteDataSourceImpl(sl<Dio>()),
    );
    
    // Check if user is logged in
    final appStore = sl<AppStore>();
    if (!appStore.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(AppRouterNames.signIn);
      });
    } else {
      _bookingsListCubit.loadBookings();
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
        appBar: CustomerHomeAppBar(singleTitle: "Booking List"),
        drawer: ModernCustomerDrawer(),
        body: BlocBuilder<BookingsListCubit, BookingsListState>(
          builder: (context, state) {
            if (state is BookingsListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingsListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
                      const Icon(Icons.event_busy, size: 48, color: Colors.grey),
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
                      // onTap: () {
                      //   context.pushNamed(
                      //     AppRouterNames.customerBookingDetail,
                      //     pathParameters: {
                      //       "bookingId": booking['id'].toString(),
                      //     },
                      //   );
                      // },
                      child: CustomerBookingCard(
                        booking: booking,
                      ),
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
