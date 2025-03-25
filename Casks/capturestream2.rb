cask "CaptureStream2" do
  version "20250324"
  sha256 :no_check

  url "https://github.com/CSReviser/CaptureStream2/releases/download/20250324/CaptureStream2-MacOS-20250324.dmg"
  name "CaptureStream2"
  desc "語学講座CS2は、NHKラジオ語学講座の「らじる★らじる」（聴き逃し）ストリーミング配信を自動録音するためのアプリです。録音した語学講座のファイルは、著作権法で認められた範囲内でご利用ください。"
  homepage "https://csreviser.github.io/CaptureStream2/"

  app "MacCaptureStream2/CaptureStream2.app"

  # Gatekeeper 警告を回避
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-r", "-d", "com.apple.quarantine", "#{staged_path}/CaptureStream2.app"],
                   sudo: false
  end

  caveats <<~EOS
    このアプリは署名されていないため、macOS のセキュリティ設定によっては最初の実行時に警告が出る場合があります。
    警告が出た場合は、以下のコマンドを手動で実行してください:

      xattr -r -d com.apple.quarantine /Applications/CaptureStream2.app

    または、システム環境設定 → セキュリティとプライバシー → 一般 から「このまま開く」を選択してください。
  EOS
end