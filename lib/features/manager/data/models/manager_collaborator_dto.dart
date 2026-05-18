import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';

class ManagerCollaboratorDto {
  final int id;
  final String firstName;
  final JourneyStatus currentJourneyStatus;
  final int hoursTodaySeconds;
  final int? adherencePercentage;

  const ManagerCollaboratorDto({
    required this.id,
    required this.firstName,
    required this.currentJourneyStatus,
    required this.hoursTodaySeconds,
    required this.adherencePercentage,
  });

  factory ManagerCollaboratorDto.fromJson(Map<String, dynamic> json) {
    final adherenceRaw = json['adherence_percentage'];

    return ManagerCollaboratorDto(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      currentJourneyStatus: JourneyStatus.fromApi(
        json['current_journey_status'] as String,
      ),
      hoursTodaySeconds: json['hours_today_seconds'] as int,
      adherencePercentage: adherenceRaw == null ? null : adherenceRaw as int,
    );
  }

  ManagerCollaborator toEntity() {
    return ManagerCollaborator(
      id: id,
      firstName: firstName,
      currentJourneyStatus: currentJourneyStatus,
      hoursTodaySeconds: hoursTodaySeconds,
      adherencePercentage: adherencePercentage,
    );
  }
}
