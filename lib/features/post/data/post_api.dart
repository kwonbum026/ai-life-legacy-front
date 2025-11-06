// 인생 유산 관련 API 호출

import 'package:dio/dio.dart';
import '../../../app/core/network/dio_client.dart';
import '../../../app/core/network/api_endpoints.dart';
import '../../../app/core/models/response.dart';
import '../../user/data/models/user.dto.dart';

class LifeLegacyApi {
  final Dio _dio = DioClient.instance;

  /// 목차별 질문 조회
  Future<SuccessResponse<List<TocQuestionDto>>> getTocQuestions(int tocId) async {
    final response = await _dio.get(ApiEndpoints.tocQuestions(tocId));
    return SuccessResponse<List<TocQuestionDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => TocQuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 질문 답변 저장
  Future<SuccessResponse<void>> saveAnswer(int questionId, AnswerSaveDto dto) async {
    final response = await _dio.post(
      ApiEndpoints.questionAnswer(questionId),
      data: dto.toJson(),
    );
    return SuccessResponse<void>.fromJson(
      response.data,
      (json) => null,
    );
  }
}
