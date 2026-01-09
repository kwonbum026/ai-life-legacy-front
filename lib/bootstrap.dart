import 'package:ai_life_legacy/app/core/config/env.dart';
import 'package:ai_life_legacy/app/core/network/dio_client.dart';
import 'package:ai_life_legacy/app/core/utils/token_storage.dart';

/// 앱 실행 전 필수 비동기 초기화 작업을 수행합니다.
Future<void> bootstrap() async {
  Env.load(); // 환경 설정 로드
  await TokenStorage.init(); // 로컬 스토리지 및 토큰 초기화
  DioClient.init(); // 네트워크 클라이언트(Dio) 설정
}
