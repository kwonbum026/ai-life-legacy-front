import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../app/core/routes/app_routes.dart';


// home_page controller
class JournalController extends GetxController {
  // reactive state
  final RxList<ChapterModel> chapters = <ChapterModel>[
    ChapterModel(id: 1, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.7),
    ChapterModel(id: 2, title: "가족환경과 성장환경", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.6),
    ChapterModel(id: 3, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.8),
    ChapterModel(id: 4, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.5),
    ChapterModel(id: 5, title: "청소년기와 학창시절", subtitle: "따뜻했던 우리 가족 이야기", progress: 0.6),
  ].obs;

  final RxInt selectedTabIndex = 0.obs;

  // 액션
  void onChapterTap(ChapterModel chapter) {
    print("챕터 ${chapter.id} 클릭됨: ${chapter.title}");
    // TODO: 상세 페이지 이동
  }

  // 하단 버튼 변경
  void changeTab(int index) {
    selectedTabIndex.value = index;
    switch (index) {
      case 0:
      // 홈: 현재 화면
        break;
      case 1:
        Get.toNamed(Routes.selfIntro);
        break;
      case 2:
      // 자서전 확인 탭 (나중에 다른 페이지로 연결 가능)
      // Get.toNamed(Routes.autobiography);
        break;
    }
  }

  void onBackPressed() => Get.back();
}

// 자기소개 작성
class SelfIntroController  extends GetxController {
  final textController = TextEditingController();
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? recordingTimer;

  @override
  void onClose() {
    textController.dispose();
    recordingTimer?.cancel();
    super.onClose();
  }

  void startRecording() {
    isRecording.value = true;
    recordingSeconds.value = 0;

    recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordingSeconds.value++;
    });
  }

  void stopRecording() {
    isRecording.value = false;
    recordingTimer?.cancel();
    recordingSeconds.value = 0;
  }

  void toggleRecording() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  String getFormattedTime() {
    int minutes = recordingSeconds.value ~/ 60;
    int seconds = recordingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void clearText() {
    textController.clear();
  }
}

// 임시 데이터 모델 (홈페이지 or 자서전 보기 페이지)
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
