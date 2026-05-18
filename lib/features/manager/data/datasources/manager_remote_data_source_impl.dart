import 'package:dio/dio.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/pagination/page_dto.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';

import '../models/manager_collaborator_detail_dto.dart';
import '../models/manager_collaborator_dto.dart';
import '../models/manager_consolidated_report_dto.dart';
import '../models/manager_journey_list_item_dto.dart';
import '../models/manager_overview_dto.dart';
import '../models/manager_profile_dto.dart';
import 'manager_remote_data_source.dart';

class ManagerRemoteDataSourceImpl implements ManagerRemoteDataSource {
  final Dio _dio;

  const ManagerRemoteDataSourceImpl(this._dio);

  @override
  Future<ManagerProfileDto> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/manager');
      return ManagerProfileDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<ManagerOverviewDto> fetchOverview({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/overview',
        queryParameters: <String, dynamic>{
          'start_date': startDate.formattedApiDate,
          'end_date': endDate.formattedApiDate,
        },
      );
      return ManagerOverviewDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<PageDto<ManagerCollaboratorDto>> fetchCollaborators({
    required int page,
    required int pageSize,
    String? query,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': pageSize,
        if (query != null && query.isNotEmpty) 'search': query,
      };

      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/collaborators',
        queryParameters: queryParameters,
      );
      return PageDto.fromJson(
        response.data!,
        ManagerCollaboratorDto.fromJson,
      );
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<ManagerCollaboratorDetailDto> fetchCollaboratorById(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/collaborators/$id',
      );
      return ManagerCollaboratorDetailDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<PageDto<ManagerJourneyListItemDto>> fetchJourneys({
    required int page,
    required int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    String? collaboratorName,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': pageSize,
        if (startDate != null) 'start_date': startDate.formattedApiDate,
        if (endDate != null) 'end_date': endDate.formattedApiDate,
        if (collaboratorName != null && collaboratorName.isNotEmpty)
          'collaborator_name': collaboratorName,
      };

      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/journeys',
        queryParameters: queryParameters,
      );
      return PageDto.fromJson(
        response.data!,
        ManagerJourneyListItemDto.fromJson,
      );
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyDto> fetchJourneyById(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/journeys/$id',
      );
      return JourneyDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<ManagerConsolidatedReportDto> fetchConsolidatedReport({
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'start_date': startDate.formattedApiDate,
        'end_date': endDate.formattedApiDate,
        'page': page,
        'size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/manager/reports/consolidated',
        queryParameters: queryParameters,
      );
      return ManagerConsolidatedReportDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
