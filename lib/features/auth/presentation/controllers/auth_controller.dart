// GetX 컨트롤러: UI 상태/흐름 제어.
// Repository를 주입 받아 세션 확인, 로그인 상태 보관 등 수행.

import 'package:get/get.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth.dto.dart';
import '../../../app/core/utils/token_storage.dart';
import '../../../app/core/models/response.dart';
import '../../../../app/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository repo;
  AuthController(this.repo);

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
      final result = await repo.login(credentials);
      
      // 토큰 저장
      await TokenStorage.saveTokens(
        accessToken: result.data.accessToken,
        refreshToken: result.data.refreshToken,
      );
      
      isLoggedIn.value = true;
      return true;
    } catch (e) {
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

  // 데모용(플레이스홀더) - 나중에 제거 가능
  void demoLogin() => isLoggedIn.value = true;
  void demoLogout() => logout();
}
