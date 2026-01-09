import 'package:get/get.dart';
import 'package:ai_life_legacy/features/profile/presentation/controllers/my_page_controller.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyPageController(Get.find<UserRepository>()));
  }
}
