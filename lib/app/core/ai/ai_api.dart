/// AI 관련 API 호출 클래스

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';
import 'package:ai_life_legacy/app/core/ai/models/ai.dto.dart';

class AiApi {
  final Dio _dio = DioClient.instance;

  /// 2차 질문 생성 AI
  /// 1차 질문과 사용자의 답변을 기반으로 2차 질문을 생성합니다.
  Future<SuccessResponse<AiResponseDto>> makeReQuestion(
    MakeReQuestionDto dto,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.aiQuestion,
      data: dto.toJson(),
    );

    return SuccessResponse<AiResponseDto>.fromJson(
      response.data,
      (json) => AiResponseDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 자서전 답변 합치기 AI
  /// 1차 질문/답변과 2차 질문/답변을 합쳐서 자서전 형식의 답변을 생성합니다.
  Future<SuccessResponse<AiResponseDto>> combine(CombineDto dto) async {
    final response = await _dio.post(
      ApiEndpoints.aiCombine,
      data: dto.toJson(),
    );

    return SuccessResponse<AiResponseDto>.fromJson(
      response.data,
      (json) => AiResponseDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
