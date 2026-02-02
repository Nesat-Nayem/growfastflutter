import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/home/di/injections.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_bloc.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/bloc/vendor_event.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

class VendorConfirmRegistration extends StatelessWidget {
  const VendorConfirmRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorData = sl<VendorBloc>().state.vendorData;
    
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Become a vendor"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StepProgressHeader(
              currentStep: 3,
              steps: const [
                StepItem(label: "Basic Info", icon: Icons.info_outline),
                StepItem(label: "KYC Details", icon: Icons.description_outlined),
                StepItem(label: "Choose\nPlan", icon: Icons.cast_outlined),
                StepItem(label: "Confirm\non", icon: Icons.check),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalMargin48,
                    verticalMargin48,
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 50),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Registration Successful',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your vendor registration has been submitted.\nYou will receive a verification email shortly.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // Login Credentials Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.key, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Your Login Credentials',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text('Email: ', style: TextStyle(fontSize: 13, color: Colors.black54)),
                              Expanded(
                                child: Text(
                                  vendorData?.email ?? 'N/A',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Password: ', style: TextStyle(fontSize: 13, color: Colors.black54)),
                              const Text(
                                '12345678',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(const ClipboardData(text: '12345678'));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password copied!'), duration: Duration(seconds: 1)),
                                  );
                                },
                                child: const Icon(Icons.copy, size: 16, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please change your password after first login.',
                            style: TextStyle(fontSize: 11, color: Colors.orange, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your account is pending admin approval. You will be notified once approved.',
                              style: TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        // Reset vendor registration state
                        sl<VendorBloc>().add(ResetVendorRegistration());
                        context.goNamed(AppRouterNames.home);
                      },
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
