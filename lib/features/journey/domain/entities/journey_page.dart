import 'package:equatable/equatable.dart';

import 'journey.dart';

class JourneyPage extends Equatable {
  final List<Journey> journeys;
  final bool last;

  const JourneyPage({
    required this.journeys,
    required this.last,
  });

  bool get hasMore => !last;

  @override
  List<Object?> get props => [journeys, last];
}
