#!/bin/bash
# capturestream2-manager.sh
# CaptureStream2 の管理スクリプト（最新版・過去バージョンのインストール、アンインストール、アップデート、ロールバックなど）

# brew コマンドの存在を確認
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew がインストールされていません。"
  exit 1
fi

# メニュー表示用関数
show_menu() {
  echo "====================================="
  echo "CaptureStream2 管理メニュー"
  echo "1) 最新版のインストール"
  echo "2) 最新版のアンインストール"
  echo "3) 最新版の更新（アップデート）"
  echo "4) 最新版のアップグレード（再インストール）"
  echo "5) インストール済みキャスクの一覧表示"
  echo "6) 指定バージョン（ロールバック版）のインストール"
  echo "7) 指定バージョン（ロールバック版）のアンインストール"
  echo "8) 最新版に戻す（ロールバック解除）"
  echo "9) 利用可能なキャスク（指定バージョン含む）の一覧表示"
  echo "10) 終了"
  echo "====================================="
}

LATEST_CASK="capturestream2"

select_version() {
  echo "利用可能なバージョンを取得中..."
  versions=($(brew search capturestream2 | grep -E '^csreviser/capturestream2/capturestream2@' | sed 's/.*@//'))
  if [ ${#versions[@]} -eq 0 ]; then
    echo "利用可能なバージョンが見つかりませんでした。"
    return 1
  fi

  echo "ロールバック可能なバージョン一覧:"
  for i in "${!versions[@]}"; do
    echo "$((i+1))) ${versions[$i]}"
  done

  read -rp "番号で選択してください (1-${#versions[@]}): " num
  if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#versions[@]}" ]; then
    SELECTED_VERSION="${versions[$((num-1))]}"
    return 0
  else
    echo "無効な選択肢です。"
    return 1
  fi
}

list_available_versions() {
  echo "利用可能な CaptureStream2 キャスクの一覧:"
  brew search capturestream2
}

while true; do
  show_menu
  read -rp "選択してください [1-10]: " choice
  case "$choice" in
    1)
      echo "最新版 ($LATEST_CASK) をインストールします..."
      brew install --cask "$LATEST_CASK"
      ;;
    2)
      echo "最新版 ($LATEST_CASK) をアンインストールします..."
      brew uninstall --cask "$LATEST_CASK"
      ;;
    3)
      echo "最新版 ($LATEST_CASK) を更新（アップデート）します..."
      brew upgrade --cask "$LATEST_CASK"
      ;;
    4)
      echo "最新版 ($LATEST_CASK) を再インストールします..."
      brew reinstall --cask "$LATEST_CASK"
      ;;
    5)
      echo "インストール済みキャスク一覧:"
      brew list --cask
      ;;
    6)
      if select_version; then
        echo "バージョン ${SELECTED_VERSION} をインストールします..."
        brew install --cask "capturestream2@${SELECTED_VERSION}"
      fi
      ;;
    7)
      if select_version; then
        echo "バージョン ${SELECTED_VERSION} をアンインストールします..."
        brew uninstall --cask "capturestream2@${SELECTED_VERSION}"
      fi
      ;;
    8)
      if select_version; then
        echo "ロールバックバージョン capturestream2@${SELECTED_VERSION} をアンインストールして最新版へ戻します..."
        brew uninstall --cask "capturestream2@${SELECTED_VERSION}"
        brew reinstall --cask "$LATEST_CASK"
      fi
      ;;
    9)
      list_available_versions
      ;;
    10)
      echo "終了します。"
      exit 0
      ;;
    *)
      echo "無効な選択肢です。1-10 を選んでください。"
      ;;
  esac
done