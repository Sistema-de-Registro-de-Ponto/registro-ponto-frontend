import 'package:flutter/material.dart';

import 'app_loading.dart';

class AppFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(100, 48),
      ),
      child: isLoading ? const AppLoading(dimension: 24) : _child,
    );
  }

  VoidCallback? get _onPressed {
    return isLoading || !isEnabled ? null : onPressed;
  }

  Widget get _child {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [Icon(icon), Text(text)],
      );
    }
    return Text(text);
  }
}
