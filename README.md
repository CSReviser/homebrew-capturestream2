# homebrew-capturestream2

# CaptureStream2

CaptureStream2 は、macOS 向けのストリーミングキャプチャツールです。

## 🚀 インストール方法

### 1. Homebrew をインストール（未導入の場合）

Homebrew がインストールされていない場合は、次のコマンドを実行してください。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Apple Silicon (M1/M2) の場合

Apple Silicon の Mac では、Homebrew のインストール先が異なります。以下のコマンドでパスを確認してください。
```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Intel Mac の場合
```sh
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/usr/local/bin/brew shellenv)"
```

### 2. ffmpeg のインストール

CaptureStream2 の動作には ffmpeg が必要です。以下のコマンドでインストールしてください。

```sh
brew install ffmpeg
```

インストール後、以下のコマンドで ffmpeg が正しくインストールされているか確認できます。

```sh
ffmpeg -version
```

### 3. CaptureStream2 のインストール

Homebrew Tap を追加し、CaptureStream2 をインストールします。



```sh
brew tap username/capturestream2
brew install --cask capturestream2
```
インストール完了後、/Applications/CaptureStream2.app にアプリが追加されます。

## ⚠️ Gatekeeper の警告を回避する方法

CaptureStream2 は Apple の公証（Notarization）を受けていないため、初回起動時に Gatekeeper の警告が表示される可能性があります。その場合、以下の手順で回避できます。

方法 1: セキュリティ設定から許可
	1.	CaptureStream2.app を開こうとする
	2.	「開発元が未確認のため開けません」という警告が表示される
	3.	「システム設定」 → 「プライバシーとセキュリティ」 に移動
	4.	CaptureStream2 に対して「このまま開く」を選択

方法 2: ターミナルで Gatekeeper を無効化

以下のコマンドを実行すると、Gatekeeper の警告を回避できます。



```sh
xattr -r -d com.apple.quarantine /Applications/CaptureStream2.app
```

## 🚀 アンインストール

CaptureStream2 を削除するには、以下のコマンドを実行してください。
```sh
brew uninstall --cask capturestream2
```
また、Homebrew Tap を削除する場合は以下のコマンドを実行します。

```sh
brew untap username/capturestream2
```
## 📌 ライセンス
