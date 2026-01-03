import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/booking_location_card.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_additional_service_card.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_text_field.dart';

class CustomerBookingAddPersonalInformation extends StatelessWidget {
  const CustomerBookingAddPersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Add Personal Information"),
      body: SingleChildScrollView(
        child: Padding(
          padding: verticalPadding12 + horizontalPadding16,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              CustomerBookingAdditionalServiceCard(
                title: "Ceiling Fans Repairs",
                imageUrl:
                    "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                price: 400,
                duration: "30 min",
                rating: 4.9,
                reviews: 255,
                isSelected: true,
                onAdd: () {},
                isCardSelectionEnabled: false,
              ),
              CustomerBookingAdditionalServiceCard(
                title: "AC Cleaning",
                imageUrl:
                    "https://plus.unsplash.com/premium_photo-1664536392896-cd1743f9c02c?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW4lMjBiZWluZ3N8ZW58MHx8MHx8fDA%3D",
                price: 400,
                duration: "30 min",
                rating: 4.9,
                reviews: 255,
                isSelected: true,
                onAdd: () {},
                isCardSelectionEnabled: false,
              ),
              CustomerBookingAdditionalServiceCard(
                title: "Switches Changes",
                imageUrl:
                    "http://laravel.test/storage/services/XizJH1aguhYRN9BQovGI9AwBTUGkpenPQuo8vRoZ.jpg",
                price: 400,
                duration: "30 min",
                rating: 4.9,
                reviews: 255,
                isSelected: true,
                onAdd: () {},
                isCardSelectionEnabled: false,
              ),
              verticalMargin16,
              Text("Location", style: context.labelLarge),
              verticalMargin8,
              Row(
                children: [
                  Container(
                    padding: allPadding12,
                    decoration: BoxDecoration(
                      gradient: basicGradient,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: whiteColor,
                      size: 21,
                    ),
                  ),
                  horizontalMargin8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Pune",
                          style: context.labelSmall.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "AC Services - Kothrud Shop",
                          style: context.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalMargin16,
              Text("Staff", style: context.labelLarge),
              verticalMargin8,
              CustomerBooking(
                statusButtonText: "08 Services",
                showEmail: "suraj546@gmail.com",
                showLocation: false,
              ),
              verticalMargin16,
              Text("Date & Time", style: context.labelLarge),
              verticalMargin8,
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 17),
                  horizontalMargin4,
                  Text.rich(
                    TextSpan(
                      text: "Date: Fri, ",
                      children: [
                        TextSpan(
                          text: "12 Sep 2025",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              verticalMargin24,
              Text(
                "Name",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "suraj3894",
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text(
                "Email Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "youremail@domain.com",
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text(
                "Phone Number",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "+91 1234568790",
                keyboardType: TextInputType.phone,
              ),
              verticalMargin16,
              Text(
                "Street Address",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "2464 Royal Ln. Mesa",
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text(
                "State",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "Maharashtra",
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text(
                "Postal Code",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "411001",
                keyboardType: TextInputType.text,
              ),
              verticalMargin16,
              Text(
                "Add Booking Notes",
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalMargin8,
              CustomTextField(
                controller: TextEditingController(),
                hintText: "Description",
                contentPadding: verticalPadding16,
                keyboardType: TextInputType.text,
              ),
              verticalMargin24,
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    "Cancellation policy",
                    style: context.labelLarge.copyWith(
                      color: lightGreyTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  verticalMargin12,
                  Text(
                    "Cancel for free anytime in advance, otherwise\nyou will be charged 100% of the service price\nfor not showing up.",
                    style: context.labelSmall.copyWith(
                      color: lightGreyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              verticalMargin48,
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        onPressedOne: () {
          context.pushNamed(AppRouterNames.customerCart);
        },
      ),
    );
  }
}
