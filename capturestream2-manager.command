#!/bin/bash
# CaptureStream2 GUI対応管理スクリプト（バージョン選択式ロールバック対応）

# Homebrew のインストール確認
if ! command -v brew >/dev/null 2>&1; then
  osascript -e 'display alert "エラー" message "Homebrew がインストールされていません。\nhttps://brew.sh/ja/ を参照してください。"'
  exit 1
fi

LATEST_CASK="capturestream2"

# 利用可能なバージョンを番号付きで取得
get_version_list() {
  mapfile -t versions < <(brew search capturestream2 | grep -E '^capturestream2@' | sort)
  choices=""
  for i in "${!versions[@]}"; do
    index=$((i + 1))
    choices+="$index: ${versions[$i]}\n"
  done
  echo -e "$choices"
}

# ユーザに番号選択でバージョンを選ばせる
choose_version() {
  local versions
  mapfile -t versions < <(brew search capturestream2 | grep -E '^capturestream2@' | sort)

  if [[ ${#versions[@]} -eq 0 ]]; then
    osascript -e 'display alert "エラー" message "利用可能なロールバックバージョンが見つかりません。"'
    exit 1
  fi

  formatted=$(get_version_list)
  version_choice=$(osascript <<EOF
set userChoice to text returned of (display dialog "番号でバージョンを選択してください:\n$formatted" default answer "")
return userChoice
EOF
)
  if [[ "$version_choice" =~ ^[0-9]+$ ]] && (( version_choice >= 1 && version_choice <= ${#versions[@]} )); then
    echo "${versions[$((version_choice - 1))]}"
  else
    osascript -e 'display alert "エラー" message "無効な選択です。"'
    exit 1
  fi
}

# GUIメニュー表示
CHOICE=$(osascript <<EOF
set options to {"最新版をインストール", "最新版をアンインストール", "最新版を更新", "最新版を再インストール", "インストール済みキャスクの一覧", "指定バージョンをインストール（ロールバック）", "指定バージョンをアンインストール", "最新版に戻す", "利用可能なバージョン一覧", "終了"}
set selectedOption to choose from list options with title "CaptureStream2 Manager" with prompt "実行する操作を選択してください" default items {"最新版をインストール"}
if selectedOption is false then return "終了"
return selectedOption as string
EOF
)

# メイン処理
case "$CHOICE" in
  "最新版をインストール")
    brew install --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版をインストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版をアンインストール")
    brew uninstall --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版をアンインストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版を更新")
    brew upgrade --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版を更新しました。" with title "CaptureStream2 Manager"'
    ;;
  "最新版を再インストール")
    brew reinstall --cask "$LATEST_CASK"
    osascript -e 'display notification "最新版を再インストールしました。" with title "CaptureStream2 Manager"'
    ;;
  "インストール済みキャスクの一覧")
    installed=$(brew list --cask | sed 's/^/・/')
    osascript -e "display alert \"インストール済みキャスク一覧\" message \"$installed\""
    ;;
  "指定バージョンをインストール（ロールバック）")
    version=$(choose_version)
    brew install --cask "$version"
    osascript -e "display notification \"$version をインストールしました。\" with title \"CaptureStream2 Manager\""
    ;;
  "指定バージョンをアンインストール")
    version=$(choose_version)
    brew uninstall --cask "$version"
    osascript -e "display notification \"$version をアンインストールしました。\" with title \"CaptureStream2 Manager\""
    ;;
  "最新版に戻す")
    version=$(choose_version)
    brew uninstall --cask "$version"
    brew reinstall --cask "$LATEST_CASK"
    osascript -e "display notification \"最新版に戻しました。\" with title \"CaptureStream2 Manager\""
    ;;
  "利用可能なバージョン一覧")
    list=$(brew search capturestream2 | sed 's/^/・/')
    osascript -e "display alert \"利用可能なバージョン一覧\" message \"$list\""
    ;;
  "終了")
    exit 0
    ;;
esac