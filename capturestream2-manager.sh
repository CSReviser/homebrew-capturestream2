#!/bin/bash
# capturestream2-manager.sh（番号選択式ロールバック対応版）

# brew コマンドの存在を確認
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew がインストールされていません。"
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
  echo "7) 指定バージョンのアンインストール"
  echo "8) 最新版に戻す（ロールバック解除）"
  echo "9) 利用可能なキャスク一覧表示"
  echo "10) 終了"
  echo "====================================="
}

# 番号でバージョンを選ばせる関数
select_version() {
  echo "利用可能な CaptureStream2 バージョン一覧:"
  mapfile -t versions < <(brew search --cask capturestream2 | grep '^capturestream2@')

  if [ ${#versions[@]} -eq 0 ]; then
    echo "ロールバック可能なバージョンは見つかりませんでした。"
    exit 1
  fi

  for i in "${!versions[@]}"; do
    printf "%2d) %s\n" "$((i+1))" "${versions[$i]}"
  done

  read -rp "番号を選択してください: " index
  if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -lt 1 ] || [ "$index" -gt "${#versions[@]}" ]; then
    echo "無効な番号です。"
    exit 1
  fi

  echo "${versions[$((index-1))]}"
}

# 最新版キャスク名
LATEST_CASK="capturestream2"

# メインループ
while true; do
  show_menu
  read -rp "選択してください [1-10]: " choice
  case "$choice" in
    1) brew install --cask "$LATEST_CASK" ;;
    2) brew uninstall --cask "$LATEST_CASK" ;;
    3) brew upgrade --cask "$LATEST_CASK" ;;
    4) brew reinstall --cask "$LATEST_CASK" ;;
    5) brew list --cask ;;
    6)
      selected=$(select_version)
      brew install --cask "$selected"
      ;;
    7)
      selected=$(select_version)
      brew uninstall --cask "$selected"
      ;;
    8)
      echo "現在のインストール状況:"
      brew list --cask
      read -rp "ロールバック版のアンインストールを行いますか？ [y/N]: " ans
      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        selected=$(select_version)
        brew uninstall --cask "$selected"
      fi
      brew reinstall --cask "$LATEST_CASK"
      ;;
    9) brew search capturestream2 ;;
    10) echo "終了します。"; exit 0 ;;
    *) echo "1-10 の番号を入力してください。" ;;
  esac
done