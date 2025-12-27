// 인생 유산 관련 API 호출

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';

class AutobiographyApi {
  final Dio _dio = DioClient.instance;

  /// 목차별 질문 조회
  Future<SuccessResponse<List<TocQuestionDto>>> getQuestions(int tocId) async {
    final response = await _dio.get(
      ApiEndpoints.lifeLegacyQuestions(tocId),
    );
    print('[AutobiographyApi] getQuestions result: ${response.data}');
    return SuccessResponse<List<TocQuestionDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => TocQuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 질문 답변 저장
  Future<SuccessResponse<void>> saveAnswer(
    int tocId,
    int questionId,
    AnswerSaveDto dto,
  ) async {
    print('[AutobiographyApi] saveAnswer payload: ${dto.toJson()}');
    final response = await _dio.post(
      ApiEndpoints.lifeLegacyAnswer(tocId, questionId),
      data: dto.toJson(),
    );
    print('[AutobiographyApi] saveAnswer response: ${response.statusCode}');
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }
}
