import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 토큰 저장/조회 유틸리티
class TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _uuidKey = 'uuid';

  static SharedPreferences? _prefs;
  static String? _accessToken;
  static String? _refreshToken;
  static String? _uuid;

  /// SharedPreferences 초기화 및 캐시 로딩
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(_accessKey);
    _refreshToken = _prefs!.getString(_refreshKey);
    _uuid = _prefs!.getString(_uuidKey);
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

  /// UUID 조회
  static String? getUuid() {
    if (_uuid != null) return _uuid;
    return _prefs?.getString(_uuidKey);
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
    _uuid = null;
    final prefs = await _ensurePrefs();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_uuidKey);
  }

  /// 토큰 저장 (둘 다)
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // JWT 디코딩 후 UUID 추출
    try {
      final parts = accessToken.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final resp = utf8.decode(base64Url.decode(normalized));
        final payloadMap = jsonDecode(resp);
        print('Decoded Token Payload: $payloadMap'); // Debug log

        if (payloadMap is Map<String, dynamic>) {
          // 'uuid' 필드 확인, 없으면 'sub' 등 대체 시도
          final uuid =
              payloadMap['uuid'] ?? payloadMap['sub'] ?? payloadMap['id'];
          print('Extracted UUID: $uuid'); // Debug log

          if (uuid != null) {
            _uuid = uuid.toString();
            final prefs = await _ensurePrefs();
            await prefs.setString(_uuidKey, _uuid!);
          }
        }
      }
    } catch (e) {
      // 디코딩 실패 시 무시 (로그 로그)
      print('Token decoding failed: $e');
    }

    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }
}
