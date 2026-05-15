import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final double? dimension;
  final double strokeWidth;
  final Color? color;

  const AppLoading({
    super.key,
    this.dimension,
    this.strokeWidth = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: dimension,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }
}
