import 'package:flutter/material.dart';

class Responsive {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMaxWidth && w < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;
}

/// Drop-in widget: give it a mobile layout and a desktop layout,
/// it picks the right one automatically, and rebuilds on window resize.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.tabletMaxWidth) {
          return desktop;
        } else if (constraints.maxWidth >= Responsive.mobileMaxWidth) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}