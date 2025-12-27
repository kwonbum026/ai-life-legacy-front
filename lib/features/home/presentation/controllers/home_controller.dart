// import 'package:flutter/material.dart'; // Unused
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';
import 'package:ai_life_legacy/features/user/data/user_repository.dart';
import 'package:ai_life_legacy/app/core/utils/toast_utils.dart';

// Home Controller
class HomeController extends GetxController {
  final UserRepository userRepo;
  HomeController(this.userRepo);

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

  // _calculateProgress removed as logic integrated above

  // 액션
  void onChapterTap(ChapterModel chapter) {
    print("챕터 ${chapter.id} 클릭됨: ${chapter.title}");
    // SelfIntroPage로 이동하면서 tocId 전달
    Get.toNamed(Routes.selfIntro, arguments: {'tocId': chapter.id})
        ?.then((_) => loadUserContents());
  }

  // 하단 버튼 변경
  void changeTab(int index) {
    // 탭 변경 UI 반영하지 않음 (이 페이지는 Home이고, 탭은 단순 버튼 역할)
    // selectedTabIndex.value = index;

    switch (index) {
      case 0:
        // 홈: 현재 화면 (새로고침?)
        loadUserContents();
        break;
      case 1:
        // 자기소개 작성
        if (chapters.isNotEmpty) {
          ToastUtils.showInfoToast('이미 자기소개를 완료하셨습니다.');
        } else {
          Get.toNamed(Routes.selfIntro);
        }
        break;
      case 2:
        // 자서전 확인 탭
        if (chapters.isEmpty) {
          ToastUtils.showInfoToast('먼저 자기소개를 작성해주세요.');
        } else {
          Get.toNamed(Routes.autobiography);
        }
        break;
    }
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
