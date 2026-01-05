import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/data/remote_datasource_impl/booking_remote_datasource_impl.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:intl/intl.dart';

class CustomerSelectDataAndTimeForBookingPage extends StatefulWidget {
  const CustomerSelectDataAndTimeForBookingPage({
    super.key,
    required this.listingId,
    required this.locationId,
    required this.staffId,
  });

  final String listingId;
  final String locationId;
  final String staffId;

  @override
  State<CustomerSelectDataAndTimeForBookingPage> createState() =>
      _CustomerSelectDataAndTimeForBookingPageState();
}

class _CustomerSelectDataAndTimeForBookingPageState
    extends State<CustomerSelectDataAndTimeForBookingPage> {
  List<String> availableSlots = [];
  bool isLoading = true;
  bool hasSlots = false;

  @override
  void initState() {
    super.initState();
    _fetchServiceSlots();
  }

  Future<void> _fetchServiceSlots() async {
    try {
      final dio = sl<Dio>();
      final dataSource = BookingRemoteDataSourceImpl(dio);
      final result = await dataSource.getServiceSlots(int.parse(widget.listingId));
      
      setState(() {
        hasSlots = result['hasSlots'] as bool;
        if (hasSlots) {
          final slots = result['slots'] as List;
          availableSlots = slots.map((slot) {
            final from = slot['from']?.toString() ?? '';
            return from;
          }).where((s) => s.isNotEmpty).toList();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasSlots = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Select Date & Time"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return _CustomerSelectDataAndTimeForBookingPageContent(
      listingId: widget.listingId,
      locationId: widget.locationId,
      staffId: widget.staffId,
      startDate: DateTime.now(),
      daysToShow: 7,
      bookedSlots: [],
      availableSlots: availableSlots,
      hasTimeSlots: hasSlots,
      onNext: (date, time) {
        print("Selected Date: $date");
        print("Selected Time: $time");
      },
    );
  }
}

class _CustomerSelectDataAndTimeForBookingPageContent extends StatefulWidget {
  final String listingId;
  final String locationId;
  final String staffId;
  final DateTime startDate;
  final int daysToShow;
  final List<String> bookedSlots;
  final List<String> availableSlots;
  final bool hasTimeSlots;
  final Function(DateTime date, String time) onNext;

  const _CustomerSelectDataAndTimeForBookingPageContent({
    required this.listingId,
    required this.locationId,
    required this.staffId,
    required this.startDate,
    this.daysToShow = 7,
    required this.bookedSlots,
    required this.availableSlots,
    required this.hasTimeSlots,
    required this.onNext,
  });

  @override
  State<_CustomerSelectDataAndTimeForBookingPageContent> createState() =>
      __CustomerSelectDataAndTimeForBookingPageContentState();
}

class __CustomerSelectDataAndTimeForBookingPageContentState
    extends State<_CustomerSelectDataAndTimeForBookingPageContent> {
  late DateTime selectedDate;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.startDate;
  }

  LinearGradient get _selectedTileGradient {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [Color(0xFF10326B), Color(0xFF10326B), Color(0xFF30D3D9)],
      stops: const [-1.4273, -0.2136, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Select Date & Time"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalMargin12,
            const Text(
              "Select Date & Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            verticalMargin12,
            _buildMonthHeader(),
            verticalMargin12,
            _buildDatePicker(),
            const SizedBox(height: 16),
            if (widget.hasTimeSlots) ...[
              Text("Select Time", style: context.labelLarge),
              verticalMargin16,
              Expanded(child: _buildTimeGrid()),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule_outlined, size: 48, color: Colors.grey),
                      verticalMargin16,
                      Text(
                        'No Time Slots Available',
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      verticalMargin8,
                      Text(
                        'This service does not have time slots.\nSelect a date and continue.',
                        textAlign: TextAlign.center,
                        style: context.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavNextBackBtns(
        onPressedOne: () {
          if (widget.hasTimeSlots && selectedTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a time slot")),
            );
            return;
          }
          context.pushNamed(
            AppRouterNames.customerBookingAddPersonalInformation,
            pathParameters: {
              "listingId": widget.listingId,
              "locationId": widget.locationId,
              "staffId": widget.staffId,
            },
            queryParameters: {
              "date": DateFormat('yyyy-MM-dd').format(selectedDate),
              "time": selectedTime ?? '',
            },
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // MONTH HEADER
  // -------------------------------------------------------------
  Widget _buildMonthHeader() {
    return Row(
      children: [
        Text(
          DateFormat("MMMM yyyy").format(selectedDate),
          style: context.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        const Icon(Icons.keyboard_arrow_down),
      ],
    );
  }

  // -------------------------------------------------------------
  // DATE PICKER ROW
  // -------------------------------------------------------------
  Widget _buildDatePicker() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: widget.daysToShow,
        itemBuilder: (context, index) {
          DateTime date = widget.startDate.add(Duration(days: index));
          bool isSelected = date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              margin: rightPadding4,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat("EEE").format(date),
                    style: context.labelSmall.copyWith(
                      fontWeight: FontWeight.w400,
                      color: lightGreyTextColor,
                    ),
                  ),
                  verticalMargin8,
                  Container(
                    width: 35,
                    padding: verticalPadding4 + verticalPadding4 / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: isSelected ? _selectedTileGradient : null,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: context.labelLarge.copyWith(
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // TIME GRID
  // -------------------------------------------------------------
  Widget _buildTimeGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemCount: widget.availableSlots.length,
      itemBuilder: (context, index) {
        String time = widget.availableSlots[index];
        bool isSelected = selectedTime == time;
        final isBooked = widget.bookedSlots.contains(time);
        final selectedColor = isSelected ? Colors.white : null;

        return GestureDetector(
          onTap: !isBooked ? () => setState(() => selectedTime = time) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isBooked && !isSelected ? greyButttonColor : null,
              gradient: isSelected && !isBooked ? _selectedTileGradient : null,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.access_time, size: 15, color: selectedColor),
                horizontalMargin4,
                horizontalMargin2,
                Text(
                  time,
                  style: context.labelMedium.copyWith(color: selectedColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
