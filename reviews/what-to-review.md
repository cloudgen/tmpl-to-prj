# What to review — tmpl-to-prj

**Living checklist** (review plan). Product: **tmpl-to-prj** POSIX `/bin/sh` CLI with a domain hop, local install, and channel self-management.  
**Project nature:** software-development · domain SSOT `requirement-domain-tmpl-to-prj` · local `install` plus channel `SCRIPT_URL` · **Termux** is a target.  
**Always load first:** `reviews/lessons.md`

**Last plan update:** 2026-10-04  
**Ship unit VERSION:** 1.5.1  
**Suite baseline:** see `reviews/test-plan.md`

---

## Pre-flight

| # | Check | Notes |
|---|--------|--------|
| P1 | Read `docs/requirements/index.md` | Class + architecture + shell + domain + Termux-ish |
| P2 | Confirm ship unit `src/tmpl-to-prj` | `APP_NAME` / `VERSION` hard-assign (**1.5.1**) |
| P3 | Load `reviews/lessons.md` and re-check open L-* that still apply | Skip L-SUDOERS / restore lessons as parent-only |
| P4 | Run `./tests/run.sh` | Record PASS/FAIL/SKIP in report |
| P5 | Confirm the channel is this product’s `SCRIPT_URL` | `help` lists self-install / self-update; `help` and `about` do not print `CHECKSUM` |
| P6 | Confirm trimmed verbs stay unknown | backup / restore / print-sudoers |

---

## Product law surfaces

| Surface | Path | Review focus |
|---------|------|--------------|
| Class | `requirement-class-software-dev.md` | posix-sh, local install and channel self-install, Termux OS family |
| Bootstrap chain | `requirement-bootstrap-chain.md` | selfmanaged → tmpl-to-prj (historical cli-template; do not reverse-copy) |
| Project folder | `requirement-project-folder.md` | `src/tmpl-to-prj`, bins; no `/var/backup` |
| CLI interface | `requirement-shell-cli-interface.md` | Commands, flags, dispatch |
| Empty argv | `requirement-shell-cli-zero-arguments.md` | TTY menu; off-TTY help |
| Local self-management | `requirement-shell-local-self-management.md` | install/uninstall; mode 0755 |
| Channel self-management | `requirement-shell-self-management.md` | version-check, self-update, self-uninstall |
| Channel place | `requirement-shell-cli-self-install.md` | self-install; copy when `$0` is the script |
| Companion digest | `requirement-shell-automatic-checksum.md` | `${SCRIPT_URL}.sha256`; pin not in help/about |
| Termux-ish | `requirement-shell-termux-ish.md` | Detect; empty `pkg` table; skip sudo |
| Output SSOT | `requirement-shell-output-requirements.md` | `out_*`; JSON errors |
| Modular design | `requirement-shell-modular-function-design.md` | `t2p_` domain prefix |
| Idempotency | `requirement-shell-idempotency.md` | Re-install |
| Storage | `requirement-shell-cli-storage.md` | Per-login per-process cache under `cache/`; silent tier miss; persistence `~/.local/${APP_NAME}` |
| Domain hop | `requirement-domain-tmpl-to-prj.md` | plan/apply; dest requirements **and** dest incidents preserved (L-T2P-INC-01) |

**Do not review as this product’s law:** folder-archive backup, restore dest whitelist, sudoers-file emit (those remain on sibling **folder-backup**).
