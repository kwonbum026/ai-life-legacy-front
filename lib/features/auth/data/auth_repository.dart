// Repository: DataSource(API/DB 등)들을 조합하고
// Domain/UseCase에서 쓰기 좋은 형태로 변환하는 계층.
import 'package:ai_life_legacy/features/auth/data/auth_api.dart';
import 'package:ai_life_legacy/features/auth/data/models/auth.dto.dart';
import 'package:ai_life_legacy/app/core/models/response.dart';

/// 도메인이 의존하는 추상 인터페이스.
/// 장점: 구현체 교체/테스트 더블 주입 용이.
abstract class AuthRepository {
  Future<Success201Response<JwtTokenResponseDto>> signUp(
    AuthCredentialsDto credentials,
  );
  Future<SuccessResponse<JwtTokenResponseDto>> login(
    AuthCredentialsDto credentials,
  );
  Future<SuccessResponse<JwtTokenResponseDto>> refreshToken(
    RefreshTokenDto refreshTokenDto,
  );
  Future<bool> checkSession();
}

/// 실제 구현체. AuthApi를 사용.
/// 반환 타입/에러 매핑을 통일해 상위 계층이 단순해지도록 함.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  AuthRepositoryImpl(this.api);

  @override
  Future<Success201Response<JwtTokenResponseDto>> signUp(
    AuthCredentialsDto credentials,
  ) =>
      api.signUp(credentials);

  @override
  Future<SuccessResponse<JwtTokenResponseDto>> login(
    AuthCredentialsDto credentials,
  ) =>
      api.login(credentials);

  @override
  Future<SuccessResponse<JwtTokenResponseDto>> refreshToken(
    RefreshTokenDto refreshTokenDto,
  ) =>
      api.refreshToken(refreshTokenDto);

  @override
  Future<bool> checkSession() => api.checkSession();
}
