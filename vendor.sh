#!/usr/bin/env bash
# 선택: 공개 저장소의 skill을 원본에서 받아 설치한다. 라이선스는 각 원본 저장소를 따른다.
#   bash vendor.sh                     # 기본 묶음 -> ~/.agents/skills
#   bash vendor.sh --design            # 기본 + 디자인 묶음
#   bash vendor.sh --kasangyong        # 기본 + kasangyong 하네스 skill
#   bash vendor.sh --all               # 전부
#   bash vendor.sh ./.agents/skills --design
set -euo pipefail

DEST="$HOME/.agents/skills"
DESIGN=0
KSY=0
for a in "$@"; do
  case "$a" in
    --design) DESIGN=1 ;;
    --kasangyong) KSY=1 ;;
    --all) DESIGN=1; KSY=1 ;;
    *) DEST="$a" ;;
  esac
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$DEST"
DEST="$(cd "$DEST" && pwd)"

fetch() {  # repo  skill_path  설치이름
  local repo="$1" path="$2" name="$3"
  local dir="$TMP/${repo//\//_}"
  [ -d "$dir" ] || git clone --depth 1 -q "https://github.com/$repo.git" "$dir" || { echo "[x] clone 실패: $repo"; return 0; }
  if [ -f "$dir/$path/SKILL.md" ]; then
    rm -rf "${DEST:?}/$name"
    cp -rL "$dir/$path" "$DEST/$name"
    echo "[+] $repo/$path -> $DEST/$name"
  else
    echo "[-] 없음(건너뜀): $repo/$path"
  fi
}

# ── 기본 묶음 ───────────────────────────────────────────
# anthropics/skills (Apache-2.0): 화면 디자인 방향 / 로컬 웹앱 Playwright 테스트
fetch anthropics/skills skills/frontend-design   frontend-design
fetch anthropics/skills skills/webapp-testing    webapp-testing
# obra/superpowers (MIT): 체계적 디버깅 / 완료 전 검증
fetch obra/superpowers  skills/systematic-debugging           systematic-debugging
fetch obra/superpowers  skills/verification-before-completion verification-before-completion

# ── 디자인 묶음 (--design) ──────────────────────────────
if [ "$DESIGN" = 1 ]; then
  # pbakaus/impeccable (Apache-2.0): 디자인 디렉션, 비평·다듬기(polish, bolder, quieter, audit 등)
  fetch pbakaus/impeccable .agents/skills/impeccable impeccable
  # nextlevelbuilder/ui-ux-pro-max-skill (MIT): 제품 유형별 색·폰트·스타일 추천 (Python, 오프라인 CSV 검색)
  fetch nextlevelbuilder/ui-ux-pro-max-skill .claude/skills/ui-ux-pro-max ui-ux-pro-max
  if [ -f "$DEST/ui-ux-pro-max/SKILL.md" ]; then
    # Claude 전용 경로 변수를 실제 설치 경로로 바꿔 Codex에서도 스크립트가 실행되게 한다
    sed -i.bak "s#\${CLAUDE_PLUGIN_ROOT}/.claude/skills/ui-ux-pro-max#$DEST/ui-ux-pro-max#g" "$DEST/ui-ux-pro-max/SKILL.md"
    rm -f "$DEST/ui-ux-pro-max/SKILL.md.bak"
  fi
  # ComposioHQ/awesome-codex-skills: 색·타이포 테마를 CSS 변수로
  fetch ComposioHQ/awesome-codex-skills theme-factory theme-factory
fi

# ── kasangyong 묶음 (--kasangyong) ─────────────────────
# kasangyong/vibe_coding_guide_kasangyong: 설계→구현→리뷰 역할 skill, 위험 작업 가드, 디자인 가이드
if [ "$KSY" = 1 ]; then
  fetch kasangyong/vibe_coding_guide_kasangyong skills/core/plan-eng plan-eng
  fetch kasangyong/vibe_coding_guide_kasangyong skills/core/build    build
  fetch kasangyong/vibe_coding_guide_kasangyong skills/core/review   review
  fetch kasangyong/vibe_coding_guide_kasangyong skills/core/careful  careful
  kdir="$TMP/kasangyong_vibe_coding_guide_kasangyong"
  if [ -d "$kdir/docs" ]; then
    mkdir -p "$DEST/ksy-docs"
    cp "$kdir/docs/design_guide.md" "$kdir/docs/prompt.md" "$DEST/ksy-docs/" 2>/dev/null || true
    echo "[+] 참고 문서(design_guide.md, prompt.md) -> $DEST/ksy-docs"
  fi
fi

echo "완료. Codex를 다시 실행하세요."
