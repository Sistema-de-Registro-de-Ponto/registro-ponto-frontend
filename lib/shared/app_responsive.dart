import 'package:flutter/widgets.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';

class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AppResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Constants.desktopBreakpoint) return desktop;

        final hasTablet = constraints.maxWidth >= Constants.tabletBreakpoint;
        if (hasTablet && tablet != null) return tablet!;

        return mobile;
      },
    );
  }
}
