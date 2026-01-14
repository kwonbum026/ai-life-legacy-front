import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/onboarding/presentation/controllers/self_intro_controller.dart';
import 'package:ai_life_legacy/features/home/presentation/controllers/home_controller.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart'; // import added

class SelfIntroPage extends GetView<SelfIntroController> {
  const SelfIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 색상 변경 방지
        elevation: 0,
        title: const Text(
          '자기소개',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () => Get.toNamed(Routes.myPage),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 메인 컨텐츠 영역
          Expanded(
            child: Obx(() {
              return ListView(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 20),
                  // 질문 카드
                  Obx(() => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          controller.currentQuestionText,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      )),
                  const SizedBox(height: 24),
                  // 다시 들려줘 버튼 (그대로)
                  OutlinedButton(
                    onPressed: controller.replayCurrentQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5B9FED),
                      side:
                          const BorderSide(color: Color(0xFF5B9FED), width: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('다시 들려줘',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),

                  // 채팅 메시지(말풍선) 리스트 렌더링
                  ...controller.messages
                      .map((m) => _Bubble(text: m.text, isUser: m.isUser)),

                  const SizedBox(height: 80), // 하단 입력 영역과 겹치지 않게 여유
                ],
              );
            }),
          ),

          // 하단 입력 영역
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 텍스트 입력 필드
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      // + / X 버튼 (음성 녹음 토글)
                      Obx(() => IconButton(
                            icon: Icon(
                              controller.isVoiceRecorderVisible.value
                                  ? Icons.close
                                  : Icons.add,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                controller.toggleVoiceRecorderVisible(),
                          )),
                      SizedBox(width: 8),
                      // 입력 필드
                      Expanded(
                        child: Obx(() => TextField(
                              controller: controller.textController,
                              enabled: !controller.loading.value,
                              decoration: InputDecoration(
                                hintText: '답변을 입력하세요.',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              onSubmitted: (_) => controller.submitAnswer(),
                            )),
                      ),
                      SizedBox(width: 8),
                      // 전송 버튼
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF5B9FED),
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() {
                          final isProcessing = controller.loading.value;
                          return IconButton(
                            icon: isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.arrow_upward,
                                    color: Colors.white),
                            onPressed: isProcessing
                                ? null
                                : () => controller.submitAnswer(),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                // 음성인식 영역
                Obx(() {
                  if (!controller.isVoiceRecorderVisible.value) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          '음성인식',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 녹음 시간 표시
                            Obx(() => Text(
                                  controller.getFormattedTime(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                )),
                            SizedBox(width: 24),
                            // 녹음 버튼
                            Obx(() => GestureDetector(
                                  onTap: () => controller.toggleRecording(),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: controller.isRecording.value
                                          ? Color(0xFFFF5252)
                                          : Color(0xFFFF5252),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color(0xFFFF5252).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선 위젯
class _Bubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _Bubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bg = isUser ? const Color(0xFF5B9FED) : const Color(0xFFEDEDED);
    final fg = isUser ? Colors.white : Colors.black87;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final margin = isUser
        ? const EdgeInsets.only(left: 60, bottom: 10)
        : const EdgeInsets.only(right: 60, bottom: 10);

    return Align(
      alignment: align,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child:
            Text(text, style: TextStyle(color: fg, fontSize: 16, height: 1.4)),
      ),
    );
  }
}
