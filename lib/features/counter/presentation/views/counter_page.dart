import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/view_models/auth_session_controller.dart';
import '../view_models/counter_view_model.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterViewModelProvider);
    final viewModel = ref.read(counterViewModelProvider.notifier);
    final session = ref.watch(authSessionControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(session != null
            ? 'Olá, ${session.user.username}'
            : 'Contador'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () =>
                ref.read(authSessionControllerProvider.notifier).clear(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor atual:'),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: viewModel.decrement,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: viewModel.reset,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: viewModel.increment,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
