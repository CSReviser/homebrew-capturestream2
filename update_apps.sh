#!/bin/bash

# 更新対象のアプリ
CLI_APPS=("ffmpeg")  # CLIツール（Formula）
CASK_APPS=("capturestream2")  # GUIアプリ（Cask）

echo "🔄 Homebrew のデータベースを更新..."
brew update

# CLIツールのアップデート
for cli in "${CLI_APPS[@]}"; do
  echo "🚀 ツール '$cli' をアップデート中..."
  brew upgrade "$cli"
done

# GUIアプリのアップデート
for cask in "${CASK_APPS[@]}"; do
  echo "🚀 アプリ '$cask' をアップデート中..."
  brew upgrade --cask "$cask"
done

# Gatekeeper の制限を解除（GUIアプリのみ）
for cask in "${CASK_APPS[@]}"; do
  APP_PATH="/Applications/$(brew info --cask "$cask" | grep "/Applications/" | awk '{print $1}')"
  if [ -d "$APP_PATH" ]; then
    echo "🛠 Gatekeeper の制限を解除: $cask ($APP_PATH)"
    xattr -r -d com.apple.quarantine "$APP_PATH"
  else
    echo "⚠️ アプリ '$cask' のパスが見つかりません。"
  fi
done

echo "✅ すべてのアップデートが完了しました！"
