import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/app/theme.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/auth_session_controller.dart';
class AppProfileMenu extends ConsumerWidget {
  final String firstName;
  final String avatarInitial;
  final String roleLabel;

  const AppProfileMenu({
    super.key,
    required this.firstName,
    required this.avatarInitial,
    required this.roleLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'logout') {
          ref.read(authSessionControllerProvider.notifier).clear();
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(children: [Icon(Icons.logout_rounded, size: 20), SizedBox(width: 12), Text('Sair')]),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: kAppBrandBlue,
            foregroundColor: Colors.white,
            child: Text(avatarInitial, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(firstName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(
                roleLabel,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
