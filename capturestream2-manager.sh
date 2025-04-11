#!/bin/bash
# capturestream2-manager.sh
# CaptureStream2 の管理スクリプト（番号選択式ロールバック対応）

LATEST_CASK="capturestream2"

# brew コマンドの存在確認
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew がインストールされていません。https://brew.sh/ja/ をご確認ください。"
  exit 1
fi

# メニュー表示
show_menu() {
  echo "====================================="
  echo "CaptureStream2 管理メニュー"
  echo "1) 最新版のインストール"
  echo "2) 最新版のアンインストール"
  echo "3) 最新版の更新（アップデート）"
  echo "4) 最新版のアップグレード（再インストール）"
  echo "5) インストール済みキャスクの一覧表示"
  echo "6) 指定バージョン（ロールバック）のインストール"
  echo "7) 指定バージョン（ロールバック）のアンインストール"
  echo "8) 最新版に戻す（ロールバック解除）"
  echo "9) 利用可能なキャスク一覧の表示"
  echo "10) 終了"
  echo "====================================="
}

# ロールバックバージョン選択
select_version() {
  echo "利用可能なロールバックバージョンを取得中..."
  versions=($(brew search capturestream2 | grep -E 'capturestream2@[0-9]{8}' | sed 's|.*/||'))

  if [ ${#versions[@]} -eq 0 ]; then
    echo "ロールバック可能なバージョンが見つかりませんでした。"
    exit 1
  fi

  echo "ロールバック可能なバージョン一覧:"
  for i in "${!versions[@]}"; do
    echo "$((i+1))) ${versions[$i]}"
  done

  read -rp "番号を選んでください [1-${#versions[@]}]: " choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#versions[@]} )); then
    echo "${versions[$((choice-1))]}"
  else
    echo "無効な選択です。"
    exit 1
  fi
}

# メインループ
while true; do
  show_menu
  read -rp "選択してください [1-10]: " choice
  case "$choice" in
    1)
      brew install --cask "$LATEST_CASK"
      ;;
    2)
      brew uninstall --cask "$LATEST_CASK"
      ;;
    3)
      brew upgrade --cask "$LATEST_CASK"
      ;;
    4)
      brew reinstall --cask "$LATEST_CASK"
      ;;
    5)
      brew list --cask
      ;;
    6)
      version=$(select_version)
      brew install --cask "$version"
      ;;
    7)
      version=$(select_version)
      brew uninstall --cask "$version"
      ;;
    8)
      version=$(select_version)
      brew uninstall --cask "$version"
      brew reinstall --cask "$LATEST_CASK"
      ;;
    9)
      brew search capturestream2
      ;;
    10)
      echo "終了します。"
      exit 0
      ;;
    *)
      echo "無効な選択肢です。"
      ;;
  esac
done