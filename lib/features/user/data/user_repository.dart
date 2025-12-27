// 사용자 관련 Repository

import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

abstract class UserRepository {
  Future<SuccessResponse<void>> saveSelfIntro(UserIntroDto dto);
  Future<SuccessResponse<List<UserTocDto>>> getUserToc();
  Future<SuccessResponse<List<UserTocQuestionDto>>> getUserTocQuestions();
  Future<SuccessResponse<UserAnswerDto>> getUserAnswers(
      {int? questionId, int? tocId});
  Future<SuccessResponse<void>> updateAnswer(int answerId, AnswerUpdateDto dto);
  Future<SuccessResponse<void>> deleteUser(UserWithdrawalDto dto);
}

class UserRepositoryImpl implements UserRepository {
  final UserApi api;
  UserRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<void>> saveSelfIntro(UserIntroDto dto) =>
      api.saveSelfIntro(dto);

  @override
  Future<SuccessResponse<List<UserTocDto>>> getUserToc() => api.getUserToc();

  @override
  Future<SuccessResponse<List<UserTocQuestionDto>>> getUserTocQuestions() =>
      api.getUserTocQuestions();

  @override
  Future<SuccessResponse<UserAnswerDto>> getUserAnswers({
    int? questionId,
    int? tocId,
  }) =>
      api.getUserAnswers(questionId: questionId, tocId: tocId);

  @override
  Future<SuccessResponse<void>> updateAnswer(
    int answerId,
    AnswerUpdateDto dto,
  ) =>
      api.updateAnswer(answerId, dto);

  @override
  Future<SuccessResponse<void>> deleteUser(UserWithdrawalDto dto) =>
      api.deleteUser(dto);
}
