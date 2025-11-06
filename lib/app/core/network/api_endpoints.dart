// 서버 엔드포인트 상수 모음.
// 하드코딩 문자열을 한곳에서 관리해 오타/경로 변경 리스크 감소.

/// API 엔드포인트 상수
class ApiEndpoints {
  // 루트 API
  static const healthCheck = '/';

  // 인증 API
  static const signUp = '/auth/signup';
  static const signIn = '/auth/signin';
  static const refreshToken = '/auth/refresh';

  // 사용자 API
  static String getUserCases(String uuid) => '/users/$uuid/cases';
  static String setUserCases(String uuid) => '/users/$uuid/cases';
  static String getUserContents(String uuid) => '/users/$uuid/contents';
  static String getUserContentQuestions(String uuid, int contentsId) =>
      '/users/$uuid/contents/$contentsId/questions';
  static String getUserPosts(String uuid) => '/users/$uuid/posts';
  static String deleteUser(String uuid, {int? deleteType}) {
    if (deleteType != null) {
      return '/users/$uuid?deleteType=$deleteType';
    }
    return '/users/$uuid';
  }

  // AI API
  static const aiCase = '/ai/case';
  static const aiQuestion = '/ai/question';
  static const aiCombine = '/ai/combine';

  // 게시글 API
  static const post = '/post/';
}
