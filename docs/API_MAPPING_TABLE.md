# 📊 화면별 API 매핑 테이블 (간단 버전)

## 빠른 참조 테이블

| 화면 | API 엔드포인트 | Method | 설명 | 사용 시점 | 우선순위 |
|------|---------------|--------|------|-----------|----------|
| **로그인 페이지** |
| | `/auth/signup` | POST | 회원가입 | 회원가입 버튼 클릭 | 🔴 필수 |
| | `/auth/signin` | POST | 로그인 | 로그인 버튼 클릭 | 🔴 필수 |
| | `/auth/refresh` | POST | 토큰 갱신 | AccessToken 만료 시 (자동) | 🔴 필수 |
| **홈 페이지** |
| | `/users/:uuid/contents` | GET | 목차 목록 조회 | 페이지 진입 시 | 🔴 필수 |
| | `/users/:uuid/cases` | GET | 케이스 조회 | 첫 진입 시 (선택) | 🟡 선택 |
| **자기소개 작성 페이지** |
| | `/users/:uuid/contents/:contentsId/questions` | GET | 질문 목록 조회 | 페이지 진입 시 | 🔴 필수 |
| | `/ai/case` | POST | 케이스 분류 AI | 초기 입력 시 (케이스 없을 때) | 🟡 선택 |
| | `/users/:uuid/cases` | PUT | 케이스 저장 | AI 분류 후 | 🟡 선택 |
| | `/ai/question` | POST | 2차 질문 생성 AI | 답변 입력 후 | 🟡 선택 |
| | `/ai/combine` | POST | 답변 합치기 AI | 여러 답변 합칠 때 | 🟢 선택 |
| | `/post/` | POST | 자서전 저장 | 답변 완료 후 저장 | 🔴 필수 |
| | `/post/` | PATCH | 자서전 업데이트 | 답변 수정 시 | 🟡 선택 |
| **자서전 보기 페이지** (미구현) |
| | `/users/:uuid/posts` | GET | 자서전 전체 조회 | 페이지 진입 시 | 🟡 선택 |
| **마이페이지** |
| | `/users/:uuid?deleteType={number}` | DELETE | 회원탈퇴 | 탈퇴 버튼 클릭 | 🟢 선택 |



