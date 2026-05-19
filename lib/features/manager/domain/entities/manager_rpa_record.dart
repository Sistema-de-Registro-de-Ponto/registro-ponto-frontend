import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

class ManagerRpaRecord extends Equatable {
  final int id;
  final String sourceSystem;
  final String externalEmployeeId;
  final String employeeName;
  final DateTime workDate;
  final DateTime checkInAt;
  final DateTime? checkOutAt;
  final Duration? workedDuration;
  final DateTime importedAt;
  final int? collaboratorId;
  final String? collaboratorFirstName;

  const ManagerRpaRecord({
    required this.id,
    required this.sourceSystem,
    required this.externalEmployeeId,
    required this.employeeName,
    required this.workDate,
    required this.checkInAt,
    this.checkOutAt,
    this.workedDuration,
    required this.importedAt,
    this.collaboratorId,
    this.collaboratorFirstName,
  });

  String get dateLabel => workDate.formattedShortDate;

  String get weekdayLabel => workDate.formattedWeekday;

  String get employeeDisplayName => collaboratorFirstName ?? employeeName;

  String get entryLabel => checkInAt.formattedHourShort;

  String get exitLabel => checkOutAt?.formattedHourShort ?? '-';

  String get workedHoursLabel =>
      workedDuration?.formattedHm ?? '-';

  String get sourceSystemLabel => switch (sourceSystem) {
    'ponto_agil' => 'Ponto Ágil',
    _ => sourceSystem,
  };

  String get importedAtLabel {
    final local = importedAt.isUtc ? importedAt.toLocal() : importedAt;
    return '${local.formattedShortDate} ${local.formattedHourShort}';
  }

  @override
  List<Object?> get props => [
    id,
    sourceSystem,
    externalEmployeeId,
    employeeName,
    workDate,
    checkInAt,
    checkOutAt,
    workedDuration,
    importedAt,
    collaboratorId,
    collaboratorFirstName,
  ];
}
