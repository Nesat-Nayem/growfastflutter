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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          verticalMargin16,
                          Text(
                            'Failed to load locations',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalMargin8,
                          Text(
                            state.errorLocationsFetching.toString(),
                            textAlign: TextAlign.center,
                            style: context.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }
                  if (state.locations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off, size: 48, color: Colors.grey),
                          verticalMargin16,
                          Text(
                            'No Locations Available',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalMargin8,
                          Text(
                            'This service has no available locations at the moment.',
                            textAlign: TextAlign.center,
                            style: context.bodySmall.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.locations.length,
                    itemBuilder: (context, index) {
                      final location = state.locations[index];
                      final isSelected = state.selectedLocation?.id == location.id;
                      return CustomerBooking(
                        bookingLocation: location,
                        isMainSelectLocationCard: true,
                        isSelected: isSelected,
                        onSelected: (val) {
                          sl<BookingsBloc>().add(SetSelectedBookingLocation(location));
                        },
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
