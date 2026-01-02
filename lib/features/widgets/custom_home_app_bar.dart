import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';

class CustomerHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomerHomeAppBar({super.key, this.singleTitle, this.actions});

  final String? singleTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      scrolledUnderElevation: 0,
      title: singleTitle != null
          ? Text(
              singleTitle!,
              style: context.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pune", style: context.labelSmall),
                Row(
                  children: [
                    Text("BTM Layout, 500628", style: context.labelSmall),
                    horizontalMargin4,
                    const Icon(Icons.arrow_right_sharp),
                  ],
                ),
              ],
            ),
      centerTitle: singleTitle != null,
      actions: singleTitle != null
          ? actions
          : [
              IconButton.filled(
                icon: const Icon(Icons.notifications_rounded),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(lightGreyColor),
                ),
                onPressed: () {},
              ),
              horizontalMargin12,
              IconButton.filled(
                icon: const Icon(Icons.search),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(lightGreyColor),
                ),
                onPressed: () {},
              ),
              horizontalMargin16,
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
