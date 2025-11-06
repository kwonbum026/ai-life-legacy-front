# 기능별 API 매핑 가이드

## 📱 화면별 API 사용 가이드

### 1. 메인 페이지 (MainPage)
**파일**: `lib/features/main/presentation/pages/main_page.dart`

**역할**: 앱 시작 화면, 자서전 작성/보기 선택

**사용 API**:
- ❌ API 호출 없음 (정적 화면)
- ✅ 로그인 상태 확인을 위해 AuthController 사용

---

### 2. 로그인 페이지 (LoginPage)
**파일**: `lib/features/auth/presentation/pages/login_page.dart`

**역할**: 사용자 로그인/회원가입

**사용 API**:

#### 2-1. 회원가입 (Sign Up)
```
POST /auth/signup
```
- **요청**: `AuthCredentialsDto` (email, password)
- **응답**: `Success201Response<JwtTokenResponseDto>`
- **사용 시점**: 회원가입 버튼 클릭 시
- **변경사항**: 현재 쿠폰번호 입력 필드 → email/password로 변경 필요

#### 2-2. 로그인 (Sign In)
```
POST /auth/signin
```
- **요청**: `AuthCredentialsDto` (email, password)
- **응답**: `SuccessResponse<JwtTokenResponseDto>`
- **사용 시점**: 로그인 버튼 클릭 시
- **변경사항**: 현재 쿠폰번호 입력 필드 → email/password로 변경 필요

#### 2-3. 토큰 갱신 (Refresh Token)
```
POST /auth/refresh
```
- **요청**: `RefreshTokenDto` (refreshToken)
- **응답**: `SuccessResponse<JwtTokenResponseDto>`
- **사용 시점**: AccessToken 만료 시 자동 호출 (인터셉터에서 처리)

---

### 3. 홈 페이지 (HomePage)
**파일**: `lib/features/journal/presentation/pages/home_page.dart`

**역할**: 자서전 목차(Contents) 목록 표시

**사용 API**:

#### 3-1. 유저 맞춤형 목차 조회
```
GET /users/:uuid/contents
```
- **파라미터**: uuid (JWT에서 추출)
- **응답**: `SuccessResponse<List<UserContentDto>>`
- **사용 시점**: 페이지 진입 시 `initState()` 또는 `onInit()`
- **매핑**: 
  - `UserContentDto.id` → `ChapterModel.id`
  - `UserContentDto.content` → `ChapterModel.title`
  - Progress 계산 필요 (질문 완료 수 / 전체 질문 수)

#### 3-2. 유저 케이스 조회 (선택적)
```
GET /users/:uuid/cases
```
- **파라미터**: uuid
- **응답**: `SuccessResponse<UserCaseDto>`
- **사용 시점**: 첫 진입 시 케이스 확인(없으면 케이스 분류 화면으로 이동 가능)

**구현 예시**:
```dart
// JournalController에서
void loadUserContents(String uuid) async {
  final result = await userRepository.getUserContents(uuid);
  chapters.value = result.result.map((content) => 
    ChapterModel(
      id: content.id,
      title: content.content,
      subtitle: '진행률 계산 필요',
      progress: 0.0, // TODO: 설문 완료율 계산
    )
  ).toList();
}
```

---

### 4. 자기소개 작성 페이지 (SelfIntroPage)
**파일**: `lib/features/journal/presentation/pages/selfIntro_page.dart`

**역할**: 특정 목차(Content)의 질문에 답변 작성

**사용 API**:

#### 4-1. 목차별 질문 조회
```
GET /users/:uuid/contents/:contentsId/questions
```
- **파라미터**: uuid, contentsId
- **응답**: `SuccessResponse<UserContentAndQuestionsDto>`
- **사용 시점**: 페이지 진입 시 또는 목차 선택 시
- **매핑**: 
  - 첫 번째 질문을 화면 상단에 표시
  - `questions` 배열로 추가 질문 관리

#### 4-2. 유저 케이스 분류 AI (초기 진입 시)
```
POST /ai/case
```
- **요청**: `MakeCaseDto` (data: 사용자 입력 텍스트)
- **응답**: `SuccessResponse<AiResponseDto>`
- **사용 시점**: 
  - 케이스가 없는 경우, 사용자가 초기 입력을 하면 AI가 케이스 분류
  - 분류 결과로 케이스 저장 필요

#### 4-3. 유저 케이스 저장
```
PUT /users/:uuid/cases
```
- **요청**: `SetUserCaseDto` (caseName)
- **응답**: `SuccessResponse<UserCaseDto>`
- **사용 시점**: AI 케이스 분류 후 자동 호출

#### 4-4. 2차 질문 생성 AI
```
POST /ai/question
```
- **요청**: `MakeReQuestionDto` (question: 현재 질문, data: 사용자 답변)
- **응답**: `SuccessResponse<AiResponseDto>`
- **사용 시점**: 
  - 사용자가 답변을 입력하면 AI가 추후 질문 생성
  - 생성된 질문을 채팅에 추가

#### 4-5. 자서전 답변 합치기 AI
```
POST /ai/combine
```
- **요청**: `CombineDto` (question1, data1, question2, data2)
- **응답**: `SuccessResponse<AiResponseDto>`
- **사용 시점**: 
  - 여러 답변을 하나로 합칠 때
  - 사용자가 요청하거나 자동으로 처리

#### 4-6. 자서전 저장
```
POST /post/
```
- **요청**: `SavePostDto` (response: 최종 답변, contentId, questionId)
- **응답**: `Success204Response`
- **사용 시점**: 
  - 사용자가 답변을 완료하고 저장 버튼 클릭 시
  - 또는 자동 저장 기능 구현 시

#### 4-7. 자서전 업데이트
```
PATCH /post/
```
- **요청**: `PatchPostDto` (response: 수정된 답변, contentId, questionId)
- **응답**: `Success204Response`
- **사용 시점**: 기존 답변을 수정할 때

**구현 흐름**:
```
1. 페이지 진입 → GET /users/:uuid/contents/:contentsId/questions
2. 질문 표시 → 사용자 답변 입력
3. 답변 입력 → POST /ai/question (추후 질문 생성)
4. 답변 완료 → POST /post/ (저장)
5. 답변 수정 → PATCH /post/ (업데이트)
```

---

### 5. 자서전 보기 페이지 (미구현 - 추정)
**역할**: 작성한 자서전 전체 조회

**사용 API**:

#### 5-1. 유저 자서전 데이터 조회
```
GET /users/:uuid/posts
```
- **파라미터**: uuid
- **응답**: `SuccessResponse<List<UserPostsDto>>`
- **사용 시점**: 페이지 진입 시
- **매핑**: 
  - `UserPostsDto.response` → 답변 내용
  - `UserPostsDto.content` → 목차 이름
  - `UserPostsDto.question` → 질문 내용

**구현 필요**: 새로운 페이지 생성 필요

---

### 6. 마이페이지 (MyPage)
**파일**: `lib/features/profile/presentation/pages/my_page.dart`

**역할**: 사용자 정보 관리, 회원탈퇴

**사용 API**:

#### 6-1. 회원탈퇴
```
DELETE /users/:uuid?deleteType={number}
```
- **파라미터**: uuid, deleteType (쿼리 파라미터)
- **응답**: `Success204Response`
- **사용 시점**: 회원탈퇴 버튼 클릭 시
- **주의**: deleteType은 숫자로 탈퇴 사유 구분 (예: 1=개인정보, 2=서비스 불만 등)

---

## 🔄 전체 플로우 요약

### 회원가입/로그인 플로우
```
MainPage → LoginPage → [SignUp/SignIn] → HomePage
```

### 자서전 작성 플로우
```
HomePage → [목차 선택] → SelfIntroPage
  ↓
[질문 조회] → [답변 입력] → [AI 질문 생성] → [답변 저장]
  ↓
[추가 질문] → [답변 합치기] → [최종 저장]
```

### 자서전 보기 플로우
```
HomePage → [자서전 보기 탭] → PostsViewPage
  ↓
[전체 자서전 조회] → [목차별 정리 표시]
```

---

## 📋 API 우선순위별 구현 권장사항

### Phase 1: 기본 인증 (필수)
1. ✅ `POST /auth/signup` - 회원가입
2. ✅ `POST /auth/signin` - 로그인
3. ✅ `POST /auth/refresh` - 토큰 갱신 (인터셉터)

### Phase 2: 목차 조회 (필수)
1. ✅ `GET /users/:uuid/contents` - 목차 목록
2. ✅ `GET /users/:uuid/contents/:contentsId/questions` - 질문 목록

### Phase 3: 작성 기능 (핵심)
1. ✅ `POST /post/` - 답변 저장
2. ✅ `PATCH /post/` - 답변 수정
3. ✅ `POST /ai/question` - 질문 생성 (선택)

### Phase 4: AI 기능 (고급)
1. ✅ `POST /ai/case` - 케이스 분류
2. ✅ `PUT /users/:uuid/cases` - 케이스 저장
3. ✅ `POST /ai/combine` - 답변 합치기

### Phase 5: 조회 기능
1. ✅ `GET /users/:uuid/posts` - 자서전 전체 조회
2. ✅ `GET /users/:uuid/cases` - 케이스 조회

### Phase 6: 관리 기능
1. ✅ `DELETE /users/:uuid` - 회원탈퇴

---

## 🔐 인증 처리

**모든 보호된 API (✅ 필요)는 JWT 토큰을 헤더에 포함해야 합니다.**

**Dio 인터셉터 예시**:
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = TokenStorage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // 토큰 갱신 로직
        return _refreshTokenAndRetry(error.requestOptions);
      }
      return handler.next(error);
    },
  ),
);
```

---

## 📝 참고사항

1. **UUID 추출**: JWT 토큰에서 사용자 UUID 추출 필요 (토큰 디코딩)
2. **진행률 계산**: 질문 완료 수를 기반으로 목차별 진행률 계산 필요
3. **에러 처리**: 공통 `ErrorResponse`로 에러 핸들링
4. **로딩 상태**: 각 API 호출 시 로딩 상태 관리 필요
5. **오프라인**: 네트워크 오류 시 로컬 저장 및 재시도 로직 고려




