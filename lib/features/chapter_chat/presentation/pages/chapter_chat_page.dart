import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/chapter_chat/presentation/controllers/chapter_chat_controller.dart';

class ChapterChatPage extends GetView<ChapterChatController> {
  const ChapterChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: controller.backToHome,
        ),
        title: const Text(
          '자서전 작성',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 20),
                  // Current Question Display
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
                  
                  // Replay Button
                  OutlinedButton(
                    onPressed: controller.replayCurrentQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5B9FED),
                      side: const BorderSide(color: Color(0xFF5B9FED), width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('다시 들려줘',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),

                  // Chat Bubbles
                  ...controller.messages.map((m) => _Bubble(text: m.text, isUser: m.isUser)),

                  const SizedBox(height: 80),
                ],
              );
            }),
          ),

          // Input Area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Obx(() => IconButton(
                            icon: Icon(
                              controller.isVoiceRecorderVisible.value
                                  ? Icons.close
                                  : Icons.add,
                              color: Colors.grey,
                            ),
                            onPressed: controller.toggleVoiceRecorderVisible,
                          )),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() => TextField(
                              controller: controller.textController,
                              enabled: !controller.loading.value,
                              decoration: InputDecoration(
                                hintText: '답변을 입력하세요.',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              onSubmitted: (_) => controller.submitAnswer(),
                            )),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.arrow_upward, color: Colors.white),
                            onPressed: isProcessing ? null : controller.submitAnswer,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                
                // Voice Recorder
                Obx(() {
                  if (!controller.isVoiceRecorderVisible.value) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          '음성인식',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  controller.getFormattedTime(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                )),
                            const SizedBox(width: 24),
                            Obx(() => GestureDetector(
                                  onTap: controller.toggleRecording,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF5252),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF5252).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.mic, color: Colors.white, size: 32),
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
        child: Text(text, style: TextStyle(color: fg, fontSize: 16, height: 1.4)),
      ),
    );
  }
}
