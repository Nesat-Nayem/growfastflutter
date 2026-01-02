import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Centralized and scalable BuildContext extensions.
/// Works with Material 3, custom themes, and your ApplicationTheme class.
extension ContextExt on BuildContext {
  // ----------------------------------
  //  THEME & COLORS
  // ----------------------------------

  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;

  // If you have custom colors in a separate class:
  // import 'colors.dart' and expose here.
  // Ex: Color get primaryText => primaryTextColor;

  // ----------------------------------
  //  TEXT STYLES (Material 3 + Your Custom Theme)
  // ----------------------------------

  TextStyle get displayLarge => theme.textTheme.displayLarge!;
  TextStyle get displayMedium => theme.textTheme.displayMedium!;
  TextStyle get displaySmall => theme.textTheme.displaySmall!;

  TextStyle get headlineLarge => theme.textTheme.headlineLarge!;
  TextStyle get headlineMedium => theme.textTheme.headlineMedium!;
  TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  TextStyle get titleLarge => theme.textTheme.titleLarge!;
  TextStyle get titleMedium => theme.textTheme.titleMedium!;
  TextStyle get titleSmall => theme.textTheme.titleSmall!;

  TextStyle get bodyLarge => theme.textTheme.bodyLarge!;
  TextStyle get bodyMedium => theme.textTheme.bodyMedium!;
  TextStyle get bodySmall => theme.textTheme.bodySmall!;

  TextStyle get labelLarge => theme.textTheme.labelLarge!;
  TextStyle get labelMedium => theme.textTheme.labelMedium!;
  TextStyle get labelSmall => theme.textTheme.labelSmall!;

  // ----------------------------------
  //  MEDIAQUERY / SIZE HELPERS
  // ----------------------------------

  Size get screenSize => MediaQuery.sizeOf(this);
  double get height => screenSize.height;
  double get width => screenSize.width;

  double h(double percent) => percent.h;
  double w(double percent) => percent.w;

  bool get isPhone => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  // ----------------------------------
  //  SPACING HELPERS
  // ----------------------------------

  EdgeInsets get paddingLow => EdgeInsets.all(2.w);
  EdgeInsets get paddingNormal => EdgeInsets.all(4.w);
  EdgeInsets get paddingLarge => EdgeInsets.all(6.w);

  // Vertical only
  EdgeInsets get verticalLow => EdgeInsets.symmetric(vertical: 1.h);
  EdgeInsets get verticalNormal => EdgeInsets.symmetric(vertical: 2.h);

  // Horizontal only
  EdgeInsets get horizontalLow => EdgeInsets.symmetric(horizontal: 2.w);

  // ----------------------------------
  //  NAVIGATION SHORTCUTS (GoRouter)
  // ----------------------------------

  void goTo(String route) => Navigator.pushNamed(this, route);
  void goBack() => Navigator.pop(this);

  // ----------------------------------
  //  SAFE AREA HELPERS
  // ----------------------------------

  double get topPadding => MediaQuery.paddingOf(this).top;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  // ----------------------------------
  //  THEME MODE HELPERS
  // ----------------------------------

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
