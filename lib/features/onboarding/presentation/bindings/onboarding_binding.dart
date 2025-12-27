import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/autobiography/data/autobiography_api.dart';
import 'package:ai_life_legacy/app/core/ai/ai_api.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/onboarding/presentation/controllers/self_intro_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/features/autobiography/data/autobiography_repository.dart';
import 'package:ai_life_legacy/app/core/ai/ai_repository.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut(() => UserApi(), fenix: true);
    Get.lazyPut(() => AutobiographyApi(), fenix: true);
    Get.lazyPut(() => AiApi(), fenix: true);

    // Repositories
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserApi>()),
        fenix: true);
    Get.lazyPut<AutobiographyRepository>(
        () => AutobiographyRepositoryImpl(Get.find<AutobiographyApi>()),
        fenix: true);
    Get.lazyPut<AiRepository>(() => AiRepositoryImpl(Get.find<AiApi>()),
        fenix: true);

    // Controller
    Get.lazyPut<SelfIntroController>(
      () => SelfIntroController(
        Get.find<UserRepository>(),
        Get.find<AutobiographyRepository>(),
        Get.find<AiRepository>(),
      ),
    );
  }
}
