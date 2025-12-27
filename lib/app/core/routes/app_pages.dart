// GetX 라우트 등록. 경로 → 화면(page) + DI(binding) 매핑.

import 'package:get/get.dart';
import 'package:ai_life_legacy/features/main/presentation/pages/main_page.dart';
import 'package:ai_life_legacy/features/auth/presentation/pages/login_page.dart';
import 'package:ai_life_legacy/features/auth/presentation/pages/signup_page.dart';
import 'package:ai_life_legacy/features/auth/presentation/pages/signup_page.dart';
// import 'package:ai_life_legacy/features/auth/presentation/bindings.dart'; // Updated
import 'package:ai_life_legacy/features/home/presentation/pages/home_page.dart';
import 'package:ai_life_legacy/features/onboarding/presentation/pages/self_intro_page.dart';
import 'package:ai_life_legacy/features/autobiography/presentation/pages/autobiography_list_page.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';
import 'package:ai_life_legacy/features/home/presentation/bindings/home_binding.dart';
import 'package:ai_life_legacy/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:ai_life_legacy/features/profile/presentation/pages/my_page.dart';
import 'package:ai_life_legacy/features/profile/presentation/bindings/my_page_binding.dart';

class AppPages {
  // getPages: GetMaterialApp에서 이 리스트를 가져가 라우팅 테이블 생성
  static final pages = <GetPage>[
    // 1. 시작 화면 (/)
    GetPage(name: Routes.main, page: () => const MainPage()),

    // 2. 로그인 화면 (/login)
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      // binding: AuthBinding(), // 전역 InitialBinding 사용
    ),

    // 2.5. 회원가입 화면 (/signup)
    GetPage(
      name: Routes.signup,
      page: () => const SignUpPage(),
      // binding: AuthBinding(), // 전역 사용
    ),

    // 3. 홈 화면 (/home)
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      bindings: [
        HomeBinding(), // - 게시글 관련 기능
      ],
    ),

    // 4. 자기소개 작성 화면 (/self_intro)
    GetPage(
      name: Routes.selfIntro,
      page: () => const SelfIntroPage(),
      bindings: [
        // JournalBinding(), // 삭제
        // SelfIntroController는 HomeBinding이나 별도 바인딩 필요
        // 여기서는 임시로 바인딩 추가하거나 Get.put 사용
        // 하지만 Clean Architecture상 Binding 권장.
        // OnboardingBinding을 사용하거나 여기서 직접 BindingsBuilder 사용
        OnboardingBinding(),
      ],
    ),

    // 5. 자서전 목록 화면 (/autobiography)
    GetPage(
      name: Routes.autobiography,
      page: () => const AutobiographyListPage(),
      bindings: [
        HomeBinding(),
      ],
    ),
    // 6. 마이페이지 화면 (/mypage)
    GetPage(
      name: Routes.myPage,
      page: () => const MyPage(),
      binding: MyPageBinding(),
    ),
  ];
}
