import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/presentation/bindings.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 앱 전역에서 사용할 AuthBinding 등록
    AuthBinding().dependencies();
  }
}
