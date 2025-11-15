// 사용자 관련 Repository

import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

abstract class UserRepository {
  Future<SuccessResponse<void>> saveUserIntro(UserIntroDto dto);
  Future<SuccessResponse<List<UserTocDto>>> getUserToc();
  Future<SuccessResponse<List<UserTocQuestionDto>>> getUserTocQuestions();
  Future<SuccessResponse<UserAnswerDto>> getUserAnswer(int questionId);
  Future<SuccessResponse<void>> updateUserAnswer(int answerId, AnswerUpdateDto dto);
}

class UserRepositoryImpl implements UserRepository {
  final UserApi api;
  UserRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<void>> saveUserIntro(UserIntroDto dto) =>
      api.saveUserIntro(dto);

  @override
  Future<SuccessResponse<List<UserTocDto>>> getUserToc() =>
      api.getUserToc();

  @override
  Future<SuccessResponse<List<UserTocQuestionDto>>> getUserTocQuestions() =>
      api.getUserTocQuestions();

  @override
  Future<SuccessResponse<UserAnswerDto>> getUserAnswer(int questionId) =>
      api.getUserAnswer(questionId);

  @override
  Future<SuccessResponse<void>> updateUserAnswer(int answerId, AnswerUpdateDto dto) =>
      api.updateUserAnswer(answerId, dto);
}
