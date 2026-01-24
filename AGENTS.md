# Agent Guidelines

This repo must work across macOS, Linux, and WSL. Avoid assumptions that only one
platform is present.

## Cross-platform patterns
- Prefer OS-agnostic helpers in `scripts/util/` for differences (e.g., `stat_*`).
- Keep OS-specific logic in `scripts/os-specific.bash` and `scripts/macos.bash`
  or `scripts/wsl.bash`, not scattered throughout general scripts.
- Avoid hardcoded paths like `/opt/homebrew` outside macOS-specific scripts.
- Detect platform via `uname`/`OSTYPE`/`WSL_DISTRO_NAME` and provide fallbacks.
- Use feature checks (`command -v`, file exists) before invoking tools.
