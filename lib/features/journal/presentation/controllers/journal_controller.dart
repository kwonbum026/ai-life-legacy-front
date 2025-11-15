import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';
import 'package:ai_life_legacy/app/core/utils/token_storage.dart';
import 'package:ai_life_legacy/features/ai/data/ai_repository.dart';
import 'package:ai_life_legacy/features/ai/data/models/ai.dto.dart';
import 'package:ai_life_legacy/features/post/data/post_repository.dart';
import 'package:ai_life_legacy/features/user/data/models/user.dto.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';

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

      final tocResult = await userRepo.getUserToc();
      final initialChapters = tocResult.data
          .map(
            (toc) => ChapterModel(
              id: toc.id,
              title: toc.title,
              subtitle: '질문/진행률 계산 중...',
              progress: 0.0,
            ),
          )
          .toList();

      chapters.assignAll(initialChapters);
      unawaited(_hydrateChapterProgress());
    } catch (e) {
      if (e is DioException) {
        final status = e.response?.statusCode;
        final data = e.response?.data;
        Get.log('GET /users/me/toc 실패 → status:$status body:$data');
        final serverMessage = _extractServerMessage(data);
        errorMessage.value = status != null
            ? '[$status] ${serverMessage ?? e.message ?? '요청에 실패했습니다.'}'
            : (serverMessage ?? e.message ?? '요청에 실패했습니다.');
      } else {
        errorMessage.value = e.toString();
      }
      chapters.value = [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> _hydrateChapterProgress() async {
    try {
      final tocQuestions = await userRepo.getUserTocQuestions();
      final progressMap = await _calculateProgress(tocQuestions.data);
      if (progressMap.isEmpty) return;

      final updated = chapters
          .map(
            (chapter) {
              final info = progressMap[chapter.id];
              if (info == null) return chapter;

              final subtitle = info.totalQuestions == 0
                  ? '질문이 아직 준비되지 않았어요'
                  : '답변 ${info.answeredQuestions}/${info.totalQuestions}개 완료';

              return ChapterModel(
                id: chapter.id,
                title: chapter.title,
                subtitle: subtitle,
                progress: info.progress,
                answeredQuestions: info.answeredQuestions,
                totalQuestions: info.totalQuestions,
              );
            },
          )
          .toList();

      chapters.assignAll(updated);
    } catch (e) {
      Get.log('홈 진행률 계산 실패: $e');
    }
  }

  String? _extractServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      if (data['message'] is List && data['message'].isNotEmpty) {
        return data['message'].first.toString();
      }
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return data.toString();
  }

  Future<Map<int, ChapterProgressInfo>> _calculateProgress(
    List<UserTocQuestionDto> sections,
  ) async {
    final Map<int, ChapterProgressInfo> progressMap = {};

    for (final section in sections) {
      final total = section.questions.length;

      if (total == 0) {
        progressMap[section.tocId] = ChapterProgressInfo.zero();
        continue;
      }

      var answered = 0;
      await Future.wait(section.questions.map((question) async {
        try {
          final answer = await userRepo.getUserAnswer(question.id);
          if (answer.data.answerText.trim().isNotEmpty) {
            answered++;
          }
        } on DioException catch (dioError) {
          if (dioError.response?.statusCode == 404) {
            return;
          }
          rethrow;
        }
      }));

      progressMap[section.tocId] = ChapterProgressInfo(
        totalQuestions: total,
        answeredQuestions: answered,
      );
    }

    return progressMap;
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
        Get.toNamed(Routes.autobiography);
        break;
    }
  }

  void onBackPressed() => Get.back();
}

// 자기소개 작성
enum AnswerPhase { primary, followUp }

class SelfIntroController extends GetxController {
  final UserRepository userRepo;
  final PostRepository postRepo;
  final AiRepository aiRepo;

  SelfIntroController(this.userRepo, this.postRepo, this.aiRepo);

  final textController = TextEditingController();
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? recordingTimer;

  // 채팅 목록 & 스크롤 컨트롤러
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final ScrollController scrollController = ScrollController();

  // 현재 목차와 질문 정보
  int? currentTocId;
  final RxList<TocQuestionDto> questions = <TocQuestionDto>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final Rx<AnswerPhase> answerPhase = AnswerPhase.primary.obs;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;
  String? _pendingPrimaryAnswer;
  String? _pendingFollowUpQuestion;

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
      questions.assignAll(result.data);
      messages.clear();
      _resetPendingState();
      answerPhase.value = AnswerPhase.primary;
      currentQuestionIndex.value = 0;

      if (questions.isNotEmpty) {
        addMessage(questions.first.question, isUser: false);
      } else {
        addMessage('질문을 불러올 수 없습니다.', isUser: false);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  /// 사용자 입력 전송
  Future<void> submitAnswer() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    addMessage(text);
    clearText();
    await _handleUserAnswer(text);
  }

  Future<void> _handleUserAnswer(String answer) async {
    if (currentTocId == null || questions.isEmpty) return;
    if (currentQuestionIndex.value >= questions.length) {
      addMessage('모든 질문에 답변하셨습니다!', isUser: false);
      return;
    }

    loading.value = true;
    errorMessage.value = '';
    final currentQuestion = questions[currentQuestionIndex.value];

    try {
      if (answerPhase.value == AnswerPhase.primary) {
        await _handlePrimaryAnswer(currentQuestion, answer);
      } else {
        await _handleFollowUpAnswer(currentQuestion, answer);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> _handlePrimaryAnswer(
    TocQuestionDto question,
    String answer,
  ) async {
    _pendingPrimaryAnswer = answer;
    try {
      final aiResponse = await aiRepo.makeReQuestion(
        MakeReQuestionDto(
          question: question.question,
          data: answer,
        ),
      );
      final followUp = aiResponse.data.content.trim();
      if (followUp.isEmpty) {
        await _persistAnswer(question, answer);
        _resetPendingState();
        _moveToNextQuestion();
        return;
      }
      _pendingFollowUpQuestion = followUp;
      answerPhase.value = AnswerPhase.followUp;
      addMessage(followUp, isUser: false);
    } catch (e) {
      errorMessage.value = e.toString();
      await _persistAnswer(question, answer);
      _resetPendingState();
      _moveToNextQuestion();
    }
  }

  Future<void> _handleFollowUpAnswer(
    TocQuestionDto question,
    String answer,
  ) async {
    final primary = _pendingPrimaryAnswer;
    final followUpQuestion = _pendingFollowUpQuestion;

    if (primary == null || followUpQuestion == null) {
      await _persistAnswer(question, answer);
      _resetPendingState();
      answerPhase.value = AnswerPhase.primary;
      _moveToNextQuestion();
      return;
    }

    String finalAnswer = answer;
    try {
      final combineRes = await aiRepo.combine(
        CombineDto(
          question1: question.question,
          data1: primary,
          question2: followUpQuestion,
          data2: answer,
        ),
      );
      final combined = combineRes.data.content.trim();
      if (combined.isNotEmpty) {
        finalAnswer = combined;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }

    await _persistAnswer(question, finalAnswer);
    addMessage(finalAnswer, isUser: false);
    _resetPendingState();
    answerPhase.value = AnswerPhase.primary;
    _moveToNextQuestion();
  }

  Future<void> _persistAnswer(
    TocQuestionDto question,
    String answer,
  ) async {
    final saveDto = AnswerSaveDto(answerText: answer);
    await postRepo.saveAnswer(question.id, saveDto);
  }

  void _moveToNextQuestion() {
    if (questions.isEmpty) return;

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      addMessage(questions[currentQuestionIndex.value].question, isUser: false);
    } else {
      currentQuestionIndex.value = questions.length;
      addMessage('모든 질문에 답변하셨습니다!', isUser: false);
    }
  }

  void _resetPendingState() {
    _pendingPrimaryAnswer = null;
    _pendingFollowUpQuestion = null;
  }

  String get currentQuestionText {
    if (questions.isEmpty) {
      return errorMessage.value.isEmpty
          ? '질문을 불러오는 중입니다...'
          : '질문을 불러올 수 없습니다.';
    }
    if (currentQuestionIndex.value >= questions.length) {
      return '모든 질문에 답변하셨습니다!';
    }
    return questions[currentQuestionIndex.value].question;
  }

  void replayCurrentQuestion() {
    final text = currentQuestionText.trim();
    if (text.isEmpty) return;
    addMessage(text, isUser: false);
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
  final int answeredQuestions;
  final int totalQuestions;

  ChapterModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.answeredQuestions = 0,
    this.totalQuestions = 0,
  });
}

class ChapterProgressInfo {
  final int totalQuestions;
  final int answeredQuestions;

  const ChapterProgressInfo({
    required this.totalQuestions,
    required this.answeredQuestions,
  });

  double get progress =>
      totalQuestions == 0 ? 0.0 : answeredQuestions / totalQuestions;

  factory ChapterProgressInfo.zero() =>
      const ChapterProgressInfo(totalQuestions: 0, answeredQuestions: 0);
}

// 메시지 모델(단순): 필요하면 role 구분용
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, {this.isUser = true});
}
