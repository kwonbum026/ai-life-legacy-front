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

  // 채팅 목록 & 스크롤 컨트롤러
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ScrollController scrollController = ScrollController();

  // 메시지 추가(전송 시 호출)
  void addMessage(String text, {bool isUser = true}) {
    final t = text.trim();
    if (t.isEmpty) return;
    messages.add(ChatMessage(t, isUser: isUser));
    _scrollToBottom();
  }

  // 자동 스크롤 함수
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }


  @override
  void onClose() {
    // 뒤로가기 시 홈 탭으로 복귀
    final journalController = Get.find<JournalController>();
    journalController.selectedTabIndex.value = 0;

    textController.dispose();
    recordingTimer?.cancel();
    scrollController.dispose();
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

// 메시지 모델(단순): 필요하면 role 구분용
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, {this.isUser = true});
}