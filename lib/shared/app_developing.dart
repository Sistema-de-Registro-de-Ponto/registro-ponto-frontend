import 'package:flutter/material.dart';

class AppDeveloping extends StatelessWidget {
  const AppDeveloping({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Esta funcionalidade está em desenvolvimento...',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
    );
  }
}
