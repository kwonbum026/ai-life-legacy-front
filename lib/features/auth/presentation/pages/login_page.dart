// 로그인 화면(플레이스홀더).
// 지금은 "더미 로그인" 버튼만 있고, 누르면 홈으로 이동.
// 실서비스에선 TextField/검증/SignInUseCase 호출/에러 처리 등을 구현.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../app/core/routes/app_routes.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});   // GetView<T>: T타입 컨트롤러를 손쉽게 사용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.demoLogin();       // 데모용: 상태만 ON
            Get.offAllNamed(Routes.home); // 현재 스택을 홈으로 교체
          },
          child: const Text('더미 로그인'),
        ),
      ),
    );
  }
}
