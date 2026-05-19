import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_rpa_record.dart';

class ManagerRpaRecordDto {
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

  const ManagerRpaRecordDto({
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

  static Duration? _durationFromJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return Duration(seconds: raw);
    if (raw is num) return Duration(seconds: raw.round());
    return null;
  }

  static DateTime? _parseDateTime(dynamic raw) {
    if (raw is! String) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  factory ManagerRpaRecordDto.fromJson(Map<String, dynamic> json) {
    return ManagerRpaRecordDto(
      id: json['id'] as int,
      sourceSystem: json['source_system'] as String,
      externalEmployeeId: json['external_employee_id'] as String,
      employeeName: json['employee_name'] as String,
      workDate: DateTime.parse(json['work_date'] as String).dateOnly,
      checkInAt: _parseDateTime(json['check_in_at'])!,
      checkOutAt: _parseDateTime(json['check_out_at']),
      workedDuration: _durationFromJson(json['worked_seconds']),
      importedAt: _parseDateTime(json['imported_at'])!,
      collaboratorId: json['collaborator_id'] as int?,
      collaboratorFirstName: json['collaborator_first_name'] as String?,
    );
  }

  ManagerRpaRecord toEntity() {
    return ManagerRpaRecord(
      id: id,
      sourceSystem: sourceSystem,
      externalEmployeeId: externalEmployeeId,
      employeeName: employeeName,
      workDate: workDate,
      checkInAt: checkInAt,
      checkOutAt: checkOutAt,
      workedDuration: workedDuration,
      importedAt: importedAt,
      collaboratorId: collaboratorId,
      collaboratorFirstName: collaboratorFirstName,
    );
  }
}
