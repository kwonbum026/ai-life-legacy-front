// 사용자 관련 DTO 모델

/// 유저 목차 응답 DTO
class UserTocDto {
  final int id;
  final String title;

  UserTocDto({
    required this.id,
    required this.title,
  });

  factory UserTocDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['tocId'];
    final rawTitle = json['title'] ?? json['tocTitle'];

    if (rawId == null) {
      throw ArgumentError('UserTocDto: id/tocId is required. payload=$json');
    }
    if (rawTitle == null) {
      throw ArgumentError('UserTocDto: title/tocTitle is required. payload=$json');
    }

    return UserTocDto(
      id: rawId is int ? rawId : int.tryParse(rawId.toString()) ?? (throw ArgumentError('UserTocDto: invalid id "$rawId"')),
      title: rawTitle.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

/// 목차와 질문 목록 응답 DTO
class UserTocQuestionDto {
  final int tocId;
  final String tocTitle;
  final int orderIndex;
  final List<QuestionDto> questions;

  UserTocQuestionDto({
    required this.tocId,
    required this.tocTitle,
    required this.orderIndex,
    required this.questions,
  });

  factory UserTocQuestionDto.fromJson(Map<String, dynamic> json) {
    return UserTocQuestionDto(
      tocId: json['tocId'] as int,
      tocTitle: json['tocTitle'] as String,
      orderIndex: json['orderIndex'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((item) => QuestionDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tocId': tocId,
      'tocTitle': tocTitle,
      'orderIndex': orderIndex,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

/// 질문 DTO
class QuestionDto {
  final int id;
  final String questionText;

  QuestionDto({
    required this.id,
    required this.questionText,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    return QuestionDto(
      id: json['id'] as int,
      questionText: json['questionText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
    };
  }
}

/// 목차별 질문 조회 응답 DTO (life-legacy API)
class TocQuestionDto {
  final int id;
  final String question;

  TocQuestionDto({
    required this.id,
    required this.question,
  });

  factory TocQuestionDto.fromJson(Map<String, dynamic> json) {
    return TocQuestionDto(
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

/// 답변 조회 응답 DTO
class UserAnswerDto {
  final int questionId;
  final String answerText;
  final int? answerId;

  UserAnswerDto({
    required this.questionId,
    required this.answerText,
    this.answerId,
  });

  factory UserAnswerDto.fromJson(Map<String, dynamic> json) {
    return UserAnswerDto(
      questionId: json['questionId'] as int,
      answerText: json['answerText'] as String? ?? '',
      answerId: json['answerId'] as int? ?? json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerText': answerText,
      if (answerId != null) 'answerId': answerId,
    };
  }
}

/// 자기소개 저장 요청 DTO
class UserIntroDto {
  final String userIntro;

  UserIntroDto({
    required this.userIntro,
  });

  factory UserIntroDto.fromJson(Map<String, dynamic> json) {
    return UserIntroDto(
      userIntro: json['userIntro'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userIntro': userIntro,
    };
  }
}

/// 답변 저장 요청 DTO
class AnswerSaveDto {
  final String answerText;

  AnswerSaveDto({
    required this.answerText,
  });

  factory AnswerSaveDto.fromJson(Map<String, dynamic> json) {
    return AnswerSaveDto(
      answerText: json['answerText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerText': answerText,
    };
  }
}

/// 답변 수정 요청 DTO
class AnswerUpdateDto {
  final String newAnswerText;

  AnswerUpdateDto({
    required this.newAnswerText,
  });

  factory AnswerUpdateDto.fromJson(Map<String, dynamic> json) {
    return AnswerUpdateDto(
      newAnswerText: json['newAnswerText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newAnswerText': newAnswerText,
    };
  }
}
