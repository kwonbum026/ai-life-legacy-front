import 'package:get/get.dart';
import 'package:ai_life_legacy/features/ai/data/ai_api.dart';
import 'package:ai_life_legacy/features/ai/data/ai_repository.dart';
import 'package:ai_life_legacy/features/journal/presentation/controllers/journal_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_api.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/features/post/data/post_api.dart';
import 'package:ai_life_legacy/features/post/data/post_repository.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    // API 및 Repository 등록
    Get.lazyPut(() => UserApi(), fenix: true);
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<UserApi>()),
      fenix: true,
    );

    Get.lazyPut(() => LifeLegacyApi(), fenix: true);
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(Get.find<LifeLegacyApi>()),
      fenix: true,
    );

    Get.lazyPut(() => AiApi(), fenix: true);
    Get.lazyPut<AiRepository>(
      () => AiRepositoryImpl(Get.find<AiApi>()),
      fenix: true,
    );

    // 컨트롤러 등록
    Get.lazyPut<JournalController>(
      () => JournalController(Get.find<UserRepository>()),
    );
    Get.lazyPut<SelfIntroController>(
      () => SelfIntroController(
        Get.find<UserRepository>(),
        Get.find<PostRepository>(),
        Get.find<AiRepository>(),
      ),
    );
  }
}