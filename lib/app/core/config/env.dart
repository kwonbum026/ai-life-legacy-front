// 환경변수 관리. 빌드 타임/런타임 환경에 따라 값을 바꿔 주입할 수 있음.
class Env {
  static const apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://ai-life-legacy-backend-nestjs.onrender.com',
  );

  /// 환경값 로드. (String.fromEnvironment는 컴파일 타임 상수라 별도 로드 로직 불필요)
  static void load() {
    print("현재 서버: $apiBase");
  }
}
