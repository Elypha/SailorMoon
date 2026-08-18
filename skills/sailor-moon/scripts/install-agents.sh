#!/usr/bin/env bash
set -euo pipefail

force=0
dry_run=0
codex_home="${CODEX_HOME:-$HOME/.codex}"

usage() {
  cat <<'EOF'
Install the SailorMoon Codex custom-agent profiles.

Usage:
  bash scripts/install-agents.sh [options]

Options:
  --codex-home PATH  Configuration root containing agents/ (default: $CODEX_HOME or $HOME/.codex)
  --force            Replace existing SailorMoon agent files
  --dry-run          Print the planned destinations without writing
  -h, --help         Show this help

The installer copies only the two bundled TOML profiles. It does not install the
skill, change project files, mutate Git state, or edit AGENTS.md.
EOF
}

while (($# > 0)); do
  case "$1" in
    --codex-home)
      (($# >= 2)) || { echo "Missing value for --codex-home" >&2; exit 2; }
      codex_home="$2"
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if command -v cygpath >/dev/null 2>&1; then
  codex_home="$(cygpath -u "$codex_home")"
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source_root="$(cd -- "$script_dir/../agents" && pwd -P)"
target_root="${codex_home%/}/agents"

agent_names=(
  sailor_moon_explorer.toml
  sailor_moon_implementer.toml
)

for agent_name in "${agent_names[@]}"; do
  source_path="$source_root/$agent_name"
  if [[ ! -f "$source_path" ]]; then
    echo "Missing bundled agent profile: $source_path" >&2
    exit 1
  fi
done

if ((dry_run)); then
  printf 'SailorMoon agent installation preview:\n'
  printf '  Source: %s\n' "$source_root"
  printf '  Target: %s\n' "$target_root"
  for agent_name in "${agent_names[@]}"; do
    printf '  File:   %s\n' "$target_root/$agent_name"
  done
  exit 0
fi

collision=0
for agent_name in "${agent_names[@]}"; do
  target_path="$target_root/$agent_name"
  if [[ -e "$target_path" ]]; then
    printf 'Existing SailorMoon path: %s\n' "$target_path" >&2
    collision=1
  fi
done

if ((collision && !force)); then
  echo "Review the existing files or rerun with --force." >&2
  exit 1
fi

mkdir -p "$target_root"
for agent_name in "${agent_names[@]}"; do
  cp -f "$source_root/$agent_name" "$target_root/$agent_name"
done

printf 'SailorMoon agent installation complete.\n'
printf '  Agents: %s\n' "$target_root"
