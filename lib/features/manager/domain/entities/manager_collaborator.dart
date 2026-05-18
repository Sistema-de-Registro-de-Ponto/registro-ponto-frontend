import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

class ManagerCollaborator extends Equatable {
  final int id;
  final String firstName;
  final JourneyStatus currentJourneyStatus;
  final int hoursTodaySeconds;
  final int? adherencePercentage;

  const ManagerCollaborator({
    required this.id,
    required this.firstName,
    required this.currentJourneyStatus,
    required this.hoursTodaySeconds,
    required this.adherencePercentage,
  });

  String get currentJourneyStatusLabel => switch (currentJourneyStatus) {
    JourneyStatus.inProgress => 'EM ANDAMENTO',
    JourneyStatus.completed => 'FINALIZADA',
    JourneyStatus.waiting => 'AGUARDANDO',
  };

  bool get isCurrentJourneyInProgress =>
      currentJourneyStatus == JourneyStatus.inProgress;

  String get hoursTodayLabel =>
      Duration(seconds: hoursTodaySeconds).formattedHm;

  String get adherenceLabel =>
      adherencePercentage == null ? '-' : '$adherencePercentage%';

  @override
  List<Object?> get props => [
    id,
    firstName,
    currentJourneyStatus,
    hoursTodaySeconds,
    adherencePercentage,
  ];
}
