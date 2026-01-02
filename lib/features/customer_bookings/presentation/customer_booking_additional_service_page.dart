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
                  return Center(
                    child: Text(state.errorAdditionalSerciceFetching!),
                  );
                } else if (state.serviceDetail == null ||
                    state.serviceDetail!.isEmpty) {
                  return Expanded(
                    child: Center(child: Text("No Additional Services Found")),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.serviceDetail?.length,
                      itemBuilder: (context, index) {
                        return CustomerBookingAdditionalServiceCard(
                          title: state.serviceDetail![index].title,
                          imageUrl:
                              "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          price: state.serviceDetail?[index].price ?? 0.00,
                          duration:
                              "${state.serviceDetail?[index].duration} ${state.serviceDetail?[index].durationUnit}",
                          rating: 4.9,
                          reviews: 255,
                          isSelected: true,
                          onAdd: () {},
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
              "listingId": "1132323",
              "locationId": "464662",
              "staffId": "12342",
            },
          );
        },
      ),
    );
  }
}
