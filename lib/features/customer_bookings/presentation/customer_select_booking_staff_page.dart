import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/booking_location_card.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerSelectBookingStaffPage extends StatefulWidget {
  const CustomerSelectBookingStaffPage({
    super.key,
    required this.listingId,
    required this.locationId,
  });

  final String listingId;
  final String locationId;

  @override
  State<CustomerSelectBookingStaffPage> createState() =>
      _CustomerSelectBookingStaffPageState();
}

class _CustomerSelectBookingStaffPageState
    extends State<CustomerSelectBookingStaffPage> {
  @override
  void initState() {
    sl<BookingsBloc>().add(
      LoadBookingStaffs(
        country: sl<BookingsBloc>().state.selectedLocation!.country,
        state: sl<BookingsBloc>().state.selectedLocation!.state,
        city: sl<BookingsBloc>().state.selectedLocation!.city,
        serviceId: int.parse(widget.listingId),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Staff"),
      body: Padding(
        padding: verticalPadding12 + horizontalPadding16,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Select Staff |  ",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BlocBuilder<BookingsBloc, BookingsState>(
                  bloc: sl<BookingsBloc>(),
                  builder: (context, state) {
                    return StatusButton(
                      title: "Total : ${state.staffs.length}",
                      backgroundColor: Color(0XFFF0EBFD),
                      titleColor: violetBlueColor,
                    );
                  },
                ),
              ],
            ),
            verticalMargin16,
            BlocBuilder<BookingsBloc, BookingsState>(
              bloc: sl<BookingsBloc>(),
              builder: (context, state) {
                if (state.isStaffLoading) {
                  return Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.errorStaffFetching != null) {
                  return Expanded(
                    child: Center(
                      child: Text(state.errorStaffFetching.toString()),
                    ),
                  );
                }
                if (state.staffs.isEmpty) {
                  return const Center(child: Text("No Staffs Available"));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.staffs.length,
                    itemBuilder: (context, index) {
                      return CustomerBooking(
                        statusButtonText: "{Pending From API} Services",
                        showEmail: state.staffs[index].email,
                        showLocation: false,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        showSelectAnyoneOption: true,
        onPressedOne: () {
          context.pushNamed(
            AppRouterNames.customerSelectAdditionalServiceBooking,
            pathParameters: {
              "listingId": widget.listingId,
              "locationId": widget.locationId,
              "staffId": sl<BookingsBloc>().state.staffs.isNotEmpty
                  ? sl<BookingsBloc>().state.staffs[0].id.toString()
                  : "0",
            },
          );
        },
      ),
    );
  }
}
