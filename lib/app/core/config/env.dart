// 환경변수 관리. 빌드 타임/런타임 환경에 따라 값을 바꿔 주입할 수 있음.
class Env {
  static late String apiBase; // API Base URL. late: 나중에 반드시 초기화된다는 의미.

  /// 환경값 로드. 반환값 없음.
  /// 현재는 하드코딩이지만, 추후 --dart-define, dotenv 패키지, flavors로 대체 가능.
  static void load() {
    apiBase = 'https://api.example.com';
  }
}
