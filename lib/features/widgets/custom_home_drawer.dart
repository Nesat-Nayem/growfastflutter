// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:grow_first/app/router/app_router_name.dart';
// import 'package:grow_first/core/utils/sizing.dart';
// import 'package:grow_first/features/customer_bookings/presentation/widgets/reschedule_pop_up.dart';

// class ModernCustomerDrawer extends StatelessWidget {
//   const ModernCustomerDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: SizedBox(
//           width: 300,
//           child: Column(
//             children: [
//               verticalMargin48,
//               const Text("Hello There!"),
//               verticalMargin48,
//               InkWell(
//                 onTap: () {
//                   context.pushNamed(AppRouterNames.customerHome);
//                 },
//                 child: Text("Customer Home"),
//               ),
//               InkWell(
//                 onTap: () {
//                   context.pushNamed(AppRouterNames.customerBookings);
//                 },
//                 child: Text("Booking List"),
//               ),
//               InkWell(
//                 onTap: () {
//                   context.pushNamed(
//                     AppRouterNames.customerBookingDetail,
//                     pathParameters: {"bookingId": "22222"},
//                   );
//                 },
//                 child: Text("Recent Booking"),
//               ),
//               InkWell(
//                 onTap: () {
//                   showGeneralDialog(
//                     context: context,
//                     barrierDismissible: true,
//                     barrierLabel: "Dismiss",
//                     barrierColor: Colors.black54,
//                     transitionDuration: Duration(milliseconds: 300),
//                     pageBuilder: (context, animation1, animation2) {
//                       return ReschedulePopUp();
//                     },
//                   );
//                 },
//                 child: Text("Reschedule Appointment"),
//               ),
//               InkWell(
//                 onTap: () {
//                   context.pushNamed(AppRouterNames.customerWallet);
//                 },
//                 child: Text("Wallet"),
//               ),
//               InkWell(
//                 onTap: () {
//                   context.pushNamed(AppRouterNames.myReview);
//                 },
//                 child: Text("Reviews"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/features/customer_bookings/presentation/widgets/reschedule_pop_up.dart';
import 'package:grow_first/app/bloc/app_bloc/app_bloc.dart';
import 'package:grow_first/core/app_store/app_store.dart';
import 'package:grow_first/app/di/app_injections.dart';

class ModernCustomerDrawer extends StatelessWidget {
  const ModernCustomerDrawer({
    super.key,
    this.name,
    this.email,
    this.profileImage,
  });

  final String? name;
  final String? email;
  final String? profileImage;

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteAccount(context);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dio = sl<Dio>();
      final response = await dio.delete('/customer/delete-account');

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
      }

      if (response.data['status'] == 'success') {
        // Clear local data
        await sl<AppStore>().clear();
        sl<AppBloc>().add(AppLoggedOut());

        if (context.mounted) {
          Navigator.of(context).pop(); // Close drawer
          context.goNamed(AppRouterNames.home);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data['message'] ?? 'Failed to delete account'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete account. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentGeometry.topRight,
                child: IconButton.filled(
                  onPressed: () {
                    context.goNamed(AppRouterNames.home);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  icon: Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 20),

              InkWell(
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: CachedNetworkImageProvider(
                    //     "https://plus.unsplash.com/premium_photo-1664536392896-cd1743f9c02c?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW4lMjBiZWluZ3N8ZW58MHx8MHx8fDA%3D",
                    //     cacheManager:
                    //         CachedNetworkImageProvider.defaultCacheManager,
                    //   ),
                    // ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AppBloc, AppState>(
                            builder: (context, appState) {
                              final appStore = sl<AppStore>();
                              final user = appStore.user;
                              final userName = user?.name ?? 'Guest';
                              final userContact =
                                  user?.phone ?? user?.email ?? '';
                              final userImage = user?.image;
                              print("User Image is :$userImage");

                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        (userImage == null || userImage.isEmpty)
                                        ? AssetImage("assets/images/g_logo.png")
                                        : CachedNetworkImageProvider(
                                            "https://growfirst.org/$userImage",
                                          ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: "Hey, ",
                                          style: context.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                          ),
                                          children: [
                                            TextSpan(
                                              text: userName,
                                              style: context.bodyLarge.copyWith(
                                                letterSpacing: 1.2,
                                                color: aquaBlueColor,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (userContact.isNotEmpty)
                                        Text(
                                          userContact,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => context.goNamed(AppRouterNames.accountSettings),
              ),

              const SizedBox(height: 40),

              // ──────────────────────────── MENU ITEM GROUP
              DrawerMenuItem(
                icon: Icons.dashboard,
                label: "Dashboard",
                onTap: () => context.pushNamed(AppRouterNames.customerHome),
                color: aquaBlueColor,
              ),
              DrawerMenuItem(
                icon: Icons.event_note_rounded,
                label: "Bookings",

                onTap: () => context.pushNamed(AppRouterNames.customerBookings),
                color: Color(0XFF245F9E),
              ),
              // DrawerMenuItem(
              //   icon: Icons.settings,
              //   label: "Recent Boookings",
              //   onTap: () {
              //     context.pushNamed(
              //       AppRouterNames.customerBookingDetail,
              //       pathParameters: {"bookingId": "22222"},
              //     );
              //   },
              //   color: Color(0XFF5ECFE0),
              // ),
              // DrawerMenuItem(
              //   icon: Icons.settings,
              //   label: "Reschedule Appointment [Pop Up Demo]",
              //   onTap: () {
              //     showGeneralDialog(
              //       context: context,
              //       barrierDismissible: true,
              //       barrierLabel: "Dismiss",
              //       barrierColor: Colors.black54,
              //       transitionDuration: Duration(milliseconds: 300),
              //       pageBuilder: (context, animation1, animation2) {
              //         return ReschedulePopUp();
              //       },
              //     );
              //   },
              //   color: Color(0XFF78A5E1),
              // ),
              // DrawerMenuItem(
              //   icon: Icons.account_balance_wallet_rounded,
              //   label: "Wallet",
              //   onTap: () => context.pushNamed(AppRouterNames.customerWallet),
              //   color: Color(0XFF25AE7A),
              // ),
              DrawerMenuItem(
                icon: Icons.reviews_rounded,
                label: "Reviews",
                onTap: () => context.pushNamed(AppRouterNames.myReview),
                color: Color(0XFF009EF7),
              ),
              DrawerMenuItem(
                icon: Icons.settings,
                label: "Settings",
                onTap: () => context.pushNamed(AppRouterNames.accountSettings),
                color: Color(0XFF5ECFE0),
              ),
              DrawerMenuItem(
                icon: Icons.business,
                label: "Become a vendor",
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer first
                  context.pushNamed(
                    AppRouterNames.vendorWebView,
                    queryParameters: {
                      'url': 'https://growfirst.org/become-vendor',
                      'title': 'Become a Vendor',
                    },
                  );
                },
                color: Color(0XFF5ECFE0),
              ),
              DrawerMenuItem(
                icon: Icons.logout,
                label: "Logout",
                onTap: () async {
                  // Clear auth data
                  await sl<AppStore>().clear();
                  // Trigger app logout
                  sl<AppBloc>().add(AppLoggedOut());
                  // Close drawer and navigate to home
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    context.goNamed(AppRouterNames.home);
                  }
                },
                color: Color(0XFF78A5E1),
              ),
              DrawerMenuItem(
                icon: Icons.delete_forever,
                label: "Delete Account",
                onTap: () => _showDeleteAccountDialog(context),
                color: Colors.red,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Drawer Menu Tile Widget (Matches Your UI)
class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
