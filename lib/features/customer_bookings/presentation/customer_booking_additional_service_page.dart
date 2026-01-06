import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_additional_service_card.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class CustomerBookingAdditionalServicePage extends StatefulWidget {
  const CustomerBookingAdditionalServicePage({
    super.key,
    required this.listingId,
    required this.locationId,
    required this.staffId,
  });

  final String listingId;
  final String locationId;
  final String staffId;

  @override
  State<CustomerBookingAdditionalServicePage> createState() =>
      _CustomerBookingAdditionalServicePageState();
}

class _CustomerBookingAdditionalServicePageState
    extends State<CustomerBookingAdditionalServicePage> {
  @override
  void initState() {
    sl<BookingsBloc>().add(
      LoadBookingServiceDetail(int.parse(widget.listingId)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Additional Service"),
      body: Padding(
        padding: verticalPadding12 + horizontalPadding16,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Select Additional Service |  ",
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BlocBuilder<BookingsBloc, BookingsState>(
                  bloc: sl<BookingsBloc>(),
                  builder: (context, state) {
                    return StatusButton(
                      title: "Total : ${state.serviceDetail?.length ?? 0}",
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
                if (state.isAdditionalServiceLoading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: violetBlueColor),
                    ),
                  );
                } else if (state.errorAdditionalSerciceFetching != null) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          verticalMargin16,
                          Text(
                            'Failed to load services',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalMargin8,
                          Text(
                            state.errorAdditionalSerciceFetching!,
                            textAlign: TextAlign.center,
                            style: context.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state.serviceDetail == null ||
                    state.serviceDetail!.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_business_outlined, size: 48, color: Colors.grey),
                          verticalMargin16,
                          Text(
                            'No Additional Services',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalMargin8,
                          Text(
                            'This service has no additional services available.',
                            textAlign: TextAlign.center,
                            style: context.bodySmall.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.serviceDetail?.length,
                      itemBuilder: (context, index) {
                        final service = state.serviceDetail![index];
                        final isSelected = state.selectedAdditionalServices
                            .any((s) => s.id == service.id);
                        return CustomerBookingAdditionalServiceCard(
                          title: service.title,
                          imageUrl: service.image ?? 'https://via.placeholder.com/100x100?text=No+Image',
                          price: service.price,
                          duration:
                              "${service.duration} ${service.durationUnit}",
                          rating: 4.9,
                          reviews: 0,
                          isSelected: isSelected,
                          onAdd: () {
                            sl<BookingsBloc>().add(ToggleAdditionalService(service));
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        onPressedOne: () {
          context.pushNamed(
            AppRouterNames.customerSelectDateAndTimeForBooking,
            pathParameters: {
              "listingId": widget.listingId,
              "locationId": widget.locationId,
              "staffId": widget.staffId,
            },
          );
        },
      ),
    );
  }
}
