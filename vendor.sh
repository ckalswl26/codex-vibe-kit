#!/usr/bin/env bash
# 선택: 공개 저장소의 검증된 skill 몇 개를 원본에서 받아 함께 설치한다.
# 각 skill의 라이선스는 원본 저장소를 따른다 (anthropics/skills: Apache-2.0, obra/superpowers: MIT).
#   bash vendor.sh            # ~/.agents/skills
#   bash vendor.sh <설치경로>  # 예: ./.agents/skills
set -euo pipefail

DEST="${1:-$HOME/.agents/skills}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$DEST"

fetch() {  # repo  skill_path  설치이름
  local repo="$1" path="$2" name="$3"
  local dir="$TMP/${repo//\//_}"
  [ -d "$dir" ] || git clone --depth 1 -q "https://github.com/$repo.git" "$dir" || { echo "[x] clone 실패: $repo"; return 0; }
  if [ -f "$dir/$path/SKILL.md" ]; then
    rm -rf "${DEST:?}/$name"; cp -r "$dir/$path" "$DEST/$name"
    echo "[+] $repo/$path -> $DEST/$name"
  else
    echo "[-] 없음(건너뜀): $repo/$path"
  fi
}

# 화면 디자인 품질 / 로컬 웹앱 Playwright 테스트
fetch anthropics/skills skills/frontend-design   frontend-design
fetch anthropics/skills skills/webapp-testing    webapp-testing
# 체계적 디버깅 / 완료 전 검증
fetch obra/superpowers  skills/systematic-debugging           systematic-debugging
fetch obra/superpowers  skills/verification-before-completion verification-before-completion

echo "완료. Codex를 다시 실행하세요."
