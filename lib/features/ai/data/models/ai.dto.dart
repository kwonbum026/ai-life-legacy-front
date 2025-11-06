// AI 관련 DTO 모델

/// 유저 케이스 분류 요청 DTO
class MakeCaseDto {
  final String data;

  MakeCaseDto({
    required this.data,
  });

  factory MakeCaseDto.fromJson(Map<String, dynamic> json) {
    return MakeCaseDto(
      data: json['data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}

/// 2차 질문 생성 요청 DTO
class MakeReQuestionDto {
  final String question;
  final String data;

  MakeReQuestionDto({
    required this.question,
    required this.data,
  });

  factory MakeReQuestionDto.fromJson(Map<String, dynamic> json) {
    return MakeReQuestionDto(
      question: json['question'] as String,
      data: json['data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'data': data,
    };
  }
}

/// 자서전 답변 합치기 요청 DTO
class CombineDto {
  final String question1;
  final String data1;
  final String question2;
  final String data2;

  CombineDto({
    required this.question1,
    required this.data1,
    required this.question2,
    required this.data2,
  });

  factory CombineDto.fromJson(Map<String, dynamic> json) {
    return CombineDto(
      question1: json['question1'] as String,
      data1: json['data1'] as String,
      question2: json['question2'] as String,
      data2: json['data2'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question1': question1,
      'data1': data1,
      'question2': question2,
      'data2': data2,
    };
  }
}

/// AI 응답 DTO
class AiResponseDto {
  final String content;

  AiResponseDto({
    required this.content,
  });

  factory AiResponseDto.fromJson(Map<String, dynamic> json) {
    return AiResponseDto(
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

