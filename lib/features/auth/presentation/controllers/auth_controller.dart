// GetX 컨트롤러: UI 상태/흐름 제어.
// Repository를 주입 받아 세션 확인, 로그인 상태 보관 등 수행.

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

  // RxBool: 반응형 상태. Obx로 구독하면 변경 시 UI 갱신.
  final RxBool isLoggedIn = false.obs;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshSession(); // 컨트롤러 초기화 시 세션 확인
  }

  /// 세션 상태 갱신. 반환값 없음.
  Future<void> _refreshSession() async {
    loading.value = true;
    try {
      // 토큰이 있으면 로그인 상태로 간주
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

      // 토큰 저장
      await TokenStorage.saveTokens(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
      );

      // 회원가입 직후에는 케이스가 없으므로 온보딩(자기소개)으로 이동
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

      // 유저 케이스 확인 후 분기 처리 (TOC가 생성되었는지 확인)
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

          // 404: Not Found (새 유저)
          // 500 & 'Cannot read properties of null': backend crash due to missing UserCase (새 유저 취급)
          if (status == 404 ||
              (status == 500 &&
                  msg.contains("Cannot read properties of null"))) {
            print('[Auth] TOC missing (404/500-NPE) -> Treating as new user');
            Get.offAllNamed(Routes.selfIntro);
          } else {
            // 그 외 에러는 일단 홈으로 보내거나 로그아웃?
            // 유저 요청: "널이면 자기소개 페이지로 넘어가야지?"
            // 안전하게 SelfIntro로 보낼지 고민되지만, 500 NPE가 명확하므로 일단 처리.
            // 다른 500 에러일 경우 홈으로? 아니면 그냥 SelfIntro?
            // 일단 홈으로 보냄 (기존 로직 유지)
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
