cask "CaptureStream2" do
  version "20250324"
  sha256 :no_check

  url "https://github.com/CSReviser/CaptureStream2/releases/download/20250324/CaptureStream2-MacOS-20250324.dmg"
  name "CaptureStream2"
  desc "これは MyApp の説明"
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