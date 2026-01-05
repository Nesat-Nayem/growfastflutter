import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
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
  final String? cartId;
  
  const PaymentModePage({super.key, this.cartId});

  @override
  _PaymentModePageState createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage> {
  bool selectedRazorpay = true;
  late Razorpay _razorpay;
  Map<String, dynamic>? cartData;
  bool isLoading = true;
  String? errorMessage;
  String? razorpayOrderId;
  String? razorpayKey;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    if (widget.cartId == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'No cart ID provided';
      });
      return;
    }

    try {
      final dio = sl<Dio>();
      final getToken = await sl<ISecureStore>().read("token");
      
      // Fetch cart checkout data
      final response = await dio.get(
        'customer/cart-checkout/${widget.cartId}',
        options: Options(headers: {'Authorization': 'Bearer $getToken'}),
      );

      if (response.data['success'] == true) {
        setState(() {
          cartData = response.data;
        });
        
        // Create Razorpay order
        await _createRazorpayOrder();
      } else {
        setState(() {
          isLoading = false;
          errorMessage = response.data['message'] ?? 'Failed to load cart';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _createRazorpayOrder() async {
    try {
      final dio = sl<Dio>();
      final getToken = await sl<ISecureStore>().read("token");
      
      final response = await dio.get(
        'customer/cart_payment',
        queryParameters: {
          'gateway': 'razorpay',
          'cart_id': widget.cartId,
        },
        options: Options(headers: {'Authorization': 'Bearer $getToken'}),
      );

      if (response.data['status'] == 'success') {
        setState(() {
          razorpayOrderId = response.data['order_id'];
          razorpayKey = response.data['key'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = response.data['message'] ?? 'Failed to create payment order';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create payment order: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final dio = sl<Dio>();
      final getToken = await sl<ISecureStore>().read("token");
      
      // Verify payment with backend
      final verifyResponse = await dio.post(
        'razorpay/verify',
        data: {
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
          'razorpay_signature': response.signature,
        },
        options: Options(headers: {'Authorization': 'Bearer $getToken'}),
      );

      if (verifyResponse.data['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful! Booking confirmed.')),
          );
          context.pushNamed(AppRouterNames.customerBookingConfirmed);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(verifyResponse.data['message'] ?? 'Payment verification failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment verification failed: ${e.toString()}')),
        );
      }
    }
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
    if (razorpayKey == null || razorpayOrderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment setup failed. Please try again.')),
      );
      return;
    }

    final cart = cartData!['carts'];
    final service = cartData!['service'];
    
    var options = {
      'key': razorpayKey,
      'amount': (totalAmount * 100).toInt(),
      'order_id': razorpayOrderId,
      'name': 'Grow First',
      'description': service['title'] ?? 'Service Booking',
      'prefill': {
        'contact': cart['cart_adresses']?[0]?['phone'] ?? '',
        'email': cart['cart_adresses']?[0]?['email'] ?? ''
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Payment"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || cartData == null) {
      return Scaffold(
        appBar: CustomerHomeAppBar(singleTitle: "Payment"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              verticalMargin16,
              Text(
                'Failed to load payment details',
                style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              verticalMargin8,
              Text(
                errorMessage ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: context.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    final cartSum = double.tryParse(cartData!['cart_sum']?.toString() ?? '0') ?? 0.0;
    final tax = cartData!['tax'];
    final taxAmount = tax != null ? (cartSum * double.parse(tax['tax_percentage']?.toString() ?? '0') / 100) : 0.0;
    final totalAmount = cartSum + taxAmount;
    
    final service = cartData!['service'];
    final cart = cartData!['carts'];
    final cartItems = cart['cart_items'] ?? [];

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
                        _buildItemRow(service['title'] ?? "Service",
                            "₹${cart['service_price']?.toString() ?? '0'}", ""),
                        ...cartItems.map<Widget>((item) => _buildItemRow(
                            item['additional_services']?['name'] ?? 'Additional Service',
                            "₹${item['price']?.toString() ?? '0'}", "")),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                            "Sub Total", "₹${cartSum.toStringAsFixed(2)}"),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                            "Tax (GST ${tax != null ? tax['tax_percentage'] : '0'}%)", "₹${taxAmount.toStringAsFixed(2)}"),
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
