import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:grow_first/core/utils/sizing.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool hideGradient;
  final Color? backgroundColor;
  final bool enableBorder;
  final Color? borderColor;
  final Widget? iconWithTitle;
  final bool showIconFirst;
  final bool showLoadingIndicator;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 48,
    this.borderRadius = 12,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.hideGradient = false,
    this.backgroundColor,
    this.enableBorder = false,
    this.borderColor,
    this.iconWithTitle,
    this.showIconFirst = false,
    this.showLoadingIndicator = false,
  });

  LinearGradient? get _gradient {
    if (hideGradient) {
      return null;
    } else if (onTap != null) {
      return const LinearGradient(
        colors: [Color(0xFF10326B), Color(0xFF10326B), Color(0xFF30D3D9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [-1.4, -0.2, 1.0],
      );
    }
    return LinearGradient(
      colors: [Colors.grey.shade400, Colors.grey.shade500],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  Widget get _text {
    return Text(
      text,
      style:
          textStyle ??
          const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: _gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: enableBorder
              ? Border.all(color: borderColor ?? aquaBlueColor, width: 1.2)
              : null,
        ),
        child: showLoadingIndicator
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: const CircularProgressIndicator(color: whiteColor),
                  ),
                ],
              )
            : iconWithTitle != null
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  if (showIconFirst) ...[
                    ?iconWithTitle,
                    horizontalMargin4,
                    _text,
                  ] else ...[
                    _text,
                    horizontalMargin2,
                    ?iconWithTitle,
                  ],
                ],
              )
            : Center(child: _text),
      ),
    );
  }
}

class GradientButtonSecond extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool hideGradient;
  final Color? backgroundColor;
  final bool enableBorder;
  final Color? borderColor;
  final Widget? iconWithTitle;
  final bool showIconFirst;
  final bool showLoadingIndicator;

  const GradientButtonSecond({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 48,
    this.borderRadius = 12,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.hideGradient = false,
    this.backgroundColor,
    this.enableBorder = false,
    this.borderColor,
    this.iconWithTitle,
    this.showIconFirst = false,
    this.showLoadingIndicator = false,
  });

  LinearGradient? get _gradient {
    if (hideGradient) {
      return null;
    } else if (onTap != null) {
      return const LinearGradient(
        colors: [Color(0xFF10326B), Color(0xFF10326B), Color(0xFF30D3D9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [-1.4, -0.2, 1.0],
      );
    }
    return LinearGradient(
      colors: [Colors.grey.shade400, Colors.grey.shade500],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  Widget get _text {
    return Text(
      text,
      style:
          textStyle ??
          const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: _gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: enableBorder
              ? Border.all(color: borderColor ?? aquaBlueColor, width: 1.2)
              : null,
        ),
        child: showLoadingIndicator
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: const CircularProgressIndicator(color: whiteColor),
                  ),
                ],
              )
            : iconWithTitle != null
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  if (showIconFirst) ...[
                    ?iconWithTitle,
                    horizontalMargin4,
                    _text,
                  ] else ...[
                    _text,
                    horizontalMargin2,
                    ?iconWithTitle,
                  ],
                ],
              )
            : Center(child: _text),
      ),
    );
  }
}


class GradientButtonThird extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool hideGradient;
  final Color? backgroundColor;
  final bool enableBorder;
  final Color? borderColor;
  final Widget? iconWithTitle;
  final bool showIconFirst;
  final bool showLoadingIndicator;
  final double ?fontSize;

  const GradientButtonThird({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 48,
    this.borderRadius = 12,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.hideGradient = false,
    this.backgroundColor,
    this.enableBorder = false,
    this.borderColor,
    this.iconWithTitle,
    this.showIconFirst = false,
    this.showLoadingIndicator = false,
    this.fontSize,
  });

  LinearGradient? get _gradient {
    if (hideGradient) {
      return null;
    } else if (onTap != null) {
      return const LinearGradient(
        colors: [Color(0xFF10326B), Color(0xFF10326B), Color(0xFF30D3D9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [-1.4, -0.2, 1.0],
      );
    }
    return LinearGradient(
      colors: [Colors.grey.shade400, Colors.grey.shade500],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  Widget get _text {
    return Text(
      text,
      style:
          textStyle ??
           TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 11,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: _gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: enableBorder
              ? Border.all(color: borderColor ?? aquaBlueColor, width: 1.2)
              : null,
        ),
        child: showLoadingIndicator
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: const CircularProgressIndicator(color: whiteColor),
                  ),
                ],
              )
            : iconWithTitle != null
            ? Row(
                mainAxisAlignment: .center,
                children: [
                  if (showIconFirst) ...[
                    ?iconWithTitle,
                    horizontalMargin4,
                    _text,
                  ] else ...[
                    _text,
                    horizontalMargin2,
                    ?iconWithTitle,
                  ],
                ],
              )
            : Center(child: _text),
      ),
    );
  }
}
