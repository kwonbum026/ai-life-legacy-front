// 게시글(자서전) 관련 DTO 모델

/// 자서전 저장 요청 DTO
class SavePostDto {
  final String response;
  final int contentId;
  final int questionId;

  SavePostDto({
    required this.response,
    required this.contentId,
    required this.questionId,
  });

  factory SavePostDto.fromJson(Map<String, dynamic> json) {
    return SavePostDto(
      response: json['response'] as String,
      contentId: json['contentId'] as int,
      questionId: json['questionId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'contentId': contentId,
      'questionId': questionId,
    };
  }
}

/// 자서전 업데이트 요청 DTO
class PatchPostDto {
  final String response;
  final int contentId;
  final int questionId;

  PatchPostDto({
    required this.response,
    required this.contentId,
    required this.questionId,
  });

  factory PatchPostDto.fromJson(Map<String, dynamic> json) {
    return PatchPostDto(
      response: json['response'] as String,
      contentId: json['contentId'] as int,
      questionId: json['questionId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'contentId': contentId,
      'questionId': questionId,
    };
  }
}

