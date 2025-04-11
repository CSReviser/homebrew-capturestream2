#!/bin/bash
# CaptureStream2 GUI 管理スクリプト（クリック実行可能）

if ! command -v brew >/dev/null 2>&1; then
  osascript -e 'display alert "Homebrew がインストールされていません。\nhttps://brew.sh/ja/ を参照してください。"'
  exit 1
fi

# 最新版キャスク名
LATEST_CASK="capturestream2"

# バージョン一覧を取得
get_versions_list() {
  brew search capturestream2 | grep -E 'capturestream2@' | sed -E 's/^capturestream2@//'
}

# AppleScript 選択用ダイアログ
choose_version() {
  versions=$(get_versions_list)
  versionList=$(echo "$versions" | awk '{print "\"" $0 "\"" }' | paste -sd "," -)
  osascript <<EOF
set versionOptions to {$versionList}
choose from list versionOptions with title "ロールバック対象バージョンの選択" with prompt "バージョンを選択してください"
EOF
}

# 選択肢表示
CHOICE=$(osascript <<EOF
set options to {"最新版をインストール", "最新版をアンインストール", "最新版を更新", "最新版を再インストール", "インストール済みキャスク一覧", "ロールバック（バージョン選択）", "ロールバック解除（最新版へ）", "利用可能なバージョン一覧", "終了"}
choose from list options with title "CaptureStream2 管理" with prompt "実行する操作を選択してください"
EOF
)

# 選択に応じた処理
case "$CHOICE" in
  "最新版をインストール")
    brew install --cask "$LATEST_CASK"
    ;;
  "最新版をアンインストール")
    brew uninstall --cask "$LATEST_CASK"
    ;;
  "最新版を更新")
    brew upgrade --cask "$LATEST_CASK"
    ;;
  "最新版を再インストール")
    brew reinstall --cask "$LATEST_CASK"
    ;;
  "インストール済みキャスク一覧")
    installed=$(brew list --cask | sed 's/^/・/')
    osascript -e "display dialog \"$installed\" with title \"インストール済みキャスク\""
    ;;
  "ロールバック（バージョン選択）")
    version=$(choose_version)
    [[ "$version" = "false" ]] && exit 0
    brew install --cask "capturestream2@${version}"
    ;;
  "ロールバック解除（最新版へ）")
    version=$(choose_version)
    [[ "$version" = "false" ]] && exit 0
    brew uninstall --cask "capturestream2@${version}"
    brew reinstall --cask "$LATEST_CASK"
    ;;
  "利用可能なバージョン一覧")
    available=$(brew search capturestream2 | sed 's/^/・/')
    osascript -e "display dialog \"$available\" with title \"利用可能なバージョン\""
    ;;
  "終了")
    exit 0
    ;;
esac