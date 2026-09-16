# Requirements index

**Product:** tmpl-to-prj (POSIX `/bin/sh` Type 0 self-managed CLI — copy harness docs from a genesis template or subclass into a named project)  
**Workspace state:** Specialized product law (left genesis); **software-development** class; bootstrap **selfmanaged → tmpl-to-prj**. Online install **present**.  
**Updated:** 2026-09-16

| ID / key | Title | Area | Status | Path | Updated |
|----------|-------|------|--------|------|---------|
| requirement-class-software-dev | Software-development class law + residual stack (posix-sh, online Type 0, Termux target) | class | Active | `requirement-class-software-dev.md` | 2026-09-16 |
| requirement-bootstrap-chain | Bootstrap chain selfmanaged → tmpl-to-prj | architecture | Active (5.0.0) | `requirement-bootstrap-chain.md` | 2026-09-16 |
| requirement-project-folder | Project layout (`src/tmpl-to-prj` + published `./tmpl-to-prj`); no durable backup deposit of this product | architecture | Active | `requirement-project-folder.md` | 2026-09-16 |
| requirement-actor-role-subject | Light actor / role / subject catalog (no dest) | architecture | Active (1.0.0) | `requirement-actor-role-subject.md` | 2026-09-02 |
| requirement-shell-cli-interface | Shell CLI interface (Type 0 + plan/apply/menu; flags) | shell | Active | `requirement-shell-cli-interface.md` | 2026-09-16 |
| requirement-shell-cli-zero-arguments | Empty argv: TTY menu; off-TTY Type O install-ensure | shell | Active | `requirement-shell-cli-zero-arguments.md` | 2026-09-16 |
| requirement-shell-cli-default-interaction | Numbered main menu (plan / apply; Exit 9); picker **0** back (one row); header **APP_NAME**(*VERSION*) | shell | Active | `requirement-shell-cli-default-interaction.md` | 2026-09-16 |
| requirement-shell-self-management | Self-management lifecycle (install, version-check, self-update, self-uninstall, about) | shell | Active | `requirement-shell-self-management.md` | 2026-09-16 |
| requirement-shell-automatic-checksum | Automatic companion-digest integrity (transparent link/value/result; CHECKSUM not help/about) | shell | Active | `requirement-shell-automatic-checksum.md` | 2026-09-16 |
| requirement-shell-output-requirements | Central `out_*` output SSOT | shell | Active | `requirement-shell-output-requirements.md` | 2026-09-16 |
| requirement-shell-modular-function-design | Single-file modular prefixes (`out_`/`inst_`/`app_`/`t2p_`) | shell | Active | `requirement-shell-modular-function-design.md` | 2026-09-16 |
| requirement-shell-script-coding | POSIX sh coding style (specialize-in home) | shell | Active | `requirement-shell-script-coding.md` | 2026-09-02 |
| requirement-shell-sudo-command | In-tool sudo wrap of sibling folder-backup backup | shell | Active | `requirement-shell-sudo-command.md` | 2026-09-06 |
| requirement-shell-termux-ish | Termux target: detect, empty pkg table, skip sudo | shell | Active | `requirement-shell-termux-ish.md` | 2026-09-06 |
| requirement-shell-idempotency | Re-run safety for install / uninstall | shell | Active | `requirement-shell-idempotency.md` | 2026-09-16 |
| requirement-shell-interactive-vs-noninteractive | Interactive vs non-interactive / confirm policy | shell | Active | `requirement-shell-interactive-vs-noninteractive.md` | 2026-09-16 |
| requirement-shell-cli-storage | Scratch/cache resolve (no backup staging) | shell | Active | `requirement-shell-cli-storage.md` | 2026-09-16 |
| requirement-domain-tmpl-to-prj | Domain SSOT: template-name / project-name harness-docs hop; dest specialized docs folders preserved | domain | Active (1.6.0) | `requirement-domain-tmpl-to-prj.md` | 2026-09-13 |

## Intentionally absent (by design)

| Surface | Status on tmpl-to-prj |
|---------|------------------------|
| This product’s own `backup` / `restore` / `print-sudoers` verbs | **Absent** — compose sibling `folder-backup` |
| Bare `uninstall` / `where-is-me` | **Absent** — online pair is `install` + `self-uninstall` |
| Three-layer privilege emit / dest approver | **Absent** |

**Install mode:** **online-installable** (`install` + `self-uninstall` + `self-update` + `version-check` + Type O off-TTY). Not dual-mode local-copy.

**Rules for agents:**

1. Treat rows above as the **live product-law inventory** for tmpl-to-prj.  
2. **Do not invent** additional `requirement-*.md` paths — verify on disk and add a registry row in the same change when creating one.  
3. Product source comments cite **only** these live requirement files — never templates/skills as behavioral authority.  
4. This versioned surface lists **requirement rows only**.  
5. Keep Status and Path in sync with each file’s header when status changes.  
6. **Class gate:** software-development requires exactly one Active `requirement-class-software-dev.md`.  
7. **Domain SSOT:** exactly one Active `requirement-domain-*` (`requirement-domain-tmpl-to-prj`).  
8. **Do not drop** online install without explicit user order and registry update.

When adding a requirement: append a row, create the file under `docs/requirements/`, keep Status in sync with the file header.
