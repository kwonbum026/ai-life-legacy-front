import 'package:get/get.dart';
import 'package:ai_life_legacy/features/home/presentation/controllers/home_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

import 'package:ai_life_legacy/features/autobiography/data/autobiography_api.dart'; // import added
import 'package:ai_life_legacy/features/autobiography/data/autobiography_repository.dart'; // import added

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // UserRepo: 사용자 정보 및 목차 조회 관련 의존성 주입
    Get.lazyPut(() => UserApi(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserApi>()),
        fenix: true);
    Get.lazyPut(() => HomeController(Get.find<UserRepository>()), fenix: true);

    // AutobiographyRepo: 자서전 관련 데이터 관리 의존성 주입
    Get.lazyPut(() => AutobiographyApi(), fenix: true);
    Get.lazyPut<AutobiographyRepository>(
        () => AutobiographyRepositoryImpl(Get.find<AutobiographyApi>()),
        fenix: true);
  }
}
