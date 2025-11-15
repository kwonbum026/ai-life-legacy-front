// GetX 라우트 등록. 경로 → 화면(page) + DI(binding) 매핑.

import 'package:get/get.dart';
import 'package:ai_life_legacy/features/journal/presentation/bindings.dart';
import 'package:ai_life_legacy/features/main/presentation/pages/main_page.dart';
import 'package:ai_life_legacy/features/auth/presentation/pages/login_page.dart';
import 'package:ai_life_legacy/features/auth/presentation/bindings.dart';
import 'package:ai_life_legacy/features/journal/presentation/pages/home_page.dart';
import 'package:ai_life_legacy/features/journal/presentation/pages/selfIntro_page.dart';
import 'package:ai_life_legacy/features/post/data/presentation/autobiography_list_screen.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';

class AppPages {
  /// getPages: GetPage 리스트.
  /// GetPage: name(경로), page(생성자), binding(DI 설치) 등 설정.
  static final pages = <GetPage>[
    GetPage(
        name: Routes.main,
        page: () => const MainPage(),
        binding: AuthBinding()), // 시작 시 AuthController 주입(세션 확인 위해)
    GetPage(
        name: Routes.login,
        page: () => const LoginPage(),
        binding: AuthBinding()), // 로그인 화면도 Auth 사용
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      bindings: [
        AuthBinding(),
        JournalBinding(),
      ],
    ),
    GetPage(
      name: Routes.selfIntro,
      page: () => const SelfIntroPage(),
      bindings: [
        AuthBinding(),
        JournalBinding(),
      ],
    ),
    GetPage(
      name: Routes.autobiography,
      page: () => const AutobiographyListScreen(),
      bindings: [
        AuthBinding(),
        JournalBinding(),
      ],
    ),
  ];
}
