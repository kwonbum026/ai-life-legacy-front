/// AI 관련 Repository 인터페이스 및 구현

import 'package:ai_life_legacy/app/core/models/response.dart';
import 'package:ai_life_legacy/app/core/ai/ai_api.dart';
import 'package:ai_life_legacy/app/core/ai/models/ai.dto.dart';

abstract class AiRepository {
  Future<SuccessResponse<AiResponseDto>> makeReQuestion(MakeReQuestionDto dto);
  Future<SuccessResponse<AiResponseDto>> combine(CombineDto dto);
}

class AiRepositoryImpl implements AiRepository {
  final AiApi api;
  AiRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<AiResponseDto>> makeReQuestion(
    MakeReQuestionDto dto,
  ) =>
      api.makeReQuestion(dto);

  @override
  Future<SuccessResponse<AiResponseDto>> combine(CombineDto dto) =>
      api.combine(dto);
}
