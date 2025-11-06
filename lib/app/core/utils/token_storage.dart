// 토큰 저장 및 관리 유틸리티
// TODO: 실제 앱에서는 flutter_secure_storage 또는 shared_preferences 사용 권장

class TokenStorage {
  static String? _accessToken;
  static String? _refreshToken;

  /// AccessToken 저장
  static Future<void> saveAccessToken(String token) async {
    _accessToken = token;
    // TODO: 실제 저장소에 저장
    // await secureStorage.write(key: 'access_token', value: token);
  }

  /// RefreshToken 저장
  static Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
    // TODO: 실제 저장소에 저장
    // await secureStorage.write(key: 'refresh_token', value: token);
  }

  /// AccessToken 조회
  static String? getAccessToken() {
    return _accessToken;
    // TODO: 실제 저장소에서 읽기
    // return await secureStorage.read(key: 'access_token');
  }

  /// RefreshToken 조회
  static String? getRefreshToken() {
    return _refreshToken;
    // TODO: 실제 저장소에서 읽기
    // return await secureStorage.read(key: 'refresh_token');
  }

  /// 모든 토큰 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    _accessToken = null;
    _refreshToken = null;
    // TODO: 실제 저장소에서 삭제
    // await secureStorage.deleteAll();
  }

  /// 토큰 저장 (둘 다)
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }
}



