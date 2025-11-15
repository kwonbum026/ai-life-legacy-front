// GetX DI 바인딩: 라우트 진입 시 의존성 묶음을 "한 번에" 등록.
// 장점: 페이지마다 필요한 데이터/컨트롤러 생성 위치가 명확해짐.

import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/data/auth_api.dart';
import 'package:ai_life_legacy/features/auth/data/auth_repository.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut: 실제로 필요해질 때 생성(지연 생성). 메모리 효율↑
    Get.lazyPut(() => AuthApi());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthApi>()));
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
  }
}
