# 📊 화면별 API 매핑 테이블 (간단 버전)

## 빠른 참조 테이블

| 화면 | API 엔드포인트 | Method | 설명 | 사용 시점 | 우선순위 |
|------|---------------|--------|------|-----------|----------|
| 로그인 페이지 | `/auth/signup` | POST | 회원 가입과 동시에 액세스·리프레시 토큰 발급 | 회원가입 완료 시 | 🔴 필수 |
| 로그인 페이지 | `/auth/login` | POST | 로그인 및 토큰 발급 | 로그인 버튼 클릭 | 🔴 필수 |
| 로그인 페이지 | `/auth/refresh-token` | POST | 리프레시 토큰으로 액세스 토큰 재발급 | 액세스 토큰 만료 시 | 🔴 필수 |
| 홈 페이지 | `/users/me/toc` | GET | 맞춤 목차·진행률 목록 조회 | 홈 진입 즉시 | 🔴 필수 |
| 홈 페이지 | `/users/me/toc-questions` | GET | 목차별 질문 트리 선로딩 | 초기 데이터 프리패치 | 🟡 선택 |
| 자기소개 작성 | `/users/me/toc-questions` | GET | 전체 목차·질문 구조 로딩 | 페이지 진입 시 | 🔴 필수 |
| 자기소개 작성 | `/life-legacy/toc/:tocId/questions` | GET | 선택 목차 질문 상세 조회 | 목차 선택 시 | 🔴 필수 |
| 자기소개 작성 | `/users/me/intro` | POST | 사용자 자기소개 서문 저장 | 초기 입력 저장 시 | 🔴 필수 |
| 자기소개 작성 | `/life-legacy/toc/:tocId/questions/:questionId/answers` | POST | 질문의 최종 답변 저장 | 답변 완료 후 | 🔴 필수 |
| 자기소개 작성 | `/users/me/answers/:answerId` | PATCH | 저장된 답변 수정 | 답변 수정 시 | 🟡 선택 |
| 자기소개 작성 | `/ai/question` | POST | 2차 질문 생성 AI | 1차 답변 입력 후 | 🟡 선택 |
| 자기소개 작성 | `/ai/combine` | POST | 여러 답변 병합 | 답변 병합 시 | 🟢 선택 |
| 자서전 보기 | `/users/me/toc-questions` | GET | 전체 자서전 구조 조회 | 페이지 진입 시 | 🟡 선택 |
| 자서전 보기 | `/users/me/answers?tocId={id}&questionId={id}` | GET | 특정 질문 작성본 조회 | 항목 열람 시 | 🟡 선택 |
| 마이페이지 | `/users/me` (body에 탈퇴 사유 포함) | DELETE | 회원 탈퇴 처리 | 탈퇴 버튼 확인 후 | 🟢 선택 |




