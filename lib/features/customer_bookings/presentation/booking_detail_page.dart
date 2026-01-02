import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/reschedule_pop_up.dart';
import 'package:grow_first/features/widgets/gradient_button.dart';
import 'package:grow_first/features/widgets/status_button.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "Recent Booking",
          style: context.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Padding(
        padding: horizontalPadding16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              verticalMargin16,
              Text(
                "Booking ID: $bookingId",
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin4,
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12),
                  horizontalMargin8,
                  Text(
                    "2 Sep 2025 10:23 AM",
                    style: context.labelMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightGreyTextColor,
                    ),
                  ),
                ],
              ),
              verticalMargin24,
              Container(
                padding: allPadding16,
                decoration: BoxDecoration(
                  color: greyButttonColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Booked Slot",
                      style: context.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    verticalMargin8,
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12),
                        horizontalMargin8,
                        Text(
                          "2 Sep 2025 10:23 AM",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: lightGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin8,
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12),
                        horizontalMargin8,
                        Text(
                          "2 Sep 2025 10:23 AM",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: lightGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin16,
                    Text(
                      "Service Provider",
                      style: context.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    verticalMargin8,
                    Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 24,
                          backgroundImage: CachedNetworkImageProvider(
                            "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ),
                        ),
                        horizontalMargin8,
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Hp Engineering",
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: lightGreyTextColor,
                                  ),
                                ),
                                horizontalMargin12,
                                Text(
                                  "+91 8898987678",
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: lightGreyTextColor,
                                  ),
                                ),
                              ],
                            ),
                            verticalMargin8,
                            Row(
                              children: [
                                Text(
                                  "info@hp.com",
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: lightGreyTextColor,
                                  ),
                                ),
                                horizontalMargin12,
                                Text(
                                  "Pune",
                                  style: context.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: lightGreyTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalMargin16,
                    Row(
                      children: [
                        StatusButton(
                          title: "Completed",
                          backgroundColor: aquaGreenColor.withValues(
                            alpha: 0.15,
                          ),
                          titleColor: aquaGreenColor,
                        ),
                        horizontalMargin12,
                        StatusButton(
                          title: "Pending",
                          backgroundColor: lavaRedColor.withValues(alpha: 0.15),
                          titleColor: lavaRedColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalMargin24,
              verticalMargin4,
              Text(
                "Service Location & Contact Details",
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin8,
              _ServiceDetails(
                title: "Address",
                detail: "kothrud, Pune, India, 41111",
                icon: Icons.location_on_outlined,
              ),
              _ServiceDetails(
                title: "Email",
                detail: "suraj@gmail.com",
                icon: Icons.email_outlined,
              ),
              _ServiceDetails(
                title: "Phone",
                detail: "+91 8878765678",
                icon: Icons.local_phone_outlined,
              ),
              verticalMargin16,
              _PaymentInfo(),
              verticalMargin32,
              Text(
                "Order Summary",
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin16,
              Row(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                    height: 37,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                  ),
                  horizontalMargin12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .start,
                      children: [
                        Text(
                          "AC Services",
                          style: context.labelLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Pune",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: lightGreyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₹ 2500.00",
                    style: context.bodySmall.copyWith(letterSpacing: 1.2),
                  ),
                ],
              ),
              verticalMargin16,
              _OrderAmountBreakUp(),
              verticalMargin16,
              Divider(),
              verticalMargin16,
              Text(
                "Booking History",
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              verticalMargin24,
              Column(
                children: [
                  DynamicTimeline(
                    items: [
                      TimelineData(title: "Booking", date: "September 2, 2025"),
                      TimelineData(
                        title: "Provider Accept",
                        date: "September 5, 2025",
                      ),
                      TimelineData(
                        title: "Completed on",
                        date: "September 5, 2025",
                      ),
                    ],
                  ),
                ],
              ),
              verticalMargin24,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Reviews",
                      style: context.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  GradientButton(
                    text: "Add Review",
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Dismiss",
                        barrierColor: Colors.black54,
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (context, animation1, animation2) {
                          return ReschedulePopUp();
                        },
                      );
                    },
                    padding: verticalPadding8 + horizontalPadding24,
                    textStyle: context.labelMedium.copyWith(
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                    borderRadius: 5,
                  ),
                ],
              ),
              verticalMargin48,
              verticalMargin48,
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentInfo extends StatelessWidget {
  const _PaymentInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Payment",
          style: context.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        horizontalMargin24,
        Text(
          "Visa **** **** **** **56",
          style: context.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: lightGreyTextColor,
          ),
        ),
        horizontalMargin8,
        Container(
          padding: allPadding8,
          decoration: BoxDecoration(
            color: Color(0XFFF7F7FF),
            borderRadius: BorderRadius.circular(3),
          ),
          child: SvgPicture.asset(AppAssets.iconVisaSvg, height: 8),
        ),
      ],
    );
  }
}

class _ServiceDetails extends StatelessWidget {
  const _ServiceDetails({
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: verticalPadding4,
      child: Row(
        children: [
          IconButton.filled(
            onPressed: () {},
            icon: Icon(icon),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(greyButttonColor),
            ),
          ),
          horizontalMargin8,
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: context.labelMedium.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                style: context.labelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: lightGreyTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderAmountBreakUp extends StatelessWidget {
  const _OrderAmountBreakUp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Sub Total",
                style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "₹ 2500.00",
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        verticalMargin12,
        Row(
          children: [
            Expanded(
              child: Text(
                "Discount",
                style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "-₹ 100.00",
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        verticalMargin12,
        Row(
          children: [
            Expanded(
              child: Text(
                "Tax @ 12.5%",
                style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "₹ 5.36",
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        verticalMargin12,
        Row(
          children: [
            Expanded(
              child: Text(
                "Total",
                style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "₹ 2405.36",
              style: context.labelLarge.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }
}

class TimelineData {
  final String title;
  final String date;

  TimelineData({required this.title, required this.date});
}

class DynamicTimeline extends StatelessWidget {
  final List<TimelineData> items;

  const DynamicTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final bool isLast = index == items.length - 1;

        return Stack(
          children: [
            if (!isLast)
              Positioned(
                left: 10,
                top: 20,
                bottom: 0,
                child: Container(width: 2, color: greyButttonColor),
              ),
            Row(
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: verticalPadding4 / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: eucalyptusGreenColor,
                  ),
                ),
                horizontalMargin16,
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      item.title,
                      style: context.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    verticalMargin8,
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14),
                        horizontalMargin4,
                        Text(
                          "September 2, 2025",
                          style: context.labelMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    verticalMargin16,
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class RescheduleAppointmentPopup extends StatelessWidget {
  final VoidCallback onSave;

  const RescheduleAppointmentPopup({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reschedule Appointment',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 20,
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Appointment Date input
              Text(
                'Appointment Date',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'DD/MM/YYYY',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),

              // Appointment Time input
              Text(
                'Appointment Time',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '00:00:00',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 24),

              // Save button with gradient
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSave();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 14),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith((
                      states,
                    ) {
                      return null; // use gradient below with Ink widget
                    }),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
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
