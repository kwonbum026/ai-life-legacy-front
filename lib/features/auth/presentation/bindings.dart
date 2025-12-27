// GetX DI 바인딩: 라우트 진입 시 의존성 묶음을 "한 번에" 등록.
// 장점: 페이지마다 필요한 데이터/컨트롤러 생성 위치가 명확해짐.

import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/data/auth_api.dart';
import 'package:ai_life_legacy/features/auth/data/auth_repository.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut: 실제로 필요해질 때 생성(지연 생성). fenix: true => 페이지 이동으로 삭제되어도 필요 시 재생성
    Get.lazyPut(() => AuthApi(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthApi>()),
        fenix: true);
    Get.lazyPut(() => UserApi(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserApi>()),
        fenix: true);
    Get.lazyPut(
        () => AuthController(
            Get.find<AuthRepository>(), Get.find<UserRepository>()),
        fenix: true);
  }
}
