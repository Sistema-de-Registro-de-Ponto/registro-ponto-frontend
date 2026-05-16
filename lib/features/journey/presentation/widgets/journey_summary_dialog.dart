import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';

class JourneySummaryDialog extends StatefulWidget {
  const JourneySummaryDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const JourneySummaryDialog(),
    );
  }

  @override
  State<JourneySummaryDialog> createState() => _JourneySummaryDialogState();
}

class _JourneySummaryDialogState extends State<JourneySummaryDialog> {
  final _summaryController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _onSummaryChanged(_) {
    if (_errorText == null) return;
    setState(() => _errorText = null);
  }

  void _onConfirm() {
    final trimmed = _summaryController.text.trim();
    if (trimmed.isEmpty) {
      setState(() => _errorText = 'Campo obrigatório');
      return;
    }
    Navigator.of(context).pop(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resumo da jornada'),
      content: AppTextFormField(
        enabled: true,
        textInputAction: TextInputAction.newline,
        controller: _summaryController,
        labelText: 'Resumo',
        hintText: 'Descreva como foi a jornada...',
        errorText: _errorText,
        onChanged: _onSummaryChanged,
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        AppFilledButton(onPressed: _onConfirm, text: 'Encerrar jornada'),
      ],
    );
  }
}
