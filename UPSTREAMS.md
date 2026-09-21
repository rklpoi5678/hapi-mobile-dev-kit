# Upstreams

This repository is not a fork of upstream projects.
It is a personal setup kit that installs and configures them.

## Tracked upstreams

### HAPI
- Repository: https://github.com/tiann/hapi
- Role: mobile/web remote control layer
- License: AGPL-3.0-only
- Local remote name: `hapi-upstream`

### OpenCode
- Repository: https://opencode.ai/
- Role: coding agent runtime used by HAPI
- Local remote name: `opencode-upstream` (optional)

## Update policy

When upstream changes:
1. check release notes / README / install docs
2. verify our Oracle setup still works
3. update scripts and docs in this repository
4. record tested versions in `VERSION_MATRIX.md`