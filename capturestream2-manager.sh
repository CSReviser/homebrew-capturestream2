#!/bin/bash
# capturestream2-manager.sh
# 対話型で CaptureStream2 の操作（最新版・バージョン指定版のインストール/アンインストール、ロールバック、利用可能なバージョン表示）を実行するスクリプト

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
  echo "3) インストール済みキャスクの一覧表示"
  echo "4) 指定バージョン（ロールバック版）のインストール"
  echo "5) 指定バージョン（ロールバック版）のアンインストール"
  echo "6) 最新版に戻す（ロールバック解除）"
  echo "7) 利用可能なキャスク（指定バージョン含む）の一覧表示"
  echo "8) 終了"
  echo "====================================="
}

# 最新版のキャスク名（通常は capturestream2）
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

# 利用可能なキャスクの一覧表示（brew search を使用）
list_available_versions() {
  echo "利用可能な CaptureStream2 キャスクの一覧:"
  brew search capturestream2
}

# メインループ
while true; do
  show_menu
  read -rp "選択してください [1-8]: " choice
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
      echo "インストール済みキャスクの一覧を表示します..."
      brew list --cask
      ;;
    4)
      # ロールバック用のバージョン指定キャスクのインストール
      version=$(read_version)
      ROLLBACK_CASK="capturestream2@${version}"
      echo "ロールバック用キャスク ($ROLLBACK_CASK) をインストールします..."
      brew install --cask "$ROLLBACK_CASK"
      ;;
    5)
      # ロールバック用キャスクのアンインストール
      version=$(read_version)
      ROLLBACK_CASK="capturestream2@${version}"
      echo "ロールバック用キャスク ($ROLLBACK_CASK) をアンインストールします..."
      brew uninstall --cask "$ROLLBACK_CASK"
      ;;
    6)
      # 最新版に戻す手順：アンインストール済みか確認し、最新版を再インストール
      echo "最新版に戻すため、以下の手順を実行します。"
      echo "まず、現在のインストール状況を確認します:"
      brew list --cask
      echo ""
      echo "最新版とバージョン指定キャスクが混在している場合、ロールバック用キャスクを個別にアンインストールしてください。"
      read -rp "最新版 ($LATEST_CASK) を再インストールするため、最新版キャスクのアンインストールを実行しますか？ [y/N]: " ans
      if [[ "$ans" =~ ^[Yy]$ ]]; then
        brew uninstall --cask "$LATEST_CASK"
      fi
      echo "最新版 ($LATEST_CASK) を再インストールします..."
      brew install --cask "$LATEST_CASK"
      ;;
    7)
      echo "終了します。"
      exit 0
      ;;
    *)
      echo "無効な選択です。1から7の数字を入力してください。"
      ;;
  esac
  echo ""
  read -rp "Enterキーを押してメニューに戻ります..."
done
     