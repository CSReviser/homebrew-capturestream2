#!/bin/bash
# CLI向け CaptureStream2 管理スクリプト

LATEST_CASK="capturestream2"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew が見つかりません。https://brew.sh/ja/ を参照してください。"
  exit 1
fi

list_versions() {
  brew search capturestream2 | grep -E 'capturestream2@' | sed -E 's/^capturestream2@//'
}

select_version() {
  echo "利用可能なバージョン一覧:"
  list_versions | nl
  read -rp "ロールバック対象の番号を選んでください: " num
  version=$(list_versions | sed -n "${num}p")
  if [[ -z "$version" ]]; then
    echo "選択された番号が不正です。"
    exit 1
  fi
  echo "$version"
}

while true; do
  echo "===== CaptureStream2 管理メニュー ====="
  echo "1) 最新版のインストール"
  echo "2) 最新版のアンインストール"
  echo "3) アップデート"
  echo "4) 再インストール"
  echo "5) インストール済み一覧表示"
  echo "6) ロールバック（バージョン選択）"
  echo "7) ロールバック解除（最新版へ）"
  echo "8) 利用可能なバージョン一覧表示"
  echo "9) 終了"
  read -rp "番号で選択してください [1-9]: " choice

  case "$choice" in
    1) brew install --cask "$LATEST_CASK" ;;
    2) brew uninstall --cask "$LATEST_CASK" ;;
    3) brew upgrade --cask "$LATEST_CASK" ;;
    4) brew reinstall --cask "$LATEST_CASK" ;;
    5) brew list --cask ;;
    6)
      version=$(select_version)
      brew install --cask "capturestream2@${version}"
      ;;
    7)
      version=$(select_version)
      brew uninstall --cask "capturestream2@${version}"
      brew reinstall --cask "$LATEST_CASK"
      ;;
    8) brew search capturestream2 ;;
    9) break ;;
    *) echo "無効な選択肢です。" ;;
  esac
done