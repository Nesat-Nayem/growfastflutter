import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/status_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CustomerBookingCard extends StatefulWidget {
  const CustomerBookingCard({super.key, this.booking, this.onRefresh});

  final Map<String, dynamic>? booking;
  final VoidCallback? onRefresh;

  @override
  State<CustomerBookingCard> createState() => _CustomerBookingCardState();
}

class _CustomerBookingCardState extends State<CustomerBookingCard> {
  bool _isMarkingDone = false;
  bool _isPayingNow = false;
  late Razorpay _razorpay;

  Map<String, dynamic>? get booking => widget.booking;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;
    setState(() => _isPayingNow = true);
    try {
      final dio = sl<Dio>();
      final token = await sl<ISecureStore>().read('token');
      final verifyResponse = await dio.post(
        'booking/pay-now/verify',
        data: {
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
          'razorpay_signature': response.signature,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      final data = verifyResponse.data;
      final isSuccess = data['status'] == 'success' || data['success'] == true;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful! Booking confirmed.')),
        );
        widget.onRefresh?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ?? 'Payment verification failed.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPayingNow = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() => _isPayingNow = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message ?? 'Unknown error'}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    setState(() => _isPayingNow = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  String _getServiceImage() {
    final config = sl<AppConfig>();
    final baseUrl = config.imageBaseUrl;

    // Try to get the first gallery image from service
    final service = booking?['service'];
    if (service != null) {
      // Check if gallery exists and has images
      final gallery = service['gallery'];
      if (gallery != null && gallery is List && gallery.isNotEmpty) {
        final firstImage = gallery[0];
        if (firstImage != null) {
          String? imagePath;
          // Handle both 'img' and 'image' keys
          if (firstImage is Map) {
            imagePath = (firstImage['img'] ?? firstImage['image'])?.toString();
          } else if (firstImage is String) {
            imagePath = firstImage;
          }

          if (imagePath != null && imagePath.isNotEmpty) {
            if (imagePath.startsWith('http')) {
              return imagePath;
            }
            return '$baseUrl/storage/$imagePath';
          }
        }
      }

      // Fallback to service image if available
      if (service['image'] != null && service['image'].toString().isNotEmpty) {
        final imagePath = service['image'].toString();
        if (imagePath.startsWith('http')) {
          return imagePath;
        }
        return '$baseUrl/storage/$imagePath';
      }

      // Try service banner image
      if (service['banner'] != null && service['banner'].toString().isNotEmpty) {
        final imagePath = service['banner'].toString();
        if (imagePath.startsWith('http')) {
          return imagePath;
        }
        return '$baseUrl/storage/$imagePath';
      }
    }

    // Default placeholder image
    return '';
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return lavaRedColor;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _markAsDone(BuildContext context) async {
    final bookingId = booking?['id']?.toString();
    if (bookingId == null) return;

    setState(() => _isMarkingDone = true);
    try {
      final dio = sl<Dio>();
      final token = await sl<ISecureStore>().read('token');
      final response = await dio.get(
        'customer/booking/is-work-done/$bookingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      final data = response.data;
      final isSuccess =
          data['status'] == 'success' || data['success'] == true;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work marked as done!')),
        );
        widget.onRefresh?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ?? 'Failed to mark as done',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isMarkingDone = false);
    }
  }

  Future<void> _payNow(BuildContext context) async {
    final bookingId = booking?['id']?.toString();
    if (bookingId == null) return;

    setState(() => _isPayingNow = true);
    try {
      final dio = sl<Dio>();
      final token = await sl<ISecureStore>().read('token');

      // Step 1: Create Razorpay order from backend
      final response = await dio.get(
        'booking/pay-now/$bookingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      final data = response.data;
      if (data['status'] != 'success') {
        setState(() => _isPayingNow = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message']?.toString() ?? 'Failed to create payment order.',
            ),
          ),
        );
        return;
      }

      final orderId = data['order_id']?.toString();
      final razorpayKey = data['key']?.toString();
      final amount = data['amount'];

      if (orderId == null || razorpayKey == null) {
        setState(() => _isPayingNow = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment setup failed. Please try again.')),
        );
        return;
      }

      // Step 2: Open Razorpay checkout
      final options = {
        'key': razorpayKey,
        'amount': amount,
        'order_id': orderId,
        'name': 'Grow First',
        'description': booking?['service']?['title'] ?? 'Service Payment',
        'prefill': {
          'contact': '',
          'email': '',
        },
      };

      _razorpay.open(options);
      // _isPayingNow stays true until success/error callback
    } catch (e) {
      if (mounted) {
        setState(() => _isPayingNow = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: ${e.toString()}')),
        );
      }
    }
  }

  bool get _showMarkAsDone {
    final isWorkDone = booking?['is_work_done'];
    return isWorkDone == 0 || isWorkDone == '0' || isWorkDone == false;
  }

  bool get _showPayNow {
    final isWorkDone = booking?['is_work_done'];
    final gateway = booking?['payment_gateway']?.toString();
    final paymentStatus = booking?['payment_status']?.toString().toLowerCase();
    final workDone = isWorkDone == 1 || isWorkDone == '1' || isWorkDone == true;
    return workDone &&
        gateway == 'pay_after_work' &&
        paymentStatus == 'pending';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12 + horizontalPadding4,
      margin: verticalPadding8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _getServiceImage().isEmpty
                  ? Container(
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('No Image', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: _getServiceImage(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text('No Image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          verticalMargin24,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  booking?['service']?['title'] ?? "Service",
                  style: context.bodySmall.copyWith(letterSpacing: 1.1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              horizontalMargin12,
              StatusButton(
                title: booking?['status'] ?? "Pending",
                backgroundColor: _getStatusColor(
                  booking?['status'],
                ).withValues(alpha: 0.11),
                titleColor: _getStatusColor(booking?['status']),
                textStyle: context.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          verticalMargin16,
          _BookingDetails(booking: booking),
          if (_showMarkAsDone) ..._buildMarkAsDoneSection(context),
          if (_showPayNow) ..._buildPayNowSection(context),
        ],
      ),
    );
  }

  List<Widget> _buildMarkAsDoneSection(BuildContext context) {
    return [
      verticalMargin12,
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isMarkingDone ? null : () => _markAsDone(context),
          icon: _isMarkingDone
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline, size: 18),
          label: Text(_isMarkingDone ? 'Marking...' : 'Mark as Done'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPayNowSection(BuildContext context) {
    return [
      verticalMargin12,
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isPayingNow ? null : () => _payNow(context),
          icon: _isPayingNow
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.payment, size: 18),
          label: Text(
            _isPayingNow
                ? 'Processing...'
                : 'Pay Now  ₹${booking?['total_price'] ?? '0.00'}',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0XFFFE8C00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ];
  }
}

class _BookingDetails extends StatelessWidget {
  const _BookingDetails({this.booking});

  final Map<String, dynamic>? booking;

  String _formatBookingDateTime() {
    final date = booking?['booking_date'];
    final slots = booking?['booking_slots'];

    if (date == null) return 'N/A';

    // If slots is null or empty, just return the date
    if (slots == null ||
        slots.toString().isEmpty ||
        slots.toString() == 'null') {
      return date.toString();
    }

    // Return date with time slots
    return '$date, $slots';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (booking?['booking_date'] != null)
          _BookingRowTile(
            title: "Booking Date",
            value: _formatBookingDateTime(),
          ),
        verticalMargin8,
        _BookingRowTile(
          title: "Amount",
          value: "₹ ${booking?['total_price'] ?? '0.00'}",
          extraValueContent: StatusButton(
            title: booking?['payment_method'] ?? "Cash",
            backgroundColor: Color(0XFF245F9E).withValues(alpha: 0.16),
            titleColor: Color(0XFF245F9E),
          ),
        ),
        verticalMargin8,
        _BookingRowTile(
          title: "Status",
          value: booking?['payment_status'] ?? 'Pending',
        ),
        verticalMargin8,
        _BookingRowTile(
          title: "Provider",
          value: booking?['service']?['user']?['name'] ?? 'N/A',
          keepExtraContentFirst: true,
          extraValueContent: Image.asset(
            "assets/images/g_logo.png",
            height: 18,
          ),
        ),
        verticalMargin8,
        Row(
          children: [
            Icon(Icons.email_outlined, size: 17),
            horizontalMargin4,
            Text(
              booking?['service']?['user']?['email'] ?? 'N/A',
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: lightGreyTextColor,
              ),
            ),
          ],
        ),
        verticalMargin16,
        Row(
          children: [
            Icon(Icons.local_phone_outlined, size: 17),
            horizontalMargin4,
            Text(
              booking?['service']?['user']?['phone'] ?? 'N/A',
              style: context.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: lightGreyTextColor,
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     GradientButton(
        //       text: "Reschedule",
        //       onTap: () {},
        //       borderRadius: 5,
        //       padding: verticalPadding12 + horizontalPadding24,
        //       textStyle: context.labelMedium.copyWith(color: whiteColor),
        //     ),
        //     horizontalMargin8,
        //     GradientButton(
        //       text: "Cancel",
        //       onTap: () {},
        //       borderRadius: 5,
        //       hideGradient: true,
        //       backgroundColor: greyButttonColor,
        //       padding: verticalPadding12 + horizontalPadding24,
        //       textStyle: context.labelMedium.copyWith(
        //         color: textBlackColor,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class _BookingRowTile extends StatelessWidget {
  const _BookingRowTile({
    required this.title,
    this.extraValueContent,
    required this.value,
    this.keepExtraContentFirst = false,
  });

  final String title;
  final String value;
  final Widget? extraValueContent;
  final bool keepExtraContentFirst;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.labelLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(":"),
            ],
          ),
        ),
        horizontalMargin12,
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (keepExtraContentFirst) ...[
                if (extraValueContent != null) extraValueContent!,
                if (extraValueContent != null) horizontalMargin8,
                Expanded(
                  child: Text(
                    value,
                    style: context.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightGreyTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    value,
                    style: context.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: lightGreyTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (extraValueContent != null) ...[
                  horizontalMargin12,
                  extraValueContent!,
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
