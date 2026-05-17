enum UserRole {
  collaborator,
  manager;

  static UserRole fromApiValue(String value) => switch (value) {
    'COLLABORATOR' => UserRole.collaborator,
    'MANAGER' => UserRole.manager,
    _ => throw ArgumentError.value(value, 'role', 'Unknown user role'),
  };

  String get apiValue => switch (this) {
    UserRole.collaborator => 'COLLABORATOR',
    UserRole.manager => 'MANAGER',
  };
}
