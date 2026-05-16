import 'package:equatable/equatable.dart';

class JourneyUnplannedActivity extends Equatable {
  final int id;
  final int journeyId;
  final String description;
  final DateTime createdAt;

  const JourneyUnplannedActivity({
    required this.id,
    required this.journeyId,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, journeyId, description, createdAt];
}
