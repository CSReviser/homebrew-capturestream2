#!/bin/bash

echo "Homebrew を確認中..."
if ! command -v brew &>/dev/null; then
    echo "Homebrew が見つかりません。インストールを開始します..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "ffmpeg をインストール中..."
brew install ffmpeg

echo "CaptureStream2 をインストール中..."
brew install --cask capturestream2

echo "インストール完了！"