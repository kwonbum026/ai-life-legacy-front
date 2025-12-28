/// 인생 유산(Autobiography) 관련 API 호출 클래스
/// - 목차별 질문 조회, 답변 저장 등

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';

class AutobiographyApi {
  final Dio _dio = DioClient.instance;

  /// 특정 목차(TOC)에 해당하는 질문 목록을 조회합니다.
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

  /// 질문에 대한 답변을 생성(저장)합니다. (Life Legacy API)
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
