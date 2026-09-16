# Bootstrap specialize + requirements coverage — tmpl-to-prj

**Date:** 2026-09-16  
**Product VERSION:** 1.3.0  
**Claim:** C-full-product  
**Suite:** `tests/run.sh` PASS=254 FAIL=0 SKIP=0

## Direction

- Bootstrap origin **A:** sibling `selfmanaged` (read-only this turn)
- Specialized product **B:** `tmpl-to-prj`
- Direction **A → B only**. A was not overwritten.

## Keep / trim matrix

| Surface | Decision | Notes |
|---------|----------|-------|
| `out_*` / `inst_*` / `app_main` | Keep from A | Architecture inheritance |
| Online channel `SCRIPT_URL` | Keep from A; retarget to B | `cloudgen/tmpl-to-prj` |
| Automatic companion `.sha256` | Keep from A | `tmpl-to-prj.sha256` |
| `version-check` / `self-update` / `self-uninstall` | Keep from A | Type 0 |
| Off-TTY empty argv Type O | Keep from A | `curl \| sh` |
| TTY empty argv numbered menu | Keep from B | Domain default interaction |
| Domain `t2p_*` plan/apply | Keep from B | Injected at specializee anchors |
| `util_sudo` / Termux freeze | Keep from B | folder-backup compose |
| Bare `uninstall` / `where-is-me` | Trim | Online pair is `install` + `self-uninstall` |
| This product’s `backup` / `restore` / `print-sudoers` | Absent | Compose sibling `folder-backup` |

## Registry inventory (Step −1)

- Registered on disk: 18 `requirement-*.md` (match index)
- Orphans: none
- Ghosts: none
- Foreign candidates: none (notes retargeted to tmpl-to-prj; origin named as selfmanaged on purpose)

## Sufficient check (C-full-product)

| Surface | Class | Owner | Status |
|---------|-------|-------|--------|
| Config identity | lifecycle | ship unit Config | ok |
| Type 0 verbs | lifecycle | requirement-shell-cli-interface + self-management | ok |
| Empty argv hybrid | lifecycle | requirement-shell-cli-zero-arguments | ok |
| Automatic checksum | lifecycle | requirement-shell-automatic-checksum | ok |
| Domain plan/apply | domain | requirement-domain-tmpl-to-prj | ok |
| Sudo wrap | shell | requirement-shell-sudo-command | ok |
| Termux | shell | requirement-shell-termux-ish | ok |
| Class residual | class | requirement-class-software-dev | ok |
| Coding-style | shell | requirement-shell-script-coding | ok |
| Dual mention | CLI | interface + domain/self-management | ok |

**Verdict:** Sufficient for C-full-product after this specialize.

## Mold alignment (summary)

| Requirement | Law mold (primary cite) | Status |
|-------------|-------------------------|--------|
| class software-dev | LM-REQUIREMENT-CLASS-SOFTWARE-DEV | specialized |
| bootstrap-chain | LM-BOOTSTRAP-CHAIN (template-bootstrap-chain) | specialized |
| shell CLI interface | LM-CLI-INTERFACE | specialized |
| zero-arguments | LM-SHELL-CLI-ZERO-ARGUMENTS | specialized (hybrid) |
| self-management | LM-SELF-MANAGEMENT | specialized |
| automatic-checksum | LM-AUTOMATIC-CHECKSUM | specialized |
| output | LM-OUTPUT-REQUIREMENTS | specialized |
| modular | LM-SHELL-MODULAR-FUNCTION-DESIGN | specialized (`t2p_`) |
| domain tmpl-to-prj | no portable domain mold; PM-DOMAIN-TEST-PLAN | specialized |

## Reverse-copy

None. Sibling `selfmanaged` was not written.

## Verdict

**Pass** for specialize + coverage on disk after this change. Remaining polish: optional public-channel TP-CURL.
