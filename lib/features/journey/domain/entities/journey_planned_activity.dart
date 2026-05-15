import 'package:equatable/equatable.dart';

class JourneyPlannedActivity extends Equatable {
  final int id;
  final int plannedActivityId;
  final String description;
  final bool checked;

  const JourneyPlannedActivity({
    required this.id,
    required this.plannedActivityId,
    required this.description,
    required this.checked,
  });

  @override
  List<Object?> get props => [id, plannedActivityId, description, checked];
}
