// 인생 유산 관련 Repository

import 'package:ai_life_legacy/features/autobiography/data/autobiography_api.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';

abstract class AutobiographyRepository {
  Future<SuccessResponse<List<TocQuestionDto>>> getQuestions(int tocId);
  Future<SuccessResponse<void>> saveAnswer(
      int tocId, int questionId, AnswerSaveDto dto);
}

class AutobiographyRepositoryImpl implements AutobiographyRepository {
  final AutobiographyApi api;
  AutobiographyRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<List<TocQuestionDto>>> getQuestions(int tocId) =>
      api.getQuestions(tocId);

  @override
  Future<SuccessResponse<void>> saveAnswer(
    int tocId,
    int questionId,
    AnswerSaveDto dto,
  ) =>
      api.saveAnswer(tocId, questionId, dto);
}
