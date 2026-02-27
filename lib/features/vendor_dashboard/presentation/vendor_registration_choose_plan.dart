import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/payment_order_dto.dart';
import 'package:grow_first/features/vendor_dashboard/data/models/plan_dto.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_event.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_state.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:grow_first/core/analytics/meta_analytics_service.dart';

class VendorRegistrationChoosePlan extends StatefulWidget {
  const VendorRegistrationChoosePlan({super.key});

  @override
  State<VendorRegistrationChoosePlan> createState() => _VendorRegistrationChoosePlanState();
}

class _VendorRegistrationChoosePlanState extends State<VendorRegistrationChoosePlan> {
  late Razorpay _razorpay;
  int? selectedPlanId;
  bool isProcessingPayment = false;
  bool _hasLoadedPlans = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    // Only load plans if not already loaded
    final vendorBloc = sl<VendorBloc>();
    if (vendorBloc.state.plans.isEmpty && !_hasLoadedPlans) {
      _hasLoadedPlans = true;
      vendorBloc.add(const LoadPlans());
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() => isProcessingPayment = false);
    
    // Store payment - vendorId will be added by the bloc
    final vendorId = sl<VendorBloc>().state.vendorId;
    if (vendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please restart registration.'), backgroundColor: Colors.red),
      );
      return;
    }

    // Log Meta Subscribe event for the selected paid plan
    final selectedPlan = sl<VendorBloc>().state.plans.firstWhere(
      (p) => p.id == selectedPlanId,
      orElse: () => sl<VendorBloc>().state.plans.first,
    );
    MetaAnalyticsService.instance.logVendorSubscribe(
      amount: selectedPlan.amount,
      currency: 'INR',
      planName: selectedPlan.name,
      isFree: selectedPlan.isFree,
    );
    
    sl<VendorBloc>().add(StorePayment(StorePaymentRequest(
      planId: selectedPlanId!,
      transactionId: response.paymentId!,
      vendorId: vendorId,
    )));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}'), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet: ${response.walletName}')),
    );
  }

  void _openRazorpayCheckout(VendorState state) {
    if (state.paymentOrder == null) return;

    final order = state.paymentOrder!;
    final vendorData = state.vendorData;

    var options = {
      'key': order.key,
      'amount': order.amount,
      'order_id': order.orderId,
      'name': 'Grow First',
      'description': 'Vendor Subscription',
      'prefill': {
        'contact': vendorData?.phone ?? '',
        'email': vendorData?.email ?? '',
      },
      'theme': {'color': '#10326B'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _selectAndPay(PlanDto plan) {
    final vendorId = sl<VendorBloc>().state.vendorId;
    if (vendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please restart registration.'), backgroundColor: Colors.red),
      );
      return;
    }
    
    setState(() {
      selectedPlanId = plan.id;
      isProcessingPayment = true;
    });

    if (plan.isFree) {
      // Log Meta Subscribe event for the free plan
      MetaAnalyticsService.instance.logVendorSubscribe(
        amount: 0,
        currency: 'INR',
        planName: plan.name,
        isFree: true,
      );
      // For free plan, directly store payment with empty transaction
      sl<VendorBloc>().add(StorePayment(StorePaymentRequest(
        planId: plan.id,
        transactionId: 'FREE_${DateTime.now().millisecondsSinceEpoch}',
        vendorId: vendorId,
      )));
    } else {
      // Create payment order for paid plans
      sl<VendorBloc>().add(CreatePaymentOrder(planId: plan.id, gateway: 'razorpay'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      body: BlocConsumer<VendorBloc, VendorState>(
        bloc: sl<VendorBloc>(),
        listenWhen: (previous, current) {
          // Only listen when relevant states change
          return previous.paymentOrder != current.paymentOrder ||
                 previous.paymentSuccess != current.paymentSuccess ||
                 previous.paymentError != current.paymentError;
        },
        listener: (context, state) {
          // When payment order is created, open Razorpay
          if (state.paymentOrder != null && isProcessingPayment) {
            _openRazorpayCheckout(state);
          }
          
          // When payment is stored successfully, navigate to Confirmation
          if (state.paymentSuccess) {
            // Clear the success state to prevent infinite loop when navigating back
            sl<VendorBloc>().add(ClearPaymentSuccess());
            context.pushNamed(AppRouterNames.vendorConfirmRegistration);
          }
          
          // Show errors
          if (state.paymentError != null) {
            setState(() => isProcessingPayment = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.paymentError!), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StepProgressHeader(
                  currentStep: 2,
                  steps: const [
                    StepItem(label: "Basic Info", icon: Icons.info_outline),
                    StepItem(label: "KYC Details", icon: Icons.description_outlined),
                    StepItem(label: "Choose\nPlan", icon: Icons.cast_outlined),
                    StepItem(label: "Confirm\non", icon: Icons.check),
                  ],
                ),
                Expanded(
                  child: state.isLoadingPlans
                      ? const Center(child: CircularProgressIndicator())
                      : state.plansError != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Error: ${state.plansError}', style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => sl<VendorBloc>().add(const LoadPlans()),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: PricingContent(
                                plans: state.plans,
                                selectedPlanId: selectedPlanId,
                                isProcessing: isProcessingPayment || state.isCreatingOrder || state.isStoringPayment,
                                onSelectPlan: _selectAndPay,
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PricingContent extends StatelessWidget {
  final List<PlanDto> plans;
  final int? selectedPlanId;
  final bool isProcessing;
  final Function(PlanDto) onSelectPlan;

  const PricingContent({
    super.key,
    required this.plans,
    this.selectedPlanId,
    required this.isProcessing,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Pricing Plan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            "Affordable plans designed to match your\nneeds and budget.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textLightColor),
          ),
          const SizedBox(height: 30),
          
          if (plans.isEmpty)
            const Center(child: Text("No plans available"))
          else
            ...plans.map((plan) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PlanCard(
                plan: plan,
                isSelected: selectedPlanId == plan.id,
                isProcessing: isProcessing && selectedPlanId == plan.id,
                onSelect: () => onSelectPlan(plan),
              ),
            )),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final PlanDto plan;
  final bool isSelected;
  final bool isProcessing;
  final VoidCallback onSelect;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.isProcessing,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        gradient: plan.isPremium
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5FA8C8), Color(0xFF9ED2E0)],
              )
            : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, 10)),
        ],
        border: plan.isPremium ? Border.all(color: const Color(0xFF30D3D9), width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)]),
            ),
            child: Icon(plan.isPremium ? Icons.diamond_outlined : Icons.star_outline, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(plan.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: plan.isPremium ? const Color(0xFF10326B) : Colors.green,
                ),
                child: Text(
                  plan.isPremium ? "Premium" : "Basic",
                  style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: plan.isFree ? "Free" : "₹${plan.amount.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                if (!plan.isFree)
                  TextSpan(
                    text: "  / ${plan.duration} months",
                    style: TextStyle(color: plan.isPremium ? Colors.black : Colors.grey, fontSize: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          ...plan.features.map((feature) => _featureItem(feature)),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: isProcessing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.isPremium ? Colors.white : const Color(0xFF10326B),
                      foregroundColor: plan.isPremium ? const Color(0xFF10326B) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(plan.isFree ? "Start Free" : "Choose Plan", style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
