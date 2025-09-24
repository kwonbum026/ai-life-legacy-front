// Auth 관련 "원격 API 호출"만 담당하는 레이어.
// 장점: 네트워킹 코드를 한군데 모아 테스트/교체 용이.

import 'package:dio/dio.dart';
import '../../../app/core/network/dio_client.dart';
import '../../../app/core/network/api_endpoints.dart';

class AuthApi {
  // 전역으로 초기화된 Dio 사용(인터셉터/토큰 공통 적용)
  final Dio _dio = DioClient.instance;

  /// 세션 유효성 확인 호출.
  /// 반환: Future<bool> → 로그인 상태(true)/비로그인(false).
  /// 실제 연동 시, statusCode/응답 본문을 확인해 bool로 맵핑.
  Future<bool> checkSession() async {
    // 실제 연동 시:
    // final res = await _dio.get(ApiEndpoints.authSession);
    // return res.statusCode == 200 && res.data['loggedIn'] == true;

    // 현재는 더미 딜레이 후 항상 로그아웃 처리(false).
    await Future.delayed(const Duration(milliseconds: 200)); // 더미 딜레이
    return false; // ver1 시작: 항상 로그아웃 상태
  }
}
