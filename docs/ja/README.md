# HAPI Mobile Dev Kit — 日本語

**ノート PC を起動したままにせず、スマートフォンから AI コーディングを続けるための個人開発環境**です。

目的はノート PC の遠隔操作ではありません。常時稼働する Linux サーバーでエージェントを動かし、HAPI から iPhone / Android で操作します。

> ここでいう「オフライン」は **ノート PC を起動しておく必要がない** という意味です。スマートフォンとサーバーにはネットワーク接続が必要です。

## 構成

```text
iPhone / Android / Browser
            ↓
           HAPI
            ↓
   常時稼働 Linux VM
            ↓
    HAPI Hub + Runner
            ↓
Claude Code · Codex · OpenCode
            ↓
       Git リポジトリ
```

Oracle Cloud VM はこの構成に向いた選択肢の一つです。常時稼働できる Linux ホストであれば利用できます。

## セットアップ

```bash
git clone https://github.com/rklpoi5678/hapi-mobile-dev-kit.git
cd hapi-mobile-dev-kit

./scripts/bootstrap-ubuntu.sh
./scripts/install-hapi-stack.sh
mkdir -p ~/projects
./scripts/install-services.sh ~/projects
./scripts/doctor.sh
```

利用したいエージェントもサーバーにインストールします。

```bash
npm install -g @openai/codex
npm install -g @anthropic-ai/claude-code
```

各エージェントはサーバー上で一度認証します。OpenCode は `install-hapi-stack.sh` で導入されます。

## スマートフォンから使う

1. HAPI の Web / ネイティブクライアントをペアリングします。
2. **New Session** を開きます。
3. サーバーを選択します。
4. `~/projects/<repo>` を選択します。
5. Claude Code / Codex / OpenCode など、インストール済みのエージェントを選びます。
6. 承認、ファイル操作、Git、実行結果はサーバー側で処理されます。

最初の確認には次のような小さなタスクで十分です。

```text
README.md を読み、無害な 1 行だけ変更して git diff を見せて。まだ commit はしないで。
```

## Skills · Plugins · MCP

HAPI はエージェントと同じサーバー環境から Skill を検出します。

```text
~/.agents/skills/      共通 Skill
~/.claude/skills/      Claude 専用
~/.codex/skills/       Codex 専用
```

リポジトリ内の `.agents/skills`、`.claude/skills`、`.codex/skills` もプロジェクトと一緒に管理できます。

Plugin と MCP は HAPI に重複して登録するのではなく、**各エージェント本来の設定で管理する**のが基本方針です。Claude Code / Codex 単体で動作確認してから、同じエージェントを HAPI から実行します。

```text
Agent CLI = 認証 · Skills · Plugins · MCP · Model
HAPI      = Remote session · Approval · Files · Mobile control
```

## Obsidian vs HAPI

役割は異なります。

**Obsidian**
- 長期的な記憶
- 企画 / 設計文書
- 調査メモ
- 会議記録
- RAG / ナレッジベース

**HAPI**
- エージェントの実行
- コード編集
- テスト / ターミナル
- 承認
- スマートフォンからのリモート開発

今後も Vault 全体を HAPI に複製するのではなく、**現在のタスクに必要なコンテキストだけをエージェントへ渡す**方向を優先します。

## Roadmap

### 1. Phone-first runtime
- Oracle / Linux の常時稼働
- systemd Hub + Runner
- Claude Code / Codex / OpenCode
- 診断スクリプト

### 2. Agent bootstrap
- 共通 Skills の自動配置
- Claude / Codex 設定の再現
- MCP 登録テンプレート
- Plugin のヘルスチェック

### 3. Knowledge bridge
- Obsidian を長期記憶・企画の source of truth とする
- HAPI は実行レイヤーに集中
- 必要な文書だけを task-scoped context として渡す
- Vault 全体の同期ではなく、必要に応じた RAG

### 4. Decision layer
`agent-decision-workbench` を HAPI の上に置く判断 / オーケストレーション層として接続します。

```text
User / Supervisor
      ↓
CAO orchestration
  ↙          ↘
Developer   Reviewer
      ↓
Jev Evaluate State
      ↓
Final decision / retry
```

Jev を HAPI に直接組み込むより、まず **MCP または CLI sidecar** として接続します。HAPI は実行と UI、Jev は曖昧な選択を評価する decision layer として分離します。

## Provider に関する注意

HAPI を疑う前に、対象の Agent CLI 単体で provider が正常に応答することを確認してください。Agent と provider 間の互換性問題は HAPI では解決できません。

## セキュリティ

- API Key や認証ファイルを Git にコミットしないでください。
- `~/.hapi`、`~/.claude`、`~/.codex` と provider の credential はサーバー側に保存します。
- 実プロジェクトは `~/projects` 以下に分離します。
- 特別な理由がなければ、まず HAPI 標準 Relay を利用します。
