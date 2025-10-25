import 'package:get/get.dart';
import '../presentation/controllers/journal_controller.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    // 의존성 추가
    Get.lazyPut<JournalController>(() => JournalController());
    Get.lazyPut<SelfIntroController>(() => SelfIntroController());
  }
}