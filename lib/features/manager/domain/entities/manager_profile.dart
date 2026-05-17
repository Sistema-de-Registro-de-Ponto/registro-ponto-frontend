import 'package:equatable/equatable.dart';

class ManagerProfile extends Equatable {
  final int userId;
  final String firstName;

  const ManagerProfile({required this.userId, required this.firstName});

  String get firstLetterOfName => firstName.trim().isEmpty ? '—' : firstName.trim()[0].toUpperCase();

  @override
  List<Object?> get props => [userId, firstName];
}
