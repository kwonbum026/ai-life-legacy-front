// 앱 시작 시 "단 한 번" 실행되는 초기화 진입점.
// 역할: 환경변수 로드, 전역 네트워크 클라이언트(Dio) 세팅 등 공용 부팅 로직.

import 'app/core/config/env.dart';
import 'app/core/network/dio_client.dart';

/// 비동기 초기화 함수. 반환값은 Future<void> (아무것도 반환하지 않음).
/// - App run 전에 필요한 준비를 마침.
Future<void> bootstrap() async {
  Env.load();       // 환경 값 로드 (현재는 하드코딩, 이후 --dart-define/.env 가능)
  DioClient.init(); // 전역 Dio 인스턴스 생성 및 옵션 설정
}
