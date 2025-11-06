import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../app/core/routes/app_routes.dart';
import '../../../user/data/user_repository.dart';
import '../../../user/data/models/user.dto.dart';
import '../../../post/data/post_repository.dart';
import '../../../app/core/utils/token_storage.dart';
import '../../../app/core/utils/jwt_utils.dart';


// home_page controller
class JournalController extends GetxController {
  final UserRepository userRepo;
  JournalController(this.userRepo);

  // reactive state
  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserContents();
  }

  /// 사용자 목차 불러오기
  Future<void> loadUserContents() async {
    loading.value = true;
    errorMessage.value = '';
    try {
      // 토큰 확인
      final accessToken = TokenStorage.getAccessToken();
      if (accessToken == null) {
        errorMessage.value = '로그인이 필요합니다';
        return;
      }

      // API 호출 (/users/me/toc)
      final result = await userRepo.getUserToc();
      chapters.value = result.data.map((toc) => ChapterModel(
        id: toc.id,
        title: toc.title,
        subtitle: '진행률 계산 필요', // TODO: 실제 진행률 계산
        progress: 0.0, // TODO: 질문 완료 수 기반으로 계산
      )).toList();
    } catch (e) {
      errorMessage.value = e.toString();
      // 에러 발생 시 빈 배열로 설정
      chapters.value = [];
    } finally {
      loading.value = false;
    }
  }

  // 액션
  void onChapterTap(ChapterModel chapter) {
    print("챕터 ${chapter.id} 클릭됨: ${chapter.title}");
    // SelfIntroPage로 이동하면서 tocId 전달
    Get.toNamed(Routes.selfIntro, arguments: {'tocId': chapter.id});
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
class SelfIntroController extends GetxController {
  final UserRepository userRepo;
  final PostRepository postRepo;
  
  SelfIntroController(this.userRepo, this.postRepo);

  final textController = TextEditingController();
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? recordingTimer;

  // 채팅 목록 & 스크롤 컨트롤러
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ScrollController scrollController = ScrollController();

  // 현재 목차와 질문 정보
  int? currentTocId;
  List<TocQuestionDto> questions = [];
  int currentQuestionIndex = 0;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // arguments에서 tocId 가져오기
    final arguments = Get.arguments;
    if (arguments != null && arguments['tocId'] != null) {
      currentTocId = arguments['tocId'] as int;
      loadQuestions();
    }
  }

  /// 질문 목록 불러오기
  Future<void> loadQuestions() async {
    if (currentTocId == null) return;

    loading.value = true;
    errorMessage.value = '';
    try {
      final result = await postRepo.getTocQuestions(currentTocId!);
      questions = result.data;
      
      // 첫 번째 질문을 화면에 표시
      if (questions.isNotEmpty) {
        addMessage(questions[0].question, isUser: false);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  /// 답변 저장
  Future<void> saveAnswer(String answer) async {
    if (currentTocId == null || questions.isEmpty) return;

    loading.value = true;
    try {
      final currentQuestion = questions[currentQuestionIndex];
      final saveDto = AnswerSaveDto(answerText: answer);

      await postRepo.saveAnswer(currentQuestion.id, saveDto);
      
      // 다음 질문이 있으면 표시
      currentQuestionIndex++;
      if (currentQuestionIndex < questions.length) {
        addMessage(questions[currentQuestionIndex].question, isUser: false);
      } else {
        addMessage('모든 질문에 답변하셨습니다!', isUser: false);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

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