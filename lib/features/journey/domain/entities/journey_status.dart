enum JourneyStatus {
  waiting,
  inProgress,
  completed;

  static JourneyStatus fromApi(String value) {
    return switch (value) {
      'in_progress' => JourneyStatus.inProgress,
      'completed' => JourneyStatus.completed,
      _ => JourneyStatus.waiting,
    };
  }
}
