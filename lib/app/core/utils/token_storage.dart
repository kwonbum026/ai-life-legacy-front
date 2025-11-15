import 'package:shared_preferences/shared_preferences.dart';

/// 토큰 저장/조회 유틸리티
class TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static SharedPreferences? _prefs;
  static String? _accessToken;
  static String? _refreshToken;

  /// SharedPreferences 초기화 및 캐시 로딩
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(_accessKey);
    _refreshToken = _prefs!.getString(_refreshKey);
  }

  static Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// AccessToken 저장
  static Future<void> saveAccessToken(String token) async {
    _accessToken = token;
    final prefs = await _ensurePrefs();
    await prefs.setString(_accessKey, token);
  }

  /// RefreshToken 저장
  static Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
    final prefs = await _ensurePrefs();
    await prefs.setString(_refreshKey, token);
  }

  /// AccessToken 조회
  static String? getAccessToken() {
    if (_accessToken != null) return _accessToken;
    return _prefs?.getString(_accessKey);
  }

  /// RefreshToken 조회
  static String? getRefreshToken() {
    if (_refreshToken != null) return _refreshToken;
    return _prefs?.getString(_refreshKey);
  }

  /// 모든 토큰 삭제 (로그아웃 시)
  static Future<void> clearAll() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await _ensurePrefs();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }

  /// 토큰 저장 (둘 다)
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }
}