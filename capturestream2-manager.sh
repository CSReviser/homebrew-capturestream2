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

# 最新版のキャスク名
LATEST_CASK="capturestream2"

# ロールバック用のキャスク名は capturestream2@<version> 形式で管理
# ユーザ入力でバージョン番号を取得する関数
read_version() {
  read -rp "対象のバージョン番号を入力してください（例: 20250324）: " input_version
  if [ -z "$input_version" ]; then
    echo "バージョン番号が入力されなかったため、処理を中止します。"
    exit 1
  fi
  echo "$input_version"
}

# 利用可能なキャスクの一覧表示
list_available_versions() {
  echo "利用可能な CaptureStream2 キャスクの一覧:"
  brew search capturestream2
}

# メインループ
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
      echo "最新版 ($LATEST_CASK) をアップグレード（再インストール）します..."
      brew reinstall --cask "$LATEST_CASK"
      ;;
    5)
      echo "インストール済みキャスクの一覧を表示します..."
      brew list --cask
      ;;
    6)
      # 指定バージョンのインストール（ロールバック）
      version=$(read_version)
      ROLLBACK_CASK="capturestream2@${version}"
      echo "ロールバック用キャスク ($ROLLBACK_CASK) をインストールします..."
      brew install --cask "$ROLLBACK_CASK"
      ;;
    7)
      # 指定バージョンのアンインストール
      version=$(read_version)
      ROLLBACK_CASK="capturestream2@${version}"
      echo "ロールバック用キャスク ($ROLLBACK_CASK) をアンインストールします..."
      brew uninstall --cask "$ROLLBACK_CASK"
      ;;
    8)
      # 最新版に戻す
      echo "現在のインストール状況を確認します:"
      brew list --cask
      echo ""
      echo "ロールバック用キャスクを個別にアンインストールしてから最新版に戻してください。"
      read -rp "ロールバック用キャスクのアンインストールを行いますか？ [y/N]: " ans
      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        version=$(read_version)
        ROLLBACK_CASK="capturestream2@${version}"
        brew uninstall --cask "$ROLLBACK_CASK"
      fi

      echo "最新版 ($LATEST_CASK) を再インストールします..."
      brew reinstall --cask "$LATEST_CASK"
      ;;
    9)
      # 利用可能なバージョンの一覧表示
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