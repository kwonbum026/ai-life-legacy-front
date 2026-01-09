/// GetX DI 바인딩: 라우트 진입 시 의존성을 등록합니다.
/// 페이지별로 필요한 의존성(Controller, UseCase, Repository 등)을 명확하게 정의합니다.

import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/data/auth_api.dart';
import 'package:ai_life_legacy/features/auth/data/auth_repository.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut: 필요 시점에 인스턴스 생성 (지연 로딩). fenix: true 설정으로 페이지 재진입 시 재생성 보장.
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
