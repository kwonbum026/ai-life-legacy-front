// 전역 Dio 인스턴스를 초기화하고 제공.
// 장점: 공통 헤더/타임아웃/인터셉터를 한 곳에서 설정.

import 'package:dio/dio.dart';
import '../config/env.dart';

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
    // TODO: 인터셉터(토큰 주입/로깅/에러핸들링) 추가 지점
  }
}
