import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

class ManagerCollaboratorDetail extends Equatable {
  final int id;
  final int userId;
  final String firstName;
  final int hoursTodaySeconds;
  final int? adherencePercentage;
  final Journey? currentJourney;

  const ManagerCollaboratorDetail({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.hoursTodaySeconds,
    required this.adherencePercentage,
    this.currentJourney,
  });

  String get hoursTodayLabel =>
      Duration(seconds: hoursTodaySeconds).formattedHm;

  String get adherenceLabel =>
      adherencePercentage == null ? '-' : '$adherencePercentage%';

  @override
  List<Object?> get props => [
    id,
    userId,
    firstName,
    hoursTodaySeconds,
    adherencePercentage,
    currentJourney,
  ];
}
