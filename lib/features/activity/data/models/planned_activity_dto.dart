import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';

class PlannedActivityDto {
  final int id;
  final String description;
  final DateTime createdAt;

  const PlannedActivityDto({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  factory PlannedActivityDto.fromJson(Map<String, dynamic> json) {
    return PlannedActivityDto(
      id: json['id'] as int,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  PlannedActivity toEntity() {
    return PlannedActivity(
      id: id,
      description: description,
      createdAt: createdAt,
    );
  }

  Map<String, Object> toJson() => {'id': id, 'description': description};
}
