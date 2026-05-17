import 'package:registro_ponto_frontend/app/routes.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';

extension UserRoleNavigation on UserRole {
  String get shellRoute => switch (this) {
    UserRole.collaborator => Routes.home,
    UserRole.manager => Routes.management,
  };
}
