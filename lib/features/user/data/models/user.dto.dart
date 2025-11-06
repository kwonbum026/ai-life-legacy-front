// 사용자 관련 DTO 모델

/// 유저 케이스 저장 요청 DTO
class SetUserCaseDto {
  final String caseName;

  SetUserCaseDto({
    required this.caseName,
  });

  factory SetUserCaseDto.fromJson(Map<String, dynamic> json) {
    return SetUserCaseDto(
      caseName: json['caseName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caseName': caseName,
    };
  }
}

/// 유저 케이스 응답 DTO
class UserCaseDto {
  final String name;

  UserCaseDto({
    required this.name,
  });

  factory UserCaseDto.fromJson(Map<String, dynamic> json) {
    return UserCaseDto(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

/// 유저 목차 응답 DTO
class UserContentDto {
  final int id;
  final String content;

  UserContentDto({
    required this.id,
    required this.content,
  });

  factory UserContentDto.fromJson(Map<String, dynamic> json) {
    return UserContentDto(
      id: json['id'] as int,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }
}

/// 유저 질문 응답 DTO
class UserQuestionDto {
  final int id;
  final String question;

  UserQuestionDto({
    required this.id,
    required this.question,
  });

  factory UserQuestionDto.fromJson(Map<String, dynamic> json) {
    return UserQuestionDto(
      id: json['id'] as int,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
    };
  }
}

/// 목차와 질문 목록 응답 DTO
class UserContentAndQuestionsDto {
  final int id;
  final String content;
  final List<UserQuestionDto> questions;

  UserContentAndQuestionsDto({
    required this.id,
    required this.content,
    required this.questions,
  });

  factory UserContentAndQuestionsDto.fromJson(Map<String, dynamic> json) {
    return UserContentAndQuestionsDto(
      id: json['id'] as int,
      content: json['content'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((item) => UserQuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

/// 유저 자서전 데이터 응답 DTO
class UserPostsDto {
  final String response;
  final String content;
  final String question;

  UserPostsDto({
    required this.response,
    required this.content,
    required this.question,
  });

  factory UserPostsDto.fromJson(Map<String, dynamic> json) {
    return UserPostsDto(
      response: json['response'] as String,
      content: json['content'] as String,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'content': content,
      'question': question,
    };
  }
}

