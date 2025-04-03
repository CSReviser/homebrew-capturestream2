#!/bin/bash
# CaptureStream2 管理スクリプト（GUI対応・クリック実行可能）

# Homebrew のインストール確認
if ! command -v brew >/dev/null 2>&1; then
  osascript -e 'display alert "エラー" message "Homebrew がインストールされていません。\nhttps://brew.sh/ からインストールしてください。"'
  exit 1
fi

# GUI メニューを表示（AppleScript を使用）
CHOICE=$(osascript <<EOF
set options to {"最新版をインストール", "最新版をアンインストール", "最新版を更新（アップデート）", "最新版を再インストール（アップグレード）", "インストール済みキャスクの一覧", "指定バージョンをインストール（ロールバック）", "指定バージョンをアンインストール", "最新版に戻す", "利用可能なキャスク一覧", "終了"}
set selectedOption to choose from list options with title "CaptureStream2 管理" with prompt "実行する操作を選択してください" default items {"最新版をインストール"}
if selectedOption is false then return "終了"
return selectedOption as string
EOF
)

# 最新版キャスク名
LATEST_CASK="capturestream2"

# ユーザにバージョンを入力させる関数
read_version() {
  osascript -e 'set inputVersion to text returned of (display dialog "対象のバージョン番号を入力してください（例: 20250324）" default answer "" with title "バージョン指定")'
}

# 利用可能なバージョン一覧を表示
list_available_versions() {
  AVAILABLE_VERSIONS=$(brew search capturestream2 | sed 's/^/・/g')
  osascript -e "display alert \"利用可能なキャスク一覧\" message \"$AVAILABLE_VERSIONS\""
}

# 選択肢ごとの処理
case "$CHOICE" in
  "最新版をインストール")
    brew install --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版をインストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版をアンインストール")
    brew uninstall --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版をアンインストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版を更新（アップデート）")
    brew upgrade --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版を更新しました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版を再インストール（アップグレード）")
    brew reinstall --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版を再インストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "インストール済みキャスクの一覧")
    INSTALLED_CASKS=$(brew list --cask | sed 's/^/・/g')
    osascript -e "display alert \"インストール済みキャスク一覧\" message \"$INSTALLED_CASKS\""
    ;;
  "指定バージョンをインストール（ロールバック）")
    version=$(read_version)
    ROLLBACK_CASK="capturestream2@${version}"
    brew install --cask "$ROLLBACK_CASK"
    osascript -e "display notification \"$ROLLBACK_CASK をインストールしました。\" with title \"CaptureStream2 Manager\""
    ;;
  "指定バージョンをアンインストール")
    version=$(read_version)
    ROLLBACK_CASK="capturestream2@${version}"
    brew uninstall --cask "$ROLLBACK_CASK"
    osascript -e "display notification \"$ROLLBACK_CASK をアンインストールしました。\" with title \"CaptureStream2 Manager\""
    ;;
  "最新版に戻す")
    version=$(read_version)
    ROLLBACK_CASK="capturestream2@${version}"
    brew uninstall --cask "$ROLLBACK_CASK"
    brew reinstall --cask "$LATEST_CASK"
    osascript -e "display notification \"$LATEST_CASK に戻しました。\" with title \"CaptureStream2 Manager\""
    ;;
  "利用可能なキャスク一覧")
    list_available_versions
    ;;
  "終了")
    exit 0
    ;;
esac