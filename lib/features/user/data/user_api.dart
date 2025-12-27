// 사용자 관련 API 호출

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';

class UserApi {
  final Dio _dio = DioClient.instance;

  /// 유저 자기소개 저장 (User Case 반환)
  Future<SuccessResponse<void>> saveSelfIntro(UserIntroDto dto) async {
    final response = await _dio.post(
      ApiEndpoints.userIntro,
      data: dto.toJson(),
    );
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }

  /// 유저 맞춤형 목차 조회
  Future<SuccessResponse<List<UserTocDto>>> getUserToc() async {
    final response = await _dio.get(ApiEndpoints.userToc);
    return SuccessResponse<List<UserTocDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => UserTocDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 유저 맞춤형 목차 및 질문 조회
  Future<SuccessResponse<List<UserTocQuestionDto>>>
      getUserTocQuestions() async {
    final response = await _dio.get(ApiEndpoints.userTocQuestions);
    return SuccessResponse<List<UserTocQuestionDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) =>
              UserTocQuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 유저 작성 답변 조회
  Future<SuccessResponse<UserAnswerDto>> getUserAnswers({
    int? questionId,
    int? tocId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.userAnswers,
      queryParameters: {
        if (questionId != null) 'questionId': questionId,
        if (tocId != null) 'tocId': tocId,
      },
    );
    return SuccessResponse<UserAnswerDto>.fromJson(
      response.data,
      (json) => UserAnswerDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 답변 수정 (자서전 업데이트)
  Future<SuccessResponse<void>> updateAnswer(
    int answerId,
    AnswerUpdateDto dto,
  ) async {
    print('[UserApi] updateAnswer payload: ${dto.toJson()}');
    final response = await _dio.patch(
      ApiEndpoints.userAnswerUpdate(answerId),
      data: dto.toJson(),
    );
    print('[UserApi] updateAnswer response: ${response.statusCode}');
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }

  /// 회원탈퇴
  Future<SuccessResponse<void>> deleteUser(UserWithdrawalDto dto) async {
    final response = await _dio.delete(
      ApiEndpoints.deleteUser,
      data: dto.toJson(),
    );
    return SuccessResponse<void>.fromJson(
      response.data,
      (_) {},
    );
  }
}
