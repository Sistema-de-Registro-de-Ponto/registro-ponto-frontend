import 'package:flutter/widgets.dart';

const int _desktopBreakpoint = 1024;
const int _tabletBreakpoint = 640;

class AppResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AppResponsive({super.key, required this.mobile, this.tablet, required this.desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _desktopBreakpoint) return desktop;

        if (tablet != null && constraints.maxWidth >= _tabletBreakpoint) return tablet!;

        return mobile;
      },
    );
  }
}
