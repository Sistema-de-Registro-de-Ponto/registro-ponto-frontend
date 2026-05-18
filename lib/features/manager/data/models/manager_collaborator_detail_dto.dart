import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator_detail.dart';

class ManagerCollaboratorDetailDto {
  final int id;
  final int userId;
  final String firstName;
  final int hoursTodaySeconds;
  final int? adherencePercentage;
  final JourneyDto? currentJourney;

  const ManagerCollaboratorDetailDto({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.hoursTodaySeconds,
    required this.adherencePercentage,
    this.currentJourney,
  });

  factory ManagerCollaboratorDetailDto.fromJson(Map<String, dynamic> json) {
    final adherenceRaw = json['adherence_percentage'];
    final journeyJson = json['current_journey'];

    return ManagerCollaboratorDetailDto(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      hoursTodaySeconds: json['hours_today_seconds'] as int,
      adherencePercentage: adherenceRaw == null ? null : adherenceRaw as int,
      currentJourney: journeyJson == null
          ? null
          : JourneyDto.fromJson(journeyJson as Map<String, dynamic>),
    );
  }

  ManagerCollaboratorDetail toEntity() {
    return ManagerCollaboratorDetail(
      id: id,
      userId: userId,
      firstName: firstName,
      hoursTodaySeconds: hoursTodaySeconds,
      adherencePercentage: adherencePercentage,
      currentJourney: currentJourney?.toEntity(),
    );
  }
}
