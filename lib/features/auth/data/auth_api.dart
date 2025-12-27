// Auth 관련 "원격 API 호출"만 담당하는 레이어.
// 장점: 네트워킹 코드를 한군데 모아 테스트/교체 용이.

import 'package:dio/dio.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/network/api_endpoints.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';
import 'package:ai_life_legacy/features/auth/data/models/auth.dto.dart';

class AuthApi {
  // 전역으로 초기화된 Dio 사용(인터셉터/토큰 공통 적용)
  final Dio _dio = DioClient.instance;

  /// 회원가입
  Future<Success201Response<JwtTokenResponseDto>> signUp(
    AuthCredentialsDto credentials,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.signUp,
      data: credentials.toJson(),
    );

    return Success201Response<JwtTokenResponseDto>.fromJson(
      response.data,
      (json) => JwtTokenResponseDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 로그인
  Future<SuccessResponse<JwtTokenResponseDto>> login(
    AuthCredentialsDto credentials,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: credentials.toJson(),
      );

      return SuccessResponse<JwtTokenResponseDto>.fromJson(
        response.data,
        (json) => JwtTokenResponseDto.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        print('Login Error Status: ${e.response?.statusCode}');
        print('Login Error Data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  /// 토큰 갱신
  Future<SuccessResponse<JwtTokenResponseDto>> refreshToken(
    RefreshTokenDto refreshTokenDto,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.refreshToken,
      data: refreshTokenDto.toJson(),
    );

    return SuccessResponse<JwtTokenResponseDto>.fromJson(
      response.data,
      (json) => JwtTokenResponseDto.fromJson(json as Map<String, dynamic>),
    );
  }

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
