import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<String> messages = <String>[].obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // 초기 더미 메시지
    messages.add("안녕하세요! 저는 당신의 AI 아바타입니다.");
    messages.add("무엇을 도와드릴까요?");
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(text); // 사용자 메시지 (구분을 위해 별도 모델을 쓰기도 하지만 간단히 문자열로 처리하거나 "Me: " prefix 사용 가능)
    textController.clear();
    _scrollToBottom();

    // 더미 응답
    Future.delayed(const Duration(seconds: 1), () {
      messages.add("죄송합니다. 아직 학습 중이라 대답할 수 없어요.");
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
