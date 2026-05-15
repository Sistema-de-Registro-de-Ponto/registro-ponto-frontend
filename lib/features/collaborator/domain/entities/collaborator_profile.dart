import 'package:equatable/equatable.dart';

class CollaboratorProfile extends Equatable {
  final int userId;
  final String firstName;

  const CollaboratorProfile({required this.userId, required this.firstName});

  String get firstLetterOfName => firstName.trim().isEmpty ? '—' : firstName.trim()[0].toUpperCase();

  @override
  List<Object?> get props => [userId, firstName];
}
