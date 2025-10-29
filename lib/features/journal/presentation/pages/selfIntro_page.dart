import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../journal/presentation/controllers/journal_controller.dart';

class SelfIntroPage extends GetView<SelfIntroController>  {
  const SelfIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF5B9FED),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '탄생과 유아기 시절',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '언제 어디서 태어났나요? 부모님이나 가족들이\n당신의 유아기에 대해 어떤 이야기를 해주셨나요?',
                      style: TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 다시 들려줘 버튼 (그대로)
                  OutlinedButton(
                    onPressed: () { /* TODO: 다시 듣기 */ },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5B9FED),
                      side: const BorderSide(color: Color(0xFF5B9FED), width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('다시 들려줘', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),

                  // 🔹 채팅 말풍선 렌더
                  ...controller.messages.map((m) => _Bubble(text: m.text, isUser: m.isUser)).toList(),

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
                      // X 버튼
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () => controller.clearText(),
                      ),
                      SizedBox(width: 8),
                      // 입력 필드
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          decoration: InputDecoration(
                            hintText: '답변을 입력하세요.',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: TextStyle(fontSize: 16),
                          maxLines: 1,
                          onSubmitted: (v) {
                            controller.addMessage(v);
                            controller.clearText();
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      // 전송 버튼
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF5B9FED),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_upward, color: Colors.white),
                          onPressed: () {
                            final text = controller.textController.text;
                            if (text.trim().isEmpty) return;
                            print('전송: $text');
                            controller.addMessage(text);
                            controller.addMessage('좋아요, 계속 이야기해 주세요!', isUser: false);  // 시스템
                            controller.clearText();
                          },

                        ),
                      ),
                    ],
                  ),
                ),
                // 음성인식 영역
                Container(
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
                                    color: Color(0xFFFF5252).withOpacity(0.3),
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
                ),
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
    final margin = isUser ? const EdgeInsets.only(left: 60, bottom: 10)
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
