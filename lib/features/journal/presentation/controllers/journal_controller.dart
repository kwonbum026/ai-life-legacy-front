import 'package:get/get.dart';

class JournalController extends GetxController {
  // reactive state
  final RxList<ChapterModel> chapters = <ChapterModel>[
    ChapterModel(id: 1, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.7),
    ChapterModel(id: 2, title: "가족환경과 성장환경", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.6),
    ChapterModel(id: 3, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.8),
    ChapterModel(id: 4, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.5),
    ChapterModel(id: 5, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.6),
  ].obs;

  final RxInt selectedTabIndex = 2.obs;

  // 액션
  void onChapterTap(ChapterModel chapter) {
    print("챕터 ${chapter.id} 클릭됨: ${chapter.title}");
    // TODO: 상세 페이지 이동
  }

  void changeTab(int index) => selectedTabIndex.value = index;

  void onBackPressed() => Get.back();
}

class ChapterModel {
  final int id;
  final String title;
  final String subtitle;
  final double progress;

  ChapterModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
  });
}
