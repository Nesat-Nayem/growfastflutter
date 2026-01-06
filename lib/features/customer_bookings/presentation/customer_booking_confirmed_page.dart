import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:intl/intl.dart';

class CustomerBookingConfirmedPage extends StatefulWidget {
  final String? bookingDate;
  final String? bookingTime;
  final String? bookingRef;

  const CustomerBookingConfirmedPage({
    super.key,
    this.bookingDate,
    this.bookingTime,
    this.bookingRef,
  });

  @override
  State<CustomerBookingConfirmedPage> createState() =>
      _CustomerBookingConfirmedPageState();
}

class _CustomerBookingConfirmedPageState
    extends State<CustomerBookingConfirmedPage> {
  
  String _formatDateTime(String? date, String? time) {
    if (date == null) return 'Date not available';
    
    try {
      final dateTime = DateTime.parse(date);
      final formattedDate = DateFormat('EEE dd MMMM yyyy').format(dateTime);
      
      if (time != null && time.isNotEmpty) {
        return '$formattedDate at $time';
      }
      return formattedDate;
    } catch (e) {
      return date;
    }
  }

  double _calculateSubTotal(BookingsState state) {
    double total = 0;
    
    // Add main service price if available from location
    if (state.selectedLocation?.serviceTitle != null) {
      // Main service price would come from service detail, using 0 as placeholder
      total += 0;
    }
    
    // Add additional services
    for (var service in state.selectedAdditionalServices) {
      total += service.price;
    }
    
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      bloc: sl<BookingsBloc>(),
      builder: (context, state) {
        final selectedLocation = state.selectedLocation;
        final additionalServices = state.selectedAdditionalServices;
        final subTotal = _calculateSubTotal(state);
        final tax = subTotal * 0.05; // 5% GST
        final discount = 0.0; // No discount info available
        final total = subTotal + tax - discount;

        return Scaffold(
          appBar: CustomerHomeAppBar(singleTitle: "Confirmed"),
          body: SingleChildScrollView(
            child: Padding(
              padding: verticalPadding12 + horizontalPadding16,
              child: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(AppAssets.successCheckMarkSvg, height: 55),
                    verticalMargin16,
                    Text(
                      "Your Booking is Successfully Confirmed",
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalMargin12,
                    Text(
                      _formatDateTime(widget.bookingDate, widget.bookingTime),
                      style: context.labelMedium.copyWith(
                        color: lightGreyTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalMargin32,
                    Container(
                      margin: bottomPadding16,
                      padding: allPadding16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: selectedLocation?.serviceImage ??
                                  'https://via.placeholder.com/100x100?text=No+Image',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                          horizontalMargin12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedLocation?.serviceTitle ?? 'Service',
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.bookingRef != null) ...[
                                  verticalMargin4,
                                  Text(
                                    'Booking ref. #${widget.bookingRef}',
                                    style: context.labelSmall.copyWith(
                                      color: lightGreyTextColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalMargin24,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show additional services
                        ...additionalServices.map((service) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildItemRow(
                            service.title,
                            '₹${service.price.toStringAsFixed(0)}',
                            '${service.duration} ${service.durationUnit}',
                          ),
                        )),

                        if (additionalServices.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 12),
                        ],

                        if (subTotal > 0) ...[
                          _buildSummaryRow('Sub Total', '₹${subTotal.toStringAsFixed(0)}'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Tax (GST 5%)', '₹${tax.toStringAsFixed(0)}'),
                          const SizedBox(height: 8),
                          if (discount > 0)
                            _buildSummaryRow('Discount', '-₹${discount.toStringAsFixed(0)}'),
                          
                          verticalMargin24,
                          _buildTotalRow('Total', '₹${total.toStringAsFixed(0)}'),
                        ],

                        if (additionalServices.isEmpty)
                          Center(
                            child: Padding(
                              padding: verticalPadding24,
                              child: Text(
                                'No additional services selected',
                                style: context.bodySmall.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                        verticalMargin24,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Padding(
              padding: bottomPadding12 + horizontalPadding16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientButton(
                    text: "Go to Home",
                    onTap: () {
                      context.goNamed(AppRouterNames.home);
                    },
                    iconWithTitle: Padding(
                      padding: horizontalPadding4 / 2,
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: whiteColor,
                        size: 17,
                      ),
                    ),
                    textStyle: context.labelLarge.copyWith(color: whiteColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemRow(String title, String price, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.labelMedium),
            verticalMargin2,
            Text(
              time,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Text(price, style: context.labelMedium),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.labelMedium),
        Text(value, style: context.labelMedium),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
