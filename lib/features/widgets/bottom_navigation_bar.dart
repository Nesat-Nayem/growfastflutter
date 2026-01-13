import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/account/presentation/customer_account_settings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int index;
  const CustomBottomNavBar({super.key, required this.index});

  void _go(BuildContext context, String route) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 75,
        padding: horizontalPadding16 + horizontalPadding4 + verticalPadding4,
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              context,
              icon: Icons.dashboard,
              active: index == 0,
              onTap: () => context.goNamed(AppRouterNames.exploreCategories),
            ),

            /// CENTER BIG GRADIENT BUTTON
            GestureDetector(
              onTap: () => context.goNamed(AppRouterNames.home),
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF004C97), Color(0xFF00E1D6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.home, color: Colors.white, size: 32),
                ),
              ),
            ),

            GestureDetector(
              onTap: () => context.goNamed(AppRouterNames.ModernCustomerDrawer),

              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 39, 139, 222),
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 28,
        color: active ? Color.fromARGB(255, 39, 139, 222) : Colors.grey,
      ),
    );
  }
}
