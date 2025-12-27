// 앱의 진입점(엔트리). runApp을 호출해 Flutter 위젯 트리를 띄움.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_life_legacy/bootstrap.dart';
import 'package:ai_life_legacy/app/core/routes/app_pages.dart';
import 'package:ai_life_legacy/app/core/routes/app_routes.dart';
import 'package:ai_life_legacy/app/initial_binding.dart';

/// 프로그램 시작점. 동기/비동기 초기화 후 앱을 실행.
/// WidgetsFlutterBinding.ensureInitialized(): 플러터 엔진/바인딩 초기화.
/// bootstrap(): 환경/네트워크 초기화.
/// runApp(): 최상위 위젯 트리를 화면에 띄움.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const LegacyApp());
}

/// 앱 루트 위젯. 반환 타입: Widget.
/// GetMaterialApp: GetX의 라우팅/로케일/테마 등을 제공하는 MaterialApp 확장.
class LegacyApp extends StatelessWidget {
  const LegacyApp({super.key}); // 플러터가 위젯 구별할 때 사용 (플러터 프레임워크가 알아서 사용)

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      title: 'AI Life Legacy', // 앱 타이틀(안드로이드 최근앱 등)
      initialRoute: Routes.main, // 첫 진입 라우트 경로
      initialBinding: InitialBinding(), // 전역 바인딩 등록 (Auth 등)
      getPages: AppPages.pages, // 라우트 정의 목록
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F8CFF)),
        useMaterial3: true,
      ),
    );
  }
}
