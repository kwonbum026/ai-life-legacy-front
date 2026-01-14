import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/app/core/utils/toast_utils.dart';

/// Home Feature의 비즈니스 로직을 제어합니다.
/// 사용자 목차(TOC) 로드, 탭 네비게이션, 챕터 클릭 이벤트 등을 처리합니다.
class HomeController extends GetxController {
  final UserRepository userRepo;
  HomeController(this.userRepo);

  // Reactive State: UI 업데이트를 위한 상태 변수
  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserContents();
  }

  /// 사용자 목차(TOC) 목록을 서버로부터 불러옵니다.
  Future<void> loadUserContents() async {
    loading.value = true;
    errorMessage.value = '';
    try {
      final tocResult = await userRepo.getUserToc();
      final initialChapters = tocResult.data
          .map(
            (toc) => ChapterModel(
              id: toc.id,
              title: toc.title,
              subtitle: '진행률 ${(toc.percent).toStringAsFixed(1)}%',
              progress: toc.percent / 100.0,
            ),
          )
          .toList();

      final ids = <int>{};
      final uniqueChapters = <ChapterModel>[];
      for (var chapter in initialChapters) {
        if (ids.add(chapter.id)) {
          uniqueChapters.add(chapter);
        }
      }
      chapters.assignAll(uniqueChapters);
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

  // _calculateProgress 관련 로직은 loadUserContents 내부에 통합됨

  /// 챕터 카드 클릭 시 이벤트 핸들러
  void onChapterTap(ChapterModel chapter) {
    print("챕터 ${chapter.id} 클릭됨: ${chapter.title}");
    // 클릭한 챕터 ID를 전달하며 자기소개(Onboarding) 탭으로 이동
    // TODO: 탭 전환 시 arguments 전달 방식 개선 필요 (현재는 탭 전환만 수행)
    selectedTabIndex.value = 1; 
  }

  /// 하단 탭 바 선택 변경 핸들러
  void changeTab(int index) {
    if (index == 0) {
      loadUserContents();
    }
    selectedTabIndex.value = index;
  }

  void onBackPressed() => Get.back();
}

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
