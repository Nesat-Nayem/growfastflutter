import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/app/router/app_router_paths.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/vendor_dashboard/presentation/vender_dashboard_page.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';

class VendorConfirmRegistration extends StatelessWidget {
  const VendorConfirmRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationSuccessScreen();
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                StepItem(label: "Choose Plan", icon: Icons.cast_outlined),
                StepItem(
                  label: "KYC Details",
                  icon: Icons.description_outlined,
                ),
                StepItem(label: "Confirmation", icon: Icons.check),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    verticalMargin48,
                    verticalMargin48,
                    verticalMargin48,
                    // Green circle with check icon
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Registration Successful',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'You will get a verification link via email for\nVerifying the Account',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Go to Home
                    TextButton(
                      onPressed: () {
                        context.goNamed(AppRouterNames.home);
                      },
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
