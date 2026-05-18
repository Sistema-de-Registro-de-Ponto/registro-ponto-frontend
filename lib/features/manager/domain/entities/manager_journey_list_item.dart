import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

class ManagerJourneyListItem extends Equatable {
  final int id;
  final DateTime journeyDate;
  final int collaboratorId;
  final String collaboratorFirstName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final JourneyStatus status;

  const ManagerJourneyListItem({
    required this.id,
    required this.journeyDate,
    required this.collaboratorId,
    required this.collaboratorFirstName,
    required this.startedAt,
    this.endedAt,
    this.duration,
    required this.status,
  });

  String get dateLabel => journeyDate.formattedShortDate;

  String get weekdayLabel => journeyDate.formattedWeekday;

  String get entryLabel => startedAt.formattedHourShort;

  String get exitLabel => endedAt?.formattedHourShort ?? '-';

  bool get isInProgress => status == JourneyStatus.inProgress;

  String get statusLabel => switch (status) {
    JourneyStatus.inProgress => 'Em andamento',
    JourneyStatus.completed => 'Finalizada',
    JourneyStatus.waiting => 'Aguardando',
  };

  Duration displayDuration(DateTime at) =>
      duration ?? at.elapsedSince(startedAt);

  String totalHoursLabel(DateTime at) => displayDuration(at).formattedHm;

  @override
  List<Object?> get props => [
    id,
    journeyDate,
    collaboratorId,
    collaboratorFirstName,
    startedAt,
    endedAt,
    duration,
    status,
  ];
}
