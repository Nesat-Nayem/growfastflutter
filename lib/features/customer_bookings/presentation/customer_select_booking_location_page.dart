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
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerSelectBookingLocationPage extends StatefulWidget {
  const CustomerSelectBookingLocationPage({super.key, required this.listingId});

  final String listingId;

  @override
  State<CustomerSelectBookingLocationPage> createState() =>
      _CustomerSelectBookingLocationPageState();
}

class _CustomerSelectBookingLocationPageState
    extends State<CustomerSelectBookingLocationPage> {
  @override
  void initState() {
    sl<BookingsBloc>().add(LoadBookingLocations(int.parse(widget.listingId)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Select Location"),
      body: Padding(
        padding: verticalPadding12 + horizontalPadding16,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Select Location |  ",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BlocBuilder<BookingsBloc, BookingsState>(
                  bloc: sl<BookingsBloc>(),
                  builder: (context, state) {
                    return StatusButton(
                      title: "Total : ${state.locations.length}",
                      backgroundColor: Color(0XFFF0EBFD),
                      titleColor: violetBlueColor,
                    );
                  },
                ),
              ],
            ),
            verticalMargin16,
            Expanded(
              child: BlocBuilder<BookingsBloc, BookingsState>(
                bloc: sl<BookingsBloc>(),
                builder: (context, state) {
                  if (state.isLocationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorLocationsFetching != null) {
                    return Center(
                      child: Text(state.errorLocationsFetching.toString()),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.locations.length,
                    itemBuilder: (context, index) {
                      return CustomerBooking(
                        bookingLocation: state.locations[index],
                        isMainSelectLocationCard: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: verticalPadding12 + horizontalPadding16,
          child: Column(
            mainAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              GradientButton(
                text: "Next",
                onTap: () {
                  final selectedLocation =
                      sl<BookingsBloc>().state.selectedLocation;
                  context.pushNamed(
                    AppRouterNames.customerSelectBookingStaff,
                    pathParameters: {
                      "listingId": widget.listingId.toString(),
                      "locationId": selectedLocation?.id.toString() ?? "",
                    },
                  );
                },
                iconWithTitle: Padding(
                  padding: horizontalPadding4 / 2,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: whiteColor,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
