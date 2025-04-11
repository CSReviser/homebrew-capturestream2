#!/bin/bash
LATEST_CASK="capturestream2"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew が見つかりません。https://brew.sh/ja/ を参照してください。"
  exit 1
fi

list_versions() {
  brew search capturestream2 | grep -E 'capturestream2@' | sed -E 's/^capturestream2@//'
}

select_version_by_index() {
  list_versions | sed -n "${1}p"
}

# 非対話モード（引数がある場合）
if [[ -n "$1" ]]; then
  case "$1" in
    install)
      brew install --cask "$LATEST_CASK"
      ;;
    uninstall)
      brew uninstall --cask "$LATEST_CASK"
      ;;
    reinstall)
      brew reinstall --cask "$LATEST_CASK"
      ;;
    upgrade)
      brew upgrade --cask "$LATEST_CASK"
      ;;
    list)
      brew list --cask
      ;;
    rollback)
      version=$(select_version_by_index "${2:-1}")
      if [[ -z "$version" ]]; then
        echo "無効なバージョン番号です。"
        exit 1
      fi
      brew install --cask "capturestream2@${version}"
      ;;
    rollback-reset)
      version=$(select_version_by_index "${2:-1}")
      brew uninstall --cask "capturestream2@${version}"
      brew reinstall --cask "$LATEST_CASK"
      ;;
    available)
      brew search capturestream2
      ;;
    *)
      echo "無効な引数です。使用可能な引数: install, uninstall, reinstall, upgrade, list, rollback [番号], rollback-reset [番号], available"
      exit 1
      ;;
  esac
  exit 0
fi