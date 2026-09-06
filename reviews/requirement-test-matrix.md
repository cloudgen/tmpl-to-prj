# Requirement ↔ test matrix — tmpl-to-prj

**Updated:** 2026-09-06  
**Product VERSION:** 1.2.0  
**Suite:** `tests/run.sh`

| Requirement key | Area | TP families | Coverage notes |
|-----------------|------|-------------|----------------|
| requirement-class-software-dev | class | TP-CLI-01, TP-CLI-11 | Syntax + stack residual; no online package; Termux residual |
| requirement-bootstrap-chain | architecture | TP-CLI-04, TP-CLI-10, TP-CLI-13 | Online and domain/backup surfaces absent |
| requirement-project-folder | architecture | TP-LC-01 | src ship unit + user bin |
| requirement-shell-cli-interface | shell | TP-CLI-* | Commands, flags, dispatch |
| requirement-shell-cli-zero-arguments | shell | TP-CLI-07 | Type N help |
| requirement-shell-local-self-management | shell | TP-LC-* (incl. **09/10** mode) | install/uninstall/where-is-me; **0755** |
| requirement-shell-output-requirements | shell | TP-CLI-03,05,08,09 | JSON / quiet / errors |
| requirement-shell-modular-function-design | shell | (indirect) | no `fb_*`; `app_main` / `out_*` |
| requirement-shell-idempotency | shell | TP-LC-03,07 | Re-install / uninstall absent |
| requirement-shell-interactive-vs-noninteractive | shell | TP-LC-05 | Uninstall confirm |
| requirement-shell-cli-storage | shell | TP-CLI-12 | Isolation |
| requirement-shell-cli-default-interaction | shell | TP-TMPL-TO-PRJ-10, TP-CLI-17, TP-TMPL-TO-PRJ-19 | Off-TTY menu is help; TTY header APP_NAME(VERSION) bold/italic; picker **0** back (one row) |
| requirement-shell-sudo-command | shell | TP-TMPL-TO-PRJ-07, 14..16; TP-TX-06,07 | Observed verb-only vs sibling dest `backup *` vs unproven; skip sudo on Termux / Git Bash |
| requirement-shell-termux-ish | shell | TP-TX-01,02,06,07,08 | Empty `pkg` table; detect freeze |
| requirement-domain-tmpl-to-prj | domain | TP-TMPL-TO-PRJ-01..19; TP-TX-06 | Hop + folder-backup gate + unspecialized kit filter + picker back; Termux local snapshot |
| requirement-actor-role-subject | architecture | (indirect) | Sibling dest is folder-backup sudoers file |

**Absent by design (no TP Core):** online-install, remote self-management, automatic channel checksum, this product’s own backup/restore/print-sudoers emit.
