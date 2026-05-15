import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final bool enabled;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;

  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const AppTextFormField({
    super.key,
    required this.enabled,
    required this.textInputAction,
    required this.onChanged,
    this.validator,
    this.labelText,
    this.obscureText = false,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.controller,
    this.hintText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
