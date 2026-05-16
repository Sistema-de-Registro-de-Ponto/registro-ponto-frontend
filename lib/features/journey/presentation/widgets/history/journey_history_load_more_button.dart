import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class JourneyHistoryLoadMoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const JourneyHistoryLoadMoreButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox.shrink()
            : Icon(Icons.expand_more, color: theme.colorScheme.onSurface),
        label: isLoading
            ? const AppLoading(dimension: 20)
            : Text(
                'Carregar mais',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
