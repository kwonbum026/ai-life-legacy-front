# Git 커밋 메시지 제안

## 커밋 1: 공통 응답 모델 추가
```
feat: 공통 API 응답 모델 추가
```
**파일**:
- `lib/app/core/models/response.dart`

---

## 커밋 2: API 엔드포인트 상수 추가
```
feat: API 엔드포인트 상수 추가
```
**파일**:
- `lib/app/core/network/api_endpoints.dart`

---

## 커밋 3: 인증 모델 추가
```
feat: 인증 관련 DTO 모델 추가
```
**파일**:
- `lib/features/auth/data/models/auth.dto.dart`

---

## 커밋 4: 사용자 모델 추가
```
feat: 사용자 관련 DTO 모델 추가
```
**파일**:
- `lib/features/user/data/models/user.dto.dart`

---

## 커밋 5: AI 모델 추가
```
feat: AI 관련 DTO 모델 추가
```
**파일**:
- `lib/features/ai/data/models/ai.dto.dart`

---

## 커밋 6: 게시글 모델 추가
```
feat: 게시글 관련 DTO 모델 추가
```
**파일**:
- `lib/features/post/data/models/post.dto.dart`

---

## 커밋 7: API 매핑 문서 추가
```
docs: 화면별 API 매핑 가이드 추가
```
**파일**:
- `docs/API_MAPPING_GUIDE.md`
- `docs/API_MAPPING_TABLE.md`

---

## 🔄 더 간단하게 나누려면 (권장)

### 커밋 1: 공통 모델 및 엔드포인트 추가
```
feat: 공통 응답 모델 및 API 엔드포인트 추가
```
**파일**:
- `lib/app/core/models/response.dart`
- `lib/app/core/network/api_endpoints.dart`

---

### 커밋 2: Feature별 DTO 모델 추가
```
feat: 인증, 사용자, AI, 게시글 DTO 모델 추가
```
**파일**:
- `lib/features/auth/data/models/auth.dto.dart`
- `lib/features/user/data/models/user.dto.dart`
- `lib/features/ai/data/models/ai.dto.dart`
- `lib/features/post/data/models/post.dto.dart`

---

### 커밋 3: API 매핑 문서 추가
```
docs: 화면별 API 매핑 가이드 추가
```
**파일**:
- `docs/API_MAPPING_GUIDE.md`
- `docs/API_MAPPING_TABLE.md`

