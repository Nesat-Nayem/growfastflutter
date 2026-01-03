import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/customer_bookings/presentation/bloc/bookings_bloc.dart';
import 'package:grow_first/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:grow_first/features/widgets/custom_bottom_nav_next_back_btns.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentModePage extends StatefulWidget {
  const PaymentModePage({super.key});

  @override
  _PaymentModePageState createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage> {
  bool selectedRazorpay = true;
  late Razorpay _razorpay;

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final state = sl<BookingsBloc>().state;
    context.read<BookingsBloc>().add(ConfirmBooking(
          cartId: state.cartId ?? 0,
          paymentMethod: 'razorpay',
          paymentGateway: 'razorpay',
          response: {
            'payment_id': response.paymentId,
            'order_id': response.orderId,
            'signature': response.signature,
          },
        ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _startPayment(double totalAmount) {
    var options = {
      'key': 'rzp_test_your_key', 
      'amount': (totalAmount * 100).toInt(),
      'name': 'Grow First',
      'description': 'Service Booking',
      'prefill': {'contact': '8888888888', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingsBloc, BookingsState>(
      bloc: sl<BookingsBloc>(),
      listener: (context, state) {
        if (state.isBookingConfirmed) {
          context.pushNamed(AppRouterNames.customerBookingConfirmed);
        }
        if (state.errorConfirmingBooking != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorConfirmingBooking!)),
          );
        }
      },
      child: BlocBuilder<BookingsBloc, BookingsState>(
        bloc: sl<BookingsBloc>(),
        builder: (context, state) {
          final listing = sl<ListingBloc>().state.selectedListing;
          final additionalServices = state.selectedAdditionalServices;
          
          double basePrice = double.tryParse(listing?.price ?? '0') ?? 0;
          double additionalTotal = additionalServices.fold(0, (sum, item) => sum + item.price);
          double subTotal = basePrice + additionalTotal;
          double tax = subTotal * 0.05; // 5% GST
          double totalAmount = subTotal + tax;

          return Scaffold(
            appBar: CustomerHomeAppBar(singleTitle: "Payment"),
            body: Padding(
              padding: verticalPadding12 + horizontalPadding16,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Types", style: context.labelLarge),
                    verticalMargin16,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedRazorpay
                              ? Color(0XFFFE8C00)
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: verticalPadding12 + horizontalPadding12,
                      child: Row(
                        children: [
                          Icon(Icons.payment, color: Colors.blue),
                          horizontalMargin16,
                          Expanded(
                              child: Text("Razorpay", style: context.labelLarge)),
                          Radio<bool>(
                            value: true,
                            groupValue: selectedRazorpay,
                            onChanged: (val) {
                              setState(() {
                                selectedRazorpay = val!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalMargin24,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildItemRow(listing?.title ?? "Service",
                            "₹${basePrice.toStringAsFixed(2)}", ""),
                        ...additionalServices.map((s) => _buildItemRow(
                            s.title, "₹${s.price.toStringAsFixed(2)}", "")),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                            "Sub Total", "₹${subTotal.toStringAsFixed(2)}"),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                            "Tax (GST 5%)", "₹${tax.toStringAsFixed(2)}"),
                        verticalMargin24,
                        _buildTotalRow(
                            "Total", "₹${totalAmount.toStringAsFixed(2)}"),
                        verticalMargin24,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: state.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : CustomBottomNavNextBackBtns(
                  title1: "Pay ₹${totalAmount.toStringAsFixed(2)}",
                  title2: "Back to Cart",
                  showIcon: false,
                  onPressedOne: () => _startPayment(totalAmount),
                ),
          );
        },
      ),
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
            if (time.isNotEmpty) ...[
              verticalMargin2,
              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
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
