import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/config/app_config.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/categories/presentation/bloc/category_bloc.dart';
import 'package:grow_first/features/categories/presentation/widgets/category_tile.dart';
import 'package:grow_first/features/categories/presentation/widgets/sub_categories_pop_up.dart';
import 'package:grow_first/features/home/presentation/bloc/home_page_bloc.dart';
import 'package:grow_first/features/home/presentation/widgets/home_page_banners.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';
import 'package:grow_first/features/widgets/shimmer.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "How it Works",
          style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        verticalMargin8,
        Text(
          "Follow a few simple steps to book your service with ease.",
          style: context.bodySmall.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        verticalMargin24,

        SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepItem(icon: Icons.star_rounded, label: "Select Service"),
              _Arrow(),
              _StepItem(icon: Icons.settings, label: "Book & Customiz"),
              _Arrow(),
              _StepItem(
                icon: Icons.account_balance_wallet,
                label: "Pay Securely",
              ),
              _Arrow(),
              _StepItem(icon: Icons.emoji_emotions, label: "Get Service"),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StepItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 64,
            width: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF2EC4E6), Color(0xFF1F7BB6)],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          verticalMargin12,
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: context.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)],
    );
  }
}
