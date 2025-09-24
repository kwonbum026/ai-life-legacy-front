// "시작 화면" 본체.
// 버튼 2개(자서전 작성/보기) + 로그인 여부에 따라 라우팅 분기.
// 간단한 페이드 인 애니메이션 포함.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../app/core/routes/app_routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  /// "자서전 작성" 버튼 콜백.
  /// - AuthController의 isLoggedIn 값을 읽어 /home 또는 /login으로 이동.
  void _goWrite(AuthController auth) {
    final loggedIn = auth.isLoggedIn.value;
    Get.toNamed(loggedIn ? Routes.home : Routes.login, arguments: {'tab': 'write'});
  }

  /// "자서전 보기" 버튼 콜백. 위와 동일한 분기.
  void _goView(AuthController auth) {
    final loggedIn = auth.isLoggedIn.value;
    Get.toNamed(loggedIn ? Routes.home : Routes.login, arguments: {'tab': 'view'});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                Text('AI Life Legacy',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800, letterSpacing: -0.3,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text('당신의 삶을 기록하고 책으로 남기세요',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _goWrite(auth),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('자서전 작성'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _goView(auth),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('자서전 보기'),
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                  auth.loading.value
                      ? '세션 확인 중...'
                      : (auth.isLoggedIn.value ? '로그인 상태: ON' : '로그인 상태: OFF'),
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.black45),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
