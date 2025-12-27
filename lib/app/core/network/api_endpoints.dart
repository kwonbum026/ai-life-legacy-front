// 서버 엔드포인트 상수 모음.
// 하드코딩 문자열을 한곳에서 관리해 오타/경로 변경 리스크 감소.

/// API 엔드포인트 상수
class ApiEndpoints {
  // 루트 API
  static const healthCheck = '/';

  // Auth (인증)
  static const signUp = '/auth/signup';
  static const login = '/auth/login';
  static const refreshToken = '/auth/refresh-token';

  // User (유저)
  static const userIntro = '/users/me/intro'; // POST
  static const userToc = '/users/me/toc'; // GET
  static const userTocQuestions = '/users/me/toc-questions'; // GET
  static const userAnswers = '/users/me/answers'; // GET
  static String userAnswerUpdate(int answerId) =>
      '/users/me/answers/$answerId'; // PATCH
  static const deleteUser = '/users/me'; // DELETE

  // Life Legacy (자서전)
  static String lifeLegacyQuestions(int tocId) =>
      '/life-legacy/toc/$tocId/questions'; // GET
  static String lifeLegacyAnswer(int tocId, int questionId) =>
      '/life-legacy/toc/$tocId/questions/$questionId/answers'; // POST

  // AI (인공지능)
  static const aiQuestion = '/ai/question'; // POST
  static const aiCombine = '/ai/combine'; // POST
}
