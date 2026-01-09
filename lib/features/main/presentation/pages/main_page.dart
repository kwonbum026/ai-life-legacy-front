/// 앱의 시작(진입) 화면
/// 로그인 상태에 따라 '자서전 작성' 또는 '자서전 보기' 버튼의 동작이 분기됩니다.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';

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
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  /// '자서전 작성' 버튼 클릭 핸들러
  /// 로그인 상태를 확인하여 Home 또는 Login 페이지로 이동합니다.
  void _goWrite(AuthController auth) {
    final loggedIn = auth.isLoggedIn.value;
    Get.toNamed(loggedIn ? Routes.home : Routes.login,
        arguments: {'tab': 'write'});
  }

  /// '자서전 보기' 버튼 클릭 핸들러
  void _goView(AuthController auth) {
    final loggedIn = auth.isLoggedIn.value;
    Get.toNamed(loggedIn ? Routes.home : Routes.login,
        arguments: {'tab': 'view'});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[100], // 연한 회색 배경
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 0, // AppBar 높이를 0으로 설정하여 숨김
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                // 메인 타이틀
                const Text(
                  'LIFE LEGACY',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF4A90E2), // 파란색
                    letterSpacing: 8.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // 서브 타이틀 - 첫 번째 줄
                const Text(
                  'AI와 융성인의 기술을 활용한',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                // 서브 타이틀 - 두 번째 줄
                const Text(
                  '맞춤형 자서전 제작 서비스',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // 버튼들을 담는 컨테이너
                Column(
                  children: [
                    // 자서전 작성 버튼 (파란색 채워진 버튼)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _goWrite(auth),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '자서전 작성',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 자서전 보기 버튼 (흰색 테두리 버튼)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => _goView(auth),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4A90E2),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFF4A90E2),
                            width: 1.5,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '자서전 보기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Obx(() => Text(
                      auth.loading.value
                          ? '세션 확인 중...'
                          : (auth.isLoggedIn.value
                              ? '로그인 상태: ON'
                              : '로그인 상태: OFF'),
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: Colors.black45),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
