# Requirements index

**Product:** tmpl-to-prj (POSIX `/bin/sh` CLI — copy harness docs from a genesis template or subclass into a named project; local install plus channel self-management)  
**Workspace state:** Specialized product law (left genesis); **software-development** class; bootstrap **selfmanaged → tmpl-to-prj** (historical hop **cli-template**).  
**Updated:** 2026-10-04

| ID / key | Title | Area | Status | Path | Updated |
|----------|-------|------|--------|------|---------|
| requirement-class-software-dev | Software-development class law + residual stack (posix-sh, local install and channel self-install, Termux target) | class | Active (1.5.1) | `requirement-class-software-dev.md` | 2026-10-04 |
| requirement-bootstrap-chain | Bootstrap chain selfmanaged → tmpl-to-prj (historical cli-template) | architecture | Active (4.2.0) | `requirement-bootstrap-chain.md` | 2026-10-04 |
| requirement-project-folder | Project layout (`src/tmpl-to-prj`), install bins; cache leaves point at `requirement-shell-cli-storage`; no durable backup deposit | architecture | Active (2.2.0) | `requirement-project-folder.md` | 2026-09-27 |
| requirement-actor-role-subject | Light actor / role / subject catalog (no dest) | architecture | Active (1.0.0) | `requirement-actor-role-subject.md` | 2026-09-02 |
| requirement-shell-cli-interface | Shell CLI interface (Type 0 + plan/apply/menu + channel self-management; flags) | shell | Active (2.3.0) | `requirement-shell-cli-interface.md` | 2026-10-04 |
| requirement-shell-cli-zero-arguments | Empty argv: TTY menu; off-TTY help (Type N kept) | shell | Active (1.1.0) | `requirement-shell-cli-zero-arguments.md` | 2026-10-04 |
| requirement-shell-cli-default-interaction | Front menu 1 plan, 2 apply, 8 self-management, 9 Exit; board 82–87 and 0 Back; picker 0 | shell | Active (1.5.0) | `requirement-shell-cli-default-interaction.md` | 2026-10-04 |
| requirement-shell-local-self-management | Local install / uninstall / where-is-me; **mode 0755**; not an alias of self-install | shell | Active (1.5.0) | `requirement-shell-local-self-management.md` | 2026-10-04 |
| requirement-shell-self-management | Channel version-check, self-update, self-uninstall, about | shell | Active (1.0.0) | `requirement-shell-self-management.md` | 2026-10-04 |
| requirement-shell-cli-self-install | self-install (copy when $0 is the script; download when $0 is a shell); dest 0755/0700 | shell | Active (1.0.0) | `requirement-shell-cli-self-install.md` | 2026-10-04 |
| requirement-shell-automatic-checksum | Companion `${SCRIPT_URL}.sha256`; CHECKSUM pin not shown in help/about | shell | Active (1.0.0) | `requirement-shell-automatic-checksum.md` | 2026-10-04 |
| requirement-shell-output-requirements | Central `out_*` output SSOT | shell | Active | `requirement-shell-output-requirements.md` | 2026-08-13 |
| requirement-shell-modular-function-design | Single-file modular prefixes (`out_`/`inst_`/`app_`/`t2p_`) | shell | Active (2.1.0) | `requirement-shell-modular-function-design.md` | 2026-09-06 |
| requirement-shell-script-coding | POSIX sh coding style (specialize-in home) | shell | Active (1.0.1) | `requirement-shell-script-coding.md` | 2026-09-02 |
| requirement-shell-sudo-command | In-tool sudo wrap of sibling folder-backup backup (root or NOPASSWD only; no password prompt) | shell | Active (1.4.0) | `requirement-shell-sudo-command.md` | 2026-10-04 |
| requirement-shell-termux-ish | Termux target: detect, empty pkg table, skip sudo | shell | Active (1.0.0) | `requirement-shell-termux-ish.md` | 2026-09-06 |
| requirement-shell-idempotency | Re-run safety for install / uninstall | shell | Active (1.1.0) | `requirement-shell-idempotency.md` | 2026-08-13 |
| requirement-shell-interactive-vs-noninteractive | Interactive vs non-interactive / confirm policy | shell | Active (1.1.0) | `requirement-shell-interactive-vs-noninteractive.md` | 2026-08-13 |
| requirement-shell-cli-storage | Cache folder (Linux shm → tmp → `~/.cache`; Git Bash tmp → AppData; Mac tmp → Library/Caches → `~/cache`) and persistence `${HOME}/.local/${APP_NAME}`; silent tier miss | shell | Active (1.2.0) | `requirement-shell-cli-storage.md` | 2026-09-27 |
| requirement-domain-tmpl-to-prj | Domain SSOT: template-name / project-name harness-docs hop; dest specialized docs folders preserved; folder-backup only when root or NOPASSWD; a failed backup after pass is not a sudoers miss | domain | Active (1.7.1) | `requirement-domain-tmpl-to-prj.md` | 2026-10-04 |

## Intentionally absent (by design)

| Surface | Status on tmpl-to-prj |
|---------|------------------------|
| Type O empty-argv install-ensure | **Absent** — empty argv stays Type N (TTY menu, off-TTY help) |
| This product’s own `backup` / `restore` / `print-sudoers` verbs | **Absent** — compose sibling `folder-backup` |
| Three-layer privilege emit / dest approver | **Absent** |

**Install mode:** **dual**. Local `install` / `uninstall` / `where-is-me` (mode **0755**, no network) and channel `self-install` / `version-check` / `self-update` / `self-uninstall` (dest **0755** root / **0700** otherwise). `install` is not an alias of `self-install`. Matrix: `requirement-shell-self-management.md` §2.6.

**Rules for agents:**

1. Treat rows above as the **live product-law inventory** for tmpl-to-prj.  
2. **Do not invent** additional `requirement-*.md` paths — verify on disk and add a registry row in the same change when creating one.  
3. Product source comments cite **only** these live requirement files — never templates/skills as behavioral authority.  
4. This versioned surface lists **requirement rows only**.  
5. Keep Status and Path in sync with each file’s header when status changes.  
6. **Class gate:** software-development requires exactly one Active `requirement-class-software-dev.md`.  
7. **Domain SSOT:** exactly one Active `requirement-domain-*` (`requirement-domain-tmpl-to-prj`).  
8. Channel self-management is registered (user order 2026-10-04, bootstrap from selfmanaged). Do not remove it without a new user order. Do not turn empty argv into Type O. Do not alias `install` to `self-install`.

When adding a requirement: append a row, create the file under `docs/requirements/`, keep Status in sync with the file header.
