import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final bool enabled;
  final bool obscureText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const AppTextFormField({
    super.key,
    required this.enabled,
    required this.textInputAction,
    required this.onChanged,
    required this.labelText,
    required this.validator,
    this.obscureText = false,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
