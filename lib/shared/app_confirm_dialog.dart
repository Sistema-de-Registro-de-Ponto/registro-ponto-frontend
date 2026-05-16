import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';

class AppConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDestructive = false,
  }) async {
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelLabel),
            ),
            AppFilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              text: confirmLabel,
              backgroundColor: isDestructive ? theme.colorScheme.error : null,
              foregroundColor: isDestructive ? theme.colorScheme.onError : null,
            ),
          ],
        );
      },
    );

    return result;
  }

  static Future<void> showAcknowledgement(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'OK',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            AppFilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              text: confirmLabel,
            ),
          ],
        );
      },
    );
  }
}
