// 인생 유산 관련 Repository

import 'package:ai_life_legacy/features/post/data/post_api.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

abstract class PostRepository {
  Future<SuccessResponse<List<TocQuestionDto>>> getTocQuestions(int tocId);
  Future<SuccessResponse<void>> saveAnswer(int questionId, AnswerSaveDto dto);
}

class PostRepositoryImpl implements PostRepository {
  final LifeLegacyApi api;
  PostRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<List<TocQuestionDto>>> getTocQuestions(int tocId) =>
      api.getTocQuestions(tocId);

  @override
  Future<SuccessResponse<void>> saveAnswer(int questionId, AnswerSaveDto dto) =>
      api.saveAnswer(questionId, dto);
}
