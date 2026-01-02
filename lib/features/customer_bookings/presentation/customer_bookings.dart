import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_card.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerBookingsPage extends StatelessWidget {
  CustomerBookingsPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomerHomeAppBar(singleTitle: "Booking List"),
      drawer: ModernCustomerDrawer(),
      body: ListView.separated(
        padding: horizontalPadding16,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.pushNamed(
                AppRouterNames.customerBookingDetail,
                pathParameters: {"bookingId": "2378910"},
              );
            },
            child: CustomerBookingCard(),
          );
        },
        separatorBuilder: (context, index) => verticalMargin8,
        itemCount: 5,
      ),
    );
  }
}
