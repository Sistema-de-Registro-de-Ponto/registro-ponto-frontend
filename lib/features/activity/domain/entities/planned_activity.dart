import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

class PlannedActivity extends Equatable {
  final int id;
  final String description;
  final DateTime createdAt;

  const PlannedActivity({
    required this.id,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, description, createdAt];

  String get timeLabel => createdAt.formattedHourShort;
}
