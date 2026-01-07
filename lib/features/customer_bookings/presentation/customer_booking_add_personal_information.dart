import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/domain/usecases/add_to_cart_usecase.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/booking_location_card.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/customer_booking_additional_service_card.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_text_field.dart';

class CustomerBookingAddPersonalInformation extends StatefulWidget {
  final String listingId;
  final String locationId;
  final String staffId;
  final String date;
  final String time;

  const CustomerBookingAddPersonalInformation({
    super.key,
    required this.listingId,
    required this.locationId,
    required this.staffId,
    required this.date,
    required this.time,
  });

  @override
  State<CustomerBookingAddPersonalInformation> createState() =>
      _CustomerBookingAddPersonalInformationState();
}

class _CustomerBookingAddPersonalInformationState
    extends State<CustomerBookingAddPersonalInformation> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingsBloc, BookingsState>(
      bloc: sl<BookingsBloc>(),
      listener: (context, state) {
        if (state.cartId != null && !state.isAddingToCart) {
          context.pushNamed(AppRouterNames.customerCart);
        }
        if (state.errorAddingToCart != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorAddingToCart!)),
          );
        }
      },
      builder: (context, state) {
        final selectedStaff = state.selectedStaff;
        final selectedLocation = state.selectedLocation;
        final additionalServices = state.selectedAdditionalServices;

        return Scaffold(
          appBar: CustomerHomeAppBar(singleTitle: "Add Personal Information"),
          body: SingleChildScrollView(
            child: Padding(
              padding: verticalPadding12 + horizontalPadding16,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  ...additionalServices.map(
                    (service) => CustomerBookingAdditionalServiceCard(
                      title: service.title,
                   imageUrl: state.selectedLocation?.serviceImage ?? service.image ?? 'https://via.placeholder.com/100x100?text=No+Image',
                          
                      price: service.price,
                      duration: "${service.duration} ${service.durationUnit}",
                      rating: 4.9,
                      reviews: 255,
                      isSelected: true,
                      onAdd: () {},
                      isCardSelectionEnabled: false,
                    ),
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
                              selectedLocation?.name ?? "Location",
                              style: context.labelSmall.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              selectedLocation?.address ?? "Address",
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
                    statusButtonText: "Selected Staff",
                    showEmail: selectedStaff?.email ?? "Staff Email",
                    showLocation: false,
                    bookingStaff: selectedStaff,
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
                          text: "Date: ",
                          children: [
                            TextSpan(
                              text: "${widget.date} | Time: ${widget.time}",
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
                    "First Name",
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalMargin8,
                  CustomTextField(
                    controller: _firstNameController,
                    hintText: "Enter your first name",
                    keyboardType: TextInputType.text,
                  ),
                  verticalMargin16,
                  Text(
                    "Last Name",
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalMargin8,
                  CustomTextField(
                    controller: _lastNameController,
                    hintText: "Enter your last name",
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
                    controller: _emailController,
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
                    controller: _phoneController,
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
                    controller: _addressController,
                    hintText: "Street Address",
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
                    controller: _stateController,
                    hintText: "State",
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
                    controller: _postalCodeController,
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
                    controller: _notesController,
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
          bottomNavigationBar: state.isAddingToCart
              ? const Center(child: CircularProgressIndicator())
              : CustomBottomNavNextBackBtns(
                  onPressedOne: () {
                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill all required fields")),
                      );
                      return;
                    }

                    sl<BookingsBloc>().add(AddToCart(AddToCartParams(
                      staffId: int.parse(widget.staffId),
                      serviceId: int.parse(widget.listingId),
                      bookingDate: widget.date,
                      bookingTime: widget.time,
                      bookingNotes: _notesController.text,
                      additionalServiceIds: additionalServices
                          .map((service) => service.id)
                          .toList(),
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      streetAddress: _addressController.text,
                      postalCode: _postalCodeController.text,
                      country: selectedLocation?.country.toString() ?? "1",
                      state: selectedLocation?.state.toString() ?? "1",
                      city: selectedLocation?.city.toString() ?? "1",
                    )));
                  },
                ),
        );
      },
    );
  }
}
