// 전역 Dio 인스턴스를 초기화하고 제공.
// 장점: 공통 헤더/타임아웃/인터셉터를 한 곳에서 설정.

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/config/env.dart';
import 'package:ai_life_legacy/app/core/utils/token_storage.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';

class DioClient {
  // 실제 HTTP 요청을 담당하는 객체.
  static late Dio _dio;

  /// 외부에서 읽기 전용으로 접근할 getter.
  /// 반환 타입: Dio (싱글턴처럼 재사용)
  static Dio get instance => _dio;

  /// 전역 Dio 초기화. 반환값 없음.
  /// BaseOptions를 통해 baseUrl, timeout, headers 등을 설정.
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBase,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 인터셉터 추가: 토큰 자동 주입 및 갱신
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 인증이 필요한 API에 토큰 자동 추가
          final accessToken = TokenStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // 401 에러 시 토큰 갱신 시도
          if (error.response?.statusCode == 401) {
            try {
              await _refreshTokenAndRetry(error.requestOptions, handler);
            } catch (e) {
              // 토큰 갱신 실패 시 로그아웃 처리
              await TokenStorage.clearAll();
              return handler.reject(error);
            }
          } else {
            return handler.next(error);
          }
        },
      ),
    );
  }

  /// 토큰 갱신 후 요청 재시도
  static Future<void> _refreshTokenAndRetry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final refreshToken = TokenStorage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('Refresh token not found');
    }

    try {
      // 토큰 갱신 API 호출 (순환 참조 방지를 위해 직접 호출)
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final result = response.data as Map<String, dynamic>;
      final tokenData = result['data'] as Map<String, dynamic>;
      
      final newAccessToken = tokenData['accessToken'] as String;
      final newRefreshToken = tokenData['refreshToken'] as String;

      // 새 토큰 저장
      await TokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // 원래 요청 재시도
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(requestOptions);
      return handler.resolve(retryResponse);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: e,
        ),
      );
    }
  }
}
