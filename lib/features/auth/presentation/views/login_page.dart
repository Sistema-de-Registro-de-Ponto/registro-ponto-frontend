import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';

import '../view_models/login_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final LoginViewModel _viewModel = ref.read(loginViewModelProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final failure = state.failure;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppBrandLogo(compact: true)),
                      const SizedBox(height: 24),
                      Text('Entrar', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      AppTextFormField(
                        key: const ValueKey('login.username'),
                        enabled: !state.isLoading,
                        textInputAction: TextInputAction.next,
                        onChanged: _viewModel.setUsername,
                        validator: _viewModel.usernameValidator,
                        autofillHints: const [AutofillHints.username],
                        labelText: 'Usuário',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      const SizedBox(height: 16),
                      AppTextFormField(
                        key: const ValueKey('login.password'),
                        enabled: !state.isLoading,
                        obscureText: !state.passwordVisible,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onSubmit(),
                        onChanged: _viewModel.setPassword,
                        validator: _viewModel.passwordValidator,
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: _viewModel.togglePasswordVisibility,
                          icon: Icon(state.passwordVisible ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      if (failure != null) ...[const SizedBox(height: 16), AppErrorBanner(message: failure)],
                      const SizedBox(height: 24),
                      AppFilledButton(
                        key: const ValueKey('login.submit'),
                        text: 'Entrar',
                        onPressed: _onSubmit,
                        isLoading: state.isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    _viewModel.submit();
  }
}
