import 'package:ai_life_legacy/app/core/config/env.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/utils/token_storage.dart';

/// 비동기 초기화 함수.
Future<void> bootstrap() async {
  Env.load(); // 환경 값 로드 (현재는 하드코딩, 이후 --dart-define/.env 가능)
  await TokenStorage.init(); // 저장된 토큰 로드 (로그인 기록 유지)
  DioClient.init(); // 전역 Dio 인스턴스 생성 및 옵션 설정
}
