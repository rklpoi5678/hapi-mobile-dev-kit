# 日本語ガイド

このリポジトリは、**スマートフォン中心の個人向け AI コーディング環境**を再現するためのセットアップです。

ノート PC を遠隔操作するのではなく、常時稼働する Linux サーバー上で AI コーディングエージェントを実行し、HAPI から iPhone / Android で操作します。

## 構成

```text
iPhone / Android
      ↓
     HAPI
      ↓
常時稼働 Linux サーバー
      ↓
HAPI Hub + Runner
      ↓
OpenCode / Codex
      ↓
Alibaba / BytePlus Coding Plan
      ↓
Git リポジトリ
```

## インストール

```bash
./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

API キーはサーバーだけに保存し、Git にはコミットしないでください。

Alibaba の設定例は `config/opencode.alibaba.example.json` を参照してください。BytePlus は最新の公式 OpenCode 向け Coding Plan 設定を使用してください。

## モバイル

最初は HAPI PWA を推奨します。

- iPhone: Safari → 共有 → ホーム画面に追加
- Android: Chrome → アプリをインストール / ホーム画面に追加
