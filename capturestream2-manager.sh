#!/bin/bash
# capturestream2-manager.sh
# CaptureStream2 管理スクリプト（対話/非対話両対応）

LATEST_CASK="capturestream2"

print_usage() {
  echo "使用方法:"
  echo "  $0 [--install | --uninstall | --upgrade | --reinstall | --list-installed |"
  echo "      --rollback VERSION | --unrollback VERSION | --reset VERSION | --list-available]"
  echo "  引数なしで起動すると対話モードになります。"
}

# CLI引数モード
if [[ $# -gt 0 ]]; then
  case "$1" in
    --install)
      brew install --cask "$LATEST_CASK"
      ;;
    --uninstall)
      brew uninstall --cask "$LATEST_CASK"
      ;;
    --upgrade)
      brew upgrade --cask "$LATEST_CASK"
      ;;
    --reinstall)
      brew reinstall --cask "$LATEST_CASK"
      ;;
    --list-installed)
      brew list --cask
      ;;
    --rollback)
      if [[ -z "$2" ]]; then
        echo "エラー: バージョン番号が指定されていません。"
        exit 1
      fi
      brew install --cask "capturestream2@$2"
      ;;
    --unrollback)
      if [[ -z "$2" ]]; then
        echo "エラー: バージョン番号が指定されていません。"
        exit 1
      fi
      brew uninstall --cask "capturestream2@$2"
      ;;
    --reset)
      if [[ -z "$2" ]]; then
        echo "エラー: バージョン番号が指定されていません。"
        exit 1
      fi
      brew uninstall --cask "capturestream2@$2"
      brew reinstall --cask "$LATEST_CASK"
      ;;
    --list-available)
      brew search capturestream2
      ;;
    --help|-h)
      print_usage
      ;;
    *)
      echo "不明なオプション: $1"
      print_usage
      exit 1
      ;;
  esac
  exit 0
fi

# === 対話モード ===

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

read_version() {
  read -rp "対象のバージョン番号を入力してください（例: 20250324）: " input_version
  if [ -z "$input_version" ]; then
    echo "バージョン番号が入力されなかったため、処理を中止します。"
    exit 1
  fi
  echo "$input_version"
}

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
      version=$(read_version)
      brew install --cask "capturestream2@$version"
      ;;
    7)
      version=$(read_version)
      brew uninstall --cask "capturestream2@$version"
      ;;
    8)
      version=$(read_version)
      brew uninstall --cask "capturestream2@$version"
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
      echo "無効な選択肢です。1-10 を選んでください。"
      ;;
  esac
done