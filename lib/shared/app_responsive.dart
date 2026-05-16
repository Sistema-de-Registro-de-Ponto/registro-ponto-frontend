import 'package:flutter/widgets.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';

class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double desktopBreakpoint;
  final double tabletBreakpoint;

  const AppResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.desktopBreakpoint = Constants.desktopBreakpoint,
    this.tabletBreakpoint = Constants.tabletBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint) return desktop;

        final hasTablet = constraints.maxWidth >= tabletBreakpoint;
        if (hasTablet && tablet != null) return tablet!;

        return mobile;
      },
    );
  }
}
