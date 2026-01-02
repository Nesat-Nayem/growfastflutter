import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/features/widgets/bottom_navigation_bar.dart';

class BottomNavigationBarWrapper extends StatelessWidget {
  const BottomNavigationBarWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        index: 0,
      ),
    );
  }
}
