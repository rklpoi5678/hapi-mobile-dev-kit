# Agent bootstrap

This directory is the portable source-of-truth for skills you want to reproduce on an Oracle/Linux HAPI host.

## Layout

```text
agents/
├─ shared-skills/       # → ~/.agents/skills
├─ claude/
│  └─ skills/           # → ~/.claude/skills
└─ codex/
   └─ skills/           # → ~/.codex/skills
```

## Workflow

1. Import existing local skills into this repository:

```bash
./scripts/import-local-skills.sh
```

2. Review the diff. Secrets/auth files are not copied.

3. Sync the bootstrap skills to Oracle:

```bash
ORACLE_HOST=ubuntu@YOUR_ORACLE_IP ./scripts/sync-skills-to-oracle.sh
```

4. Verify what the server sees:

```bash
ORACLE_HOST=ubuntu@YOUR_ORACLE_IP ./scripts/doctor-agent-env.sh
```
