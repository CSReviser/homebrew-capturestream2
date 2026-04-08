cask "capturestream2" do
  version "20260407"
  sha256 :no_check  # バージョン管理されていない場合は no_check、リリースごとに更新するなら sha256 を入れる

  # デフォルトのURL（ universal 最新）
  url "https://github.com/CSReviser/CaptureStream2/releases/download/#{version}/CaptureStream2-MacOS-#{version}.dmg"

  # macOS 13 (Ventura) 以上 → Qt6.11（最新 universal）
  on_ventura :or_newer do
    url "https://github.com/CSReviser/CaptureStream2/releases/download/#{version}/CaptureStream2-MacOS-#{version}.dmg"
  end

  # macOS 11–12 → Qt6.5
  on_big_sur do
    url "https://github.com/CSReviser/CaptureStream2/releases/download/#{version}/CaptureStream2-MacOS-qt6-5-#{version}.dmg"
  end

  on_monterey do
    url "https://github.com/CSReviser/CaptureStream2/releases/download/#{version}/CaptureStream2-MacOS-qt6-5-#{version}.dmg"
  end

  # macOS 10.14 / 10.15 → Qt6.2
  on_catalina :or_older do
    url "https://github.com/CSReviser/CaptureStream2/releases/download/#{version}/CaptureStream2-MacOS-qt6-2-#{version}.dmg"
  end

  name "CaptureStream2"
  desc "語学講座CS2は、NHKラジオ語学講座の「らじる★らじる」（聴き逃し）ストリーミング配信を自動録音するためのアプリです。録音した語学講座のファイルは、著作権法で認められた範囲内でご利用ください。"
  homepage "https://csreviser.github.io/CaptureStream2/"
  
  depends_on formula: "ffmpeg"  # ffmpeg を推奨
  
  app "MacCaptureStream2/CaptureStream2.app"

  # Gatekeeper 警告を回避
  postflight do
    # Gatekeeperの隔離属性を削除
    system_command "/usr/bin/xattr",
                   args: ["-r", "-d", "com.apple.quarantine", "#{appdir}/CaptureStream2.app"],
                   sudo: false,
                   print_stderr: true,
                   print_stdout: true

    # ad hoc署名を付与（Apple Developer ID不要）
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", "#{appdir}/CaptureStream2.app"],
                   sudo: false,
                   print_stderr: true,
                   print_stdout: true
  end

  caveats <<~EOS
    ⚠️ このアプリは署名されていないため、macOS のセキュリティ設定によっては最初の実行時に警告が出る場合があります。

    ❗️ 警告が出た場合は、以下のいずれかの方法で解除してください:

    ✅ **方法 1: ターミナルで解除**
      以下のコマンドを実行してください:

        xattr -r -d com.apple.quarantine /Applications/CaptureStream2.app

    ✅ **方法 2: システム設定から許可**
      1. CaptureStream2.app を開こうとする
      2. 「開発元が未確認のため開けません」という警告が出たら閉じる
      3. **「システム設定」 → 「プライバシーとセキュリティ」** を開く
      4. 「このまま開く」を選択

    📝 詳細なインストール手順は公式サイトをご覧ください:
       https://csreviser.github.io/CaptureStream2/
  EOS
end
