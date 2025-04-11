#!/bin/bash

# .commandファイルの実行環境整備（ターミナルで実行されたと仮定）
cd "$(dirname "$0")"

# 実行スクリプト名
SCRIPT="./capturestream2-manager.sh"

# 実行可能か確認
if [ ! -x "$SCRIPT" ]; then
  chmod +x "$SCRIPT"
fi

# スクリプト実行
exec "$SCRIPT"