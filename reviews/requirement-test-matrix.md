# Requirement ↔ test matrix — tmpl-to-prj

**Updated:** 2026-10-04  
**Product VERSION:** 1.5.1  
**Suite:** `tests/run.sh`

| Requirement key | Area | TP families | Coverage notes |
|-----------------|------|-------------|----------------|
| requirement-class-software-dev | class | TP-CLI-01, TP-CLI-11 | Syntax + stack residual; Termux residual |
| requirement-bootstrap-chain | architecture | TP-CLI-04, TP-CLI-10, TP-CLI-13 | Channel verbs present; backup/restore/print-sudoers absent |
| requirement-project-folder | architecture | TP-LC-01 | src ship unit + user bin |
| requirement-shell-cli-interface | shell | TP-CLI-* | Commands, flags, dispatch |
| requirement-shell-cli-zero-arguments | shell | TP-CLI-07 | Type N help |
| requirement-shell-local-self-management | shell | TP-LC-* (incl. **09/10** mode) | install/uninstall/where-is-me; **0755** |
| requirement-shell-self-management | shell | TP-CLI-04, TP-CLI-10, TP-CLI-30 | version-check, self-update, self-uninstall |
| requirement-shell-cli-self-install | shell | TP-CLI-29, TP-CLI-30 | copy when `$0` is the script (0700); channel replace |
| requirement-shell-automatic-checksum | shell | TP-CLI-04, TP-CLI-06 | `CHECKSUM` absent from help and about |
| requirement-shell-output-requirements | shell | TP-CLI-03,05,08,09 | JSON / quiet / errors |
| requirement-shell-modular-function-design | shell | (indirect) | no `fb_*`; `app_main` / `out_*` |
| requirement-shell-idempotency | shell | TP-LC-03,07 | Re-install / uninstall absent |
| requirement-shell-interactive-vs-noninteractive | shell | TP-LC-05 | Uninstall confirm |
| requirement-shell-cli-storage | shell | TP-CLI-06, TP-CLI-12 | Per-login per-process cache leaves; silent tier miss; persistence `${HOME}/.local/${APP_NAME}` |
| requirement-shell-cli-default-interaction | shell | TP-TMPL-TO-PRJ-10, TP-CLI-17, TP-CLI-26..28, TP-TMPL-TO-PRJ-19 | Front 1/2/8/9; board 82–87 and 0 Back; picker **0** back |
| requirement-shell-sudo-command | shell | TP-TMPL-TO-PRJ-07, 14..16, 24..25; TP-TX-06,07 | Observed verb-only vs sibling dest `backup *` vs unproven; TTY does not password-prompt; skip sudo on Termux / Git Bash |
| requirement-shell-termux-ish | shell | TP-TX-01,02,06,07,08 | Empty `pkg` table; detect freeze |
| requirement-domain-tmpl-to-prj | domain | TP-TMPL-TO-PRJ-01..26; TP-TX-06 | Hop + folder-backup gate (root or NOPASSWD; missing binary skips) + unspecialized kit filter + picker back; dest specialized docs folders preserved; Termux local snapshot; pass-gate backup failure is not a sudoers miss |
| requirement-actor-role-subject | architecture | (indirect) | Sibling dest is folder-backup sudoers file |

**Absent by design (no TP Core):** this product’s own backup/restore/print-sudoers emit. Channel place and the companion digest are in scope (TP-CLI-04, 10, 29, 30).
