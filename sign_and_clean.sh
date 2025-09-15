#!/bin/bash

# 引数チェック
if [ -z "$1" ]; then
  echo "⚠️ .appファイルをこのスクリプトにドラッグ＆ドロップしてください。"
  exit 1
fi

APP_PATH="$1"

# 属性削除
echo "🔧 Quarantine属性を削除中..."
xattr -dr com.apple.quarantine "$APP_PATH"

# ad hoc署名
echo "🔐 ad hoc署名を実行中..."
codesign --force --deep --sign - "$APP_PATH"

# 結果確認
echo "✅ 完了しました：$APP_PATH"
codesign -v "$APP_PATH" && echo "✔️ 署名確認OK" || echo "❌ 署名確認失敗"
