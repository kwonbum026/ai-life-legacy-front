// GetX 컨트롤러: UI 상태/흐름 제어.
// Repository를 주입 받아 세션 확인, 로그인 상태 보관 등 수행.

import 'package:get/get.dart';
import '../../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repo;
  AuthController(this.repo);

  // RxBool: 반응형 상태. Obx로 구독하면 변경 시 UI 갱신.
  final RxBool isLoggedIn = false.obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshSession(); // 컨트롤러 초기화 시 세션 확인
  }

  /// 세션 상태 갱신. 반환값 없음.
  Future<void> _refreshSession() async {
    loading.value = true;
    try {
      isLoggedIn.value = await repo.checkSession();
    } finally {
      loading.value = false;
    }
  }

  // 데모용(플레이스홀더)
  void demoLogin() => isLoggedIn.value = true;
  void demoLogout() => isLoggedIn.value = false;
}
