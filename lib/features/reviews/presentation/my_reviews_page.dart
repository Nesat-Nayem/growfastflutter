import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_home_app_bar.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerHomeAppBar(singleTitle: "Reviews"),
      drawer: ModernCustomerDrawer(),
      body: ListView.builder(
        padding: horizontalPadding16,
        itemBuilder: (context, index) {
          return Container(
            padding: allPadding12,
            margin: verticalPadding8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://laravel.test/storage/services/XizJH1aguhYRN9BQovGI9AwBTUGkpenPQuo8vRoZ.jpg",
                        width: 60,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AC Services",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              verticalMargin4,
                              const Text(
                                "4.9 (255 reviews)",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: const [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Icon(Icons.delete_outline, size: 20),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                        "http://laravel.test/storage/blogs/XWWB6kBSSDqCLp3oC5LKSOvGR2P903976KfwIR0A.jpg",
                      ),
                    ),
                    horizontalMargin12,
                    Expanded(
                      child: Text(
                        "Suraj Jamdade",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Text(
                      "Oct 8, 2025 04:06 AM",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Review description
                const Text(
                  "The electricians were prompt, professional, and resolved our issues quickly. "
                  "Did a fantastic job upgrading our electrical panel. "
                  "Highly recommend them for any electrical work.",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          );
        },
        itemCount: 3,
      ),
    );
  }
}
