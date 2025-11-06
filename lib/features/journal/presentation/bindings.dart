import 'package:get/get.dart';
import '../presentation/controllers/journal_controller.dart';
import '../../user/data/user_api.dart';
import '../../user/data/user_repository.dart';
import '../../post/data/post_api.dart';
import '../../post/data/post_repository.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    // API 및 Repository 등록
    Get.lazyPut(() => UserApi());
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserApi>()));
    
    Get.lazyPut(() => LifeLegacyApi());
    Get.lazyPut<PostRepository>(() => PostRepositoryImpl(Get.find<LifeLegacyApi>()));

    // 컨트롤러 등록
    Get.lazyPut<JournalController>(
      () => JournalController(Get.find<UserRepository>()),
    );
    Get.lazyPut<SelfIntroController>(
      () => SelfIntroController(
        Get.find<UserRepository>(),
        Get.find<PostRepository>(),
      ),
    );
  }
}