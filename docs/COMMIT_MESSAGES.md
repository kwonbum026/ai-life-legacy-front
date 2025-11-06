# Git 커밋 메시지 제안

## 커밋 1: 공통 응답 모델 및 유틸리티 추가
```
feat: 공통 API 응답 모델 및 유틸리티 추가

- SuccessResponse, Success201Response, Success204Response 모델 추가
- 응답 필드명: result → data로 변경
- TokenStorage: 토큰 저장/관리 유틸리티 추가
- JwtUtils: JWT 디코딩 및 UUID 추출 유틸리티 추가
```

**변경 파일**:
- `lib/app/core/models/response.dart`
- `lib/app/core/utils/token_storage.dart`
- `lib/app/core/utils/jwt_utils.dart`

---

## 커밋 2: Dio 인터셉터 및 API 엔드포인트 설정
```
feat: Dio 인터셉터 추가 및 API 엔드포인트 설정

- Dio 인터셉터 추가: 토큰 자동 주입 및 갱신
- 401 에러 시 자동 토큰 갱신 및 재시도 로직
- API 엔드포인트 상수 정의
- Base URL 설정: http://localhost:8080
```

**변경 파일**:
- `lib/app/core/network/dio_client.dart`
- `lib/app/core/network/api_endpoints.dart`
- `lib/app/core/config/env.dart`

---

## 커밋 3: 인증 관련 모델 및 API 추가
```
feat: 인증 관련 DTO 모델 및 API 구현

- AuthCredentialsDto, JwtTokenResponseDto, RefreshTokenDto 추가
- AuthApi: signUp, login, refreshToken 구현
- AuthRepository: Repository 패턴 구현
```

**변경 파일**:
- `lib/features/auth/data/models/auth.dto.dart`
- `lib/features/auth/data/auth_api.dart`
- `lib/features/auth/data/auth_repository.dart`

---

## 커밋 4: 인증 컨트롤러 구현
```
feat: 인증 컨트롤러 구현

- AuthController: 회원가입, 로그인, 로그아웃 로직 구현
- 토큰 저장 및 세션 관리
- 에러 메시지 처리
```

**변경 파일**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/features/auth/presentation/bindings.dart`

---

## 커밋 5: 사용자 관련 DTO 모델 추가
```
feat: 사용자 관련 DTO 모델 추가

- UserTocDto: 목차 조회 응답
- UserTocQuestionDto: 목차 및 질문 조회 응답
- QuestionDto, TocQuestionDto: 질문 관련 DTO
- UserAnswerDto: 답변 조회 응답
- UserIntroDto, AnswerSaveDto, AnswerUpdateDto: 요청 DTO
```

**변경 파일**:
- `lib/features/user/data/models/user.dto.dart`

---

## 커밋 6: 사용자 API 및 Repository 구현
```
feat: 사용자 API 및 Repository 구현

- UserApi: /users/me/* 엔드포인트 구현
  - 자기소개 저장
  - 목차 조회
  - 목차 및 질문 조회
  - 답변 조회 및 수정
- UserRepository: Repository 패턴 구현
```

**변경 파일**:
- `lib/features/user/data/user_api.dart`
- `lib/features/user/data/user_repository.dart`

---

## 커밋 7: 인생 유산 API 및 Repository 구현
```
feat: 인생 유산 API 및 Repository 구현

- LifeLegacyApi: /life-legacy/* 엔드포인트 구현
  - 목차별 질문 조회
  - 질문 답변 저장
- PostRepository: Repository 패턴 구현
```

**변경 파일**:
- `lib/features/post/data/post_api.dart`
- `lib/features/post/data/post_repository.dart`

---

## 커밋 8: JournalController API 연동
```
feat: JournalController에 목차 조회 API 연동

- loadUserContents(): /users/me/toc API 호출
- UUID 제거, /users/me 엔드포인트 사용
- 하드코딩된 목차 데이터 제거
```

**변경 파일**:
- `lib/features/journal/presentation/controllers/journal_controller.dart`
- `lib/features/journal/presentation/bindings.dart`

---

## 커밋 9: SelfIntroController API 연동
```
feat: SelfIntroController에 질문 조회 및 답변 저장 연동

- loadQuestions(): /life-legacy/toc/{tocId}/questions API 호출
- saveAnswer(): /life-legacy/questions/{questionId}/answers API 호출
- 질문 자동 진행 로직 구현
```

**변경 파일**:
- `lib/features/journal/presentation/controllers/journal_controller.dart`
- `lib/features/journal/presentation/pages/selfIntro_page.dart`

---

## 🔄 더 간단하게 나누려면 (권장)

### 커밋 1: 공통 인프라 설정
```
feat: 공통 응답 모델, 유틸리티 및 네트워크 설정 추가

- 공통 API 응답 모델 추가 (result → data)
- 토큰 저장/관리 유틸리티 추가
- JWT 디코딩 유틸리티 추가
- Dio 인터셉터 추가 (토큰 자동 주입 및 갱신)
- API 엔드포인트 상수 정의
```

**변경 파일**:
- `lib/app/core/models/response.dart`
- `lib/app/core/utils/token_storage.dart`
- `lib/app/core/utils/jwt_utils.dart`
- `lib/app/core/network/dio_client.dart`
- `lib/app/core/network/api_endpoints.dart`
- `lib/app/core/config/env.dart`

---

### 커밋 2: 인증 기능 구현
```
feat: 인증 API 및 컨트롤러 구현

- Auth DTO 모델 추가
- AuthApi: signUp, login, refreshToken 구현
- AuthRepository 및 AuthController 구현
```

**변경 파일**:
- `lib/features/auth/data/models/auth.dto.dart`
- `lib/features/auth/data/auth_api.dart`
- `lib/features/auth/data/auth_repository.dart`
- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/features/auth/presentation/bindings.dart`

---

### 커밋 3: 사용자 및 인생 유산 API 구현
```
feat: 사용자 및 인생 유산 API 구현

- User DTO 모델 추가
- UserApi: /users/me/* 엔드포인트 구현
- LifeLegacyApi: /life-legacy/* 엔드포인트 구현
- Repository 패턴 구현
```

**변경 파일**:
- `lib/features/user/data/models/user.dto.dart`
- `lib/features/user/data/user_api.dart`
- `lib/features/user/data/user_repository.dart`
- `lib/features/post/data/post_api.dart`
- `lib/features/post/data/post_repository.dart`

---

### 커밋 4: 화면별 API 연동
```
feat: JournalController 및 SelfIntroController API 연동

- JournalController: 목차 조회 API 연동
- SelfIntroController: 질문 조회 및 답변 저장 API 연동
- Bindings 업데이트
```

**변경 파일**:
- `lib/features/journal/presentation/controllers/journal_controller.dart`
- `lib/features/journal/presentation/bindings.dart`
- `lib/features/journal/presentation/pages/selfIntro_page.dart`

---

## 📝 커밋 메시지 작성 가이드

각 커밋은 다음 형식을 따릅니다:

```
<type>: <subject>

<body>

<footer>
```

### Type 종류
- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `refactor`: 코드 리팩토링
- `docs`: 문서 수정
- `style`: 코드 포맷팅
- `test`: 테스트 추가/수정

### 예시
```
feat: 공통 API 응답 모델 추가

- SuccessResponse, Success201Response, Success204Response 모델 추가
- 응답 필드명: result → data로 변경
- 모든 API 응답에 공통 적용

Closes #123
```
