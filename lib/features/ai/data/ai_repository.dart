// AI 관련 Repository

import 'package:ai_life_legacy/app/core/models/response.dart';
import 'package:ai_life_legacy/features/ai/data/ai_api.dart';
import 'package:ai_life_legacy/features/ai/data/models/ai.dto.dart';

abstract class AiRepository {
  Future<SuccessResponse<AiResponseDto>> makeCase(MakeCaseDto dto);
  Future<SuccessResponse<AiResponseDto>> makeReQuestion(MakeReQuestionDto dto);
  Future<SuccessResponse<AiResponseDto>> combine(CombineDto dto);
}

class AiRepositoryImpl implements AiRepository {
  final AiApi api;
  AiRepositoryImpl(this.api);

  @override
  Future<SuccessResponse<AiResponseDto>> makeCase(MakeCaseDto dto) =>
      api.makeCase(dto);

  @override
  Future<SuccessResponse<AiResponseDto>> makeReQuestion(
    MakeReQuestionDto dto,
  ) =>
      api.makeReQuestion(dto);

  @override
  Future<SuccessResponse<AiResponseDto>> combine(CombineDto dto) =>
      api.combine(dto);
}

