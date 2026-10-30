#!/usr/bin/env bash
# 사용법
#   bash install.sh                 # ~/.agents/skills 에 설치 (사용자 전체)
#   bash install.sh project <경로>   # <경로>/.agents/skills + AGENTS.md (과제 폴더에 설치)
#   bash install.sh legacy          # ~/.codex/skills 에 설치 (구버전 Codex)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-user}"

case "$MODE" in
  user)    DEST="$HOME/.agents/skills" ;;
  legacy)  DEST="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  project)
    TARGET="${2:-.}"
    DEST="$TARGET/.agents/skills"
    if [ -f "$TARGET/AGENTS.md" ]; then
      cp "$HERE/AGENTS.md" "$TARGET/AGENTS.kit.md"
      echo "[!] $TARGET/AGENTS.md 가 이미 있어서 AGENTS.kit.md 로 복사했습니다. 필요한 내용을 합쳐 주세요."
    else
      cp "$HERE/AGENTS.md" "$TARGET/AGENTS.md"
      echo "[+] AGENTS.md -> $TARGET/AGENTS.md"
    fi
    ;;
  *) echo "알 수 없는 모드: $MODE (user | project <경로> | legacy)"; exit 1 ;;
esac

mkdir -p "$DEST"
for d in "$HERE"/skills/*/; do
  name="$(basename "$d")"
  rm -rf "${DEST:?}/$name"
  cp -r "$d" "$DEST/$name"
  echo "[+] skill: $name -> $DEST/$name"
done

echo
echo "완료. Codex를 다시 실행하면 skill이 인식됩니다."
echo "확인: codex 실행 후 '사용 가능한 skill 목록 알려줘' 라고 물어보세요."
