// 홈 화면(플레이스홀더).
// arguments로 받은 tab 값을 출력하고, 데모 로그아웃 버튼 제공.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomePage extends GetView<AuthController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 이전 라우트에서 전달한 인자. 형식 보장X → 타입 체크 후 안전하게 캐스팅.
    final initialTab = Get.arguments is Map ? (Get.arguments['tab'] as String?) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('홈 화면 (요청 탭: ${initialTab ?? '없음'})'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: controller.demoLogout,
              child: const Text('로그아웃(데모)'),
            ),
          ],
        ),
      ),
    );
  }
}
