import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';

class AppInformActivity extends StatelessWidget {
  final String title;
  final String hintText;
  final ValueChanged<String> onDescriptionChanged;
  final TextEditingController? descriptionController;
  final String? descriptionErrorText;
  final VoidCallback? onSubmitted;
  final bool isSubmitting;
  final List<Widget>? children;
  final bool interactionEnabled;

  const AppInformActivity({
    super.key,
    required this.title,
    required this.hintText,
    required this.onDescriptionChanged,
    this.descriptionController,
    this.onSubmitted,
    this.isSubmitting = false,
    this.descriptionErrorText,
    this.children,
    this.interactionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canUseForm = interactionEnabled && !isSubmitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        _ActivityCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppTextFormField(
                controller: descriptionController,
                enabled: canUseForm,
                onChanged: onDescriptionChanged,
                onFieldSubmitted: canUseForm
                    ? (_) => onSubmitted?.call()
                    : null,
                textInputAction: TextInputAction.done,
                hintText: hintText,
                errorText: descriptionErrorText,
              ),
              AppFilledButton(
                onPressed: canUseForm ? onSubmitted : null,
                isLoading: isSubmitting,
                isEnabled: canUseForm,
                text: 'Adicionar atividade',
                icon: Icons.add,
              ),
            ],
          ),
        ),
        if (children != null)
          _ActivityCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children ?? [],
            ),
          ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Widget child;

  const _ActivityCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
