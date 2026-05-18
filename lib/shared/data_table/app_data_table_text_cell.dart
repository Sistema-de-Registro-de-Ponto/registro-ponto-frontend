import 'package:flutter/material.dart';

class AppDataTableTextCell extends StatelessWidget {
  final String value;
  final TextAlign textAlign;
  final FontWeight? fontWeight;

  const AppDataTableTextCell(
    this.value, {
    super.key,
    this.textAlign = TextAlign.start,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        value,
        textAlign: textAlign,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: fontWeight),
      ),
    );
  }
}
