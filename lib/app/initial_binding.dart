import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/presentation/bindings.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 앱 전역 의존성 주입 (AuthBinding 등)
    // Splash/Login 등 초기 진입 시점부터 필요한 의존성을 등록합니다.
    AuthBinding().dependencies();
  }
}
