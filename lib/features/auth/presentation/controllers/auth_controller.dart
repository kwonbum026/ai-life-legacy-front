/// Auth 기능 관련 UI 상태 및 비즈니스 로직 제어 Controller
/// 세션 확인, 로그인, 회원가입, 로그아웃 등의 기능을 수행합니다.

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/data/auth_repository.dart';
import 'package:ai_life_legacy/features/auth/data/models/auth.dto.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/app/core/utils/token_storage.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository repo;
  final UserRepository userRepo;
  AuthController(this.repo, this.userRepo);

  // RxBool: 반응형 상태 변수
  final RxBool isLoggedIn = false.obs;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshSession(); // 초기화 시 세션 유효성 확인
  }

  /// 세션 상태 갱신. 반환값 없음.
  Future<void> _refreshSession() async {
    loading.value = true;
    try {
      // Access Token 존재 및 세션 유효성 확인 성공 시 로그인 상태 true
      final token = TokenStorage.getAccessToken();
      isLoggedIn.value = token != null && await repo.checkSession();
    } catch (e) {
      isLoggedIn.value = false;
    } finally {
      loading.value = false;
    }
  }

  /// 회원가입
  Future<bool> signUp(String email, String password) async {
    loading.value = true;
    errorMessage.value = '';
    try {
      final credentials = AuthCredentialsDto(email: email, password: password);
      final result = await repo.signUp(credentials);

      // 발급받은 토큰 저장
      await TokenStorage.saveTokens(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
      );

      // 회원가입 완료 후 온보딩(자기소개) 페이지로 이동
      Get.offAllNamed(Routes.selfIntro);
      isLoggedIn.value = true;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      loading.value = false;
    }
  }

  /// 로그인
  Future<bool> login(String email, String password) async {
    loading.value = true;
    errorMessage.value = '';
    try {
      final credentials = AuthCredentialsDto(email: email, password: password);
      print('[Auth] Requesting Login...');
      final result = await repo.login(credentials);
      print('[Auth] Login Success. Tokens received.');

      // 토큰 저장
      await TokenStorage.saveTokens(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
      );

      // 유저 케이스(TOC) 존재 여부 확인 후 네비게이션 분기 처리
      print('[Auth] Checking User TOC...');
      try {
        final tocRes = await userRepo.getUserToc();
        print('[Auth] TOC retrieved: ${tocRes.data}');

        if (tocRes.data.isEmpty) {
          print('[Auth] User has no TOC. Redirecting to SelfIntro.');
          Get.offAllNamed(Routes.selfIntro);
        } else {
          Get.offAllNamed(Routes.home);
        }
      } catch (e) {
        // 404 등 에러 시 신규 유저로 간주
        print('[Auth] Failed to get TOC: $e');
        if (e is DioException) {
          final status = e.response?.statusCode;
          final msg = e.response?.data.toString() ?? '';

          // 404: Not Found (신규 유저)
          // 500 & 'Cannot read properties of null': 백엔드 이슈 대응(신규 유저로 처리)
          if (status == 404 ||
              (status == 500 &&
                  msg.contains("Cannot read properties of null"))) {
            print('[Auth] TOC missing (404/500-NPE) -> Treating as new user');
            Get.offAllNamed(Routes.selfIntro);
          } else {
            // 그 외 에러 발생 시 홈 화면으로 이동 (기존 로직 유지)
            Get.offAllNamed(Routes.home);
          }
        } else {
          Get.offAllNamed(Routes.home);
        }
      }

      isLoggedIn.value = true;
      return true;
    } catch (e) {
      print('[Auth] Login Flow Failed: $e');
      errorMessage.value = e.toString();
      return false;
    } finally {
      loading.value = false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    await TokenStorage.clearAll();
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.main);
  }
}
