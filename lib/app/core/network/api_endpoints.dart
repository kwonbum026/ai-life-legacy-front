// 서버 엔드포인트 상수 모음.
// 하드코딩 문자열을 한곳에서 관리해 오타/경로 변경 리스크 감소.

/// API 엔드포인트 상수
class ApiEndpoints {
  // 루트 API
  static const healthCheck = '/';

  // 인증 API
  static const signUp = '/auth/signup';
  static const login = '/auth/login';
  static const refreshToken = '/auth/refresh';

  // 사용자 API
  static const userIntro = '/users/me/intro';
  static const userToc = '/users/me/toc';
  static const userTocQuestions = '/users/me/toc-questions';
  static String userAnswers({int? questionId}) {
    if (questionId != null) {
      return '/users/me/answers?questionId=$questionId';
    }
    return '/users/me/answers';
  }
  static String userAnswerUpdate(int answerId) => '/users/me/answers/$answerId';

  // 인생 유산 API
  static String tocQuestions(int tocId) => '/life-legacy/toc/$tocId/questions';
  static String questionAnswer(int questionId) => '/life-legacy/questions/$questionId/answers';

  // AI API
  static const aiCase = '/ai/case';
  static const aiQuestion = '/ai/question';
  static const aiCombine = '/ai/combine';
}
