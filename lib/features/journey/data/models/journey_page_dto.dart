import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_page.dart';

import 'journey_dto.dart';

class JourneyPageDto {
  final List<JourneyDto> journeys;
  final bool last;

  const JourneyPageDto({
    required this.journeys,
    required this.last,
  });

  factory JourneyPageDto.fromJson(Map<String, dynamic> json) {
    return JourneyPageDto(
      journeys: (json['content'] as List)
          .map((item) => JourneyDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      last: json['last'] as bool,
    );
  }

  JourneyPage toEntity() {
    return JourneyPage(
      journeys: journeys.map((dto) => dto.toEntity()).toList(),
      last: last,
    );
  }
}
