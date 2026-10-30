---
name: verify-and-test
description: 구현 후 실제 실행으로 검증한다. 서버 smoke test(curl), 핵심 로직 단위 테스트, Playwright로 화면 스크린샷·콘솔 에러 확인, 인수 기준 체크표 작성. 테스트, 검증, QA, 스크린샷, 동작 확인, 완료 전 점검이 필요할 때 사용.
---

# 검증

"완료"라고 말하기 전에 아래 중 해당하는 것을 실제로 실행하고 결과를 보여준다.

## 1. 인수 기준 체크표
```
| 기준 | 확인 방법 | 결과 | 증거 |
|---|---|---|---|
| M1 | curl POST /items | 통과 | 201, id 반환 |
```

## 2. 백엔드
- curl로 정상 1건 + 실패 1건.
- 핵심 계산/변환 로직은 pytest 또는 node:test로 3~5개 테스트 (경계값 포함).

## 3. 화면 (Playwright)
설치 확인: `python3 -c "import playwright"` 실패 시 `pip install playwright && python3 -m playwright install chromium`
```python
# check_ui.py
import sys
from playwright.sync_api import sync_playwright
url = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:5173"
with sync_playwright() as p:
    b = p.chromium.launch()
    for name, w, h in [("desktop", 1280, 800), ("mobile", 390, 844)]:
        pg = b.new_page(viewport={"width": w, "height": h})
        errs = []
        pg.on("console", lambda m: errs.append(m.text) if m.type == "error" else None)
        pg.goto(url); pg.wait_for_load_state("networkidle")
        pg.screenshot(path=f"shot_{name}.png", full_page=True)
        print(name, "console errors:", errs or "없음")
    b.close()
```
- 스크린샷을 직접 열어 보고 깨진 레이아웃, 잘린 글자, 빈 영역을 보고한다.
- 핵심 사용자 흐름 1개는 클릭/입력까지 스크립트로 따라간다.

## 4. 끝내기 전
- 새로 띄운 서버/프로세스 정리
- 테스트용 임시 파일(shot_*.png 등)은 제출에서 뺄지 사용자에게 묻는다
