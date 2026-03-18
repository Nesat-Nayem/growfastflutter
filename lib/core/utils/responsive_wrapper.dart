import 'package:flutter/material.dart';

/// Wraps [child] in a centered, max-width-constrained container on tablets.
/// On phones (width <= 600) the child fills the screen unchanged.
/// On tablets/iPads the content is centered at max 600 px with dark sidebars.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  /// Maximum content width for phone-style UI on wide screens.
  static const double _maxMobileWidth = 600.0;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= _maxMobileWidth) {
      return child;
    }

    // Tablet / iPad: center the app UI, fill sidebars with a neutral color
    return ColoredBox(
      color: const Color(0xFF10326B),
      child: Center(
        child: SizedBox(
          width: _maxMobileWidth,
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
