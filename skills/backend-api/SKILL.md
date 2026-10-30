---
name: backend-api
description: 인수 기준에서 최소한의 REST API와 저장소를 설계하고 FastAPI 또는 Express로 구현한 뒤 curl로 검증한다. 서버, 백엔드, API 엔드포인트, DB 스키마, SQLite, JSON 저장, CORS, 시드 데이터가 필요할 때 사용.
---

# 최소 백엔드

## 1. 설계 (코드 전에 표로)
| 메서드 | 경로 | 입력 | 출력 | 인수 기준 |
|---|---|---|---|---|
- 인수 기준에 연결되지 않는 엔드포인트는 만들지 않는다.
- 데이터 모델은 필드 표로 먼저 보여주고 승인받는다.

## 2. 스택 선택
- Python 익숙/데이터 처리 많음 → FastAPI + uvicorn (+ sqlite3 표준 라이브러리)
- 프론트와 같은 언어 원함 → Express
- 환경에 이미 설치된 것을 먼저 확인한다: `python3 --version`, `node -v`, `pip list | head`

## 3. 구현 규칙
- 파일 구조: `server/main.py`(또는 `server/index.js`), `server/data/`, `server/seed.*`
- 입력 검증은 경계에서 한 번 (FastAPI는 Pydantic 모델).
- 에러 응답 형식 통일: `{"error": "메시지"}` + 적절한 상태 코드.
- 프론트와 포트가 다르면 CORS를 개발용으로만 연다.
- 시드 데이터는 실제처럼 보이는 5~20건. README 예시와 맞춘다.
- 비밀값은 코드에 넣지 않는다. `.env.example`만 둔다.

## 4. 검증 (단계마다)
```
# 서버를 백그라운드로 띄우고
curl -s localhost:8000/health
curl -s -X POST localhost:8000/items -H 'Content-Type: application/json' -d '{"name":"test"}'
curl -s -X POST localhost:8000/items -H 'Content-Type: application/json' -d '{}'   # 실패 경우도
```
- 정상 1건, 실패 1건을 항상 함께 확인하고 결과를 보고한다.
- 띄운 서버 프로세스는 작업 후 정리한다.
