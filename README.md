# codex-vibe-kit

Codex로 작업할 때 쓰는 작업 규칙(AGENTS.md)과 skill 모음.
요구사항 정리 → 범위 설정 → 구현 → 검증 → 설명 준비 흐름에 맞춰 구성했다.

## 구성
```
AGENTS.md                      작업 규칙 (탐색→계획→구현→검증→기록, 과설계 금지)
skills/
  requirements-discovery/      담당자 질문 설계, REQUIREMENTS.md
  scope-and-plan/              MVP 범위, PLAN.md, 시간 배분
  decision-log/                DECISIONS.md, EXPLAIN.md, 이해 확인 질문
  backend-api/                 최소 API + 저장소, curl 검증
  frontend-ui/                 디자인 토큰, 상태 처리, 반응형
  image-assets/                API 없이 SVG/아이콘/차트
  verify-and-test/             인수 기준 체크표, Playwright 스크린샷
  debug-loop/                  재현→가설→최소 수정→재검증
  ship-check/                  제출 전 점검
install.sh                     skill 설치
vendor.sh                      (선택) 공개 skill 일부를 원본 저장소에서 받아 설치
```

## 설치
```bash
git clone https://github.com/ckalswl26/codex-vibe-kit.git
cd codex-vibe-kit

bash install.sh                    # ~/.agents/skills 에 설치
bash install.sh project ../my-task # 과제 폴더에 AGENTS.md + .agents/skills 설치
bash install.sh legacy             # ~/.codex/skills 에 설치 (구버전)

bash vendor.sh                     # 선택: 공개 skill 추가
bash vendor.sh --design            # 선택: 디자인 skill까지 추가
```

### vendor.sh로 받는 공개 skill
| 묶음 | skill | 원본 | 용도 |
|---|---|---|---|
| 기본 | frontend-design | anthropics/skills | 디자인 방향을 정하고 흔한 AI 스타일 피하기 |
| 기본 | webapp-testing | anthropics/skills | Playwright로 로컬 웹앱 확인 |
| 기본 | systematic-debugging | obra/superpowers | 원인 중심 디버깅 |
| 기본 | verification-before-completion | obra/superpowers | 완료 전 실제 검증 |
| 디자인 | impeccable | pbakaus/impeccable | 디자인 비평·다듬기 (polish, bolder, quieter, audit 등) |
| 디자인 | ui-ux-pro-max | nextlevelbuilder/ui-ux-pro-max-skill | 제품 유형별 색·폰트·스타일 추천 (Python, 오프라인) |
| 디자인 | theme-factory | ComposioHQ/awesome-codex-skills | 색·타이포 테마를 CSS 변수로 |
| kasangyong | plan-eng / build / review / careful | kasangyong/vibe_coding_guide_kasangyong | 설계 → 구현 → 리뷰 역할 분리, 위험 작업 전 확인 |

`bash vendor.sh --all` 로 전부 설치할 수 있다.
설치 후 Codex를 다시 실행한다.

## 사용 예
```
README 읽고 요약만 해줘. 코드는 건드리지 마.
requirements-discovery 로 담당자에게 물어볼 질문 뽑아줘.
scope-and-plan 으로 PLAN.md 만들어줘. 내가 승인하면 1단계부터.
verify-and-test 로 화면 확인해줘.
ship-check 진행해줘.
```

## 참고한 공개 저장소
- https://github.com/openai/skills
- https://github.com/anthropics/skills
- https://github.com/obra/superpowers

vendor.sh로 받는 skill은 각 원본 저장소의 라이선스를 따른다.
