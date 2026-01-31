import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/widgets/custom_home_drawer.dart';

class CustomerHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomerHomeAppBar({
    super.key,
    this.singleTitle,
    this.actions,
    this.backOpensDrawer = false,
  });

  final String? singleTitle;
  final List<Widget>? actions;
  final bool backOpensDrawer;

  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ModernCustomerDrawer(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 96,
      backgroundColor: whiteColor,
      scrolledUnderElevation: 0,
      leading: Row(
        children: [
          IconButton(
            onPressed: () {
              if (backOpensDrawer) {
                _openDrawer(context);
              } else {
                context.pop();
              }
            },
            icon: Icon(Icons.arrow_back),
          ),

          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _openDrawer(context),
          ),
        ],
      ),

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
                icon: const Icon(Icons.search),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(lightGreyColor),
                ),
                onPressed: () {
                  context.push('/search');
                },
              ),
              horizontalMargin16,
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
