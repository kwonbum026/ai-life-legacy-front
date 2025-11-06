// 사용자 관련 API 호출

import 'package:dio/dio.dart';
import '../../../app/core/network/dio_client.dart';
import '../../../app/core/network/api_endpoints.dart';
import '../../../app/core/models/response.dart';
import 'models/user.dto.dart';

class UserApi {
  final Dio _dio = DioClient.instance;

  /// 사용자 자기소개 저장
  Future<SuccessResponse<void>> saveUserIntro(UserIntroDto dto) async {
    final response = await _dio.post(
      ApiEndpoints.userIntro,
      data: dto.toJson(),
    );
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }

  /// 사용자 목차 조회
  Future<SuccessResponse<List<UserTocDto>>> getUserToc() async {
    final response = await _dio.get(ApiEndpoints.userToc);
    return SuccessResponse<List<UserTocDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => UserTocDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 사용자 목차 및 질문 조회
  Future<SuccessResponse<List<UserTocQuestionDto>>> getUserTocQuestions() async {
    final response = await _dio.get(ApiEndpoints.userTocQuestions);
    return SuccessResponse<List<UserTocQuestionDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => UserTocQuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 사용자 답변 조회
  Future<SuccessResponse<UserAnswerDto>> getUserAnswer(int questionId) async {
    final response = await _dio.get(
      ApiEndpoints.userAnswers(questionId: questionId),
    );
    return SuccessResponse<UserAnswerDto>.fromJson(
      response.data,
      (json) => UserAnswerDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 사용자 답변 수정
  Future<SuccessResponse<void>> updateUserAnswer(
    int answerId,
    AnswerUpdateDto dto,
  ) async {
    final response = await _dio.patch(
      ApiEndpoints.userAnswerUpdate(answerId),
      data: dto.toJson(),
    );
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }
}
