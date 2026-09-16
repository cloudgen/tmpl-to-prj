# Requirement ↔ test matrix — tmpl-to-prj

**Updated:** 2026-09-16  
**Product VERSION:** 1.3.0  
**Suite:** `tests/run.sh`  
**Last suite run:** PASS=254 FAIL=0 SKIP=0

| Requirement key | Area | TP families | Coverage notes |
|-----------------|------|-------------|----------------|
| requirement-class-software-dev | class | TP-CLI-01 | Syntax + stack residual; online Type 0; Termux residual |
| requirement-bootstrap-chain | architecture | TP-CLI-04,13; TP-LC-* | Origin selfmanaged; no backup/restore/sudoers verbs |
| requirement-project-folder | architecture | TP-LC-01 | src + published root ship unit + user bin |
| requirement-shell-cli-interface | shell | TP-CLI-*; TP-TMPL-TO-PRJ-11 | Commands, flags, dispatch; help lists testers apart |
| requirement-shell-cli-zero-arguments | shell | TP-CLI-07; TP-LC Type O | TTY menu; off-TTY Type O |
| requirement-shell-self-management | shell | TP-LC-* | install / version-check / self-update / self-uninstall |
| requirement-shell-automatic-checksum | shell | TP-CSUM / companion | sidecar match; CHECKSUM pin; missing sidecar |
| requirement-shell-output-requirements | shell | TP-CLI-03,05,08,09; TP-JSON-RAW-01 | JSON / quiet / errors |
| requirement-shell-modular-function-design | shell | (indirect) | `app_main` / `out_*` / `t2p_` |
| requirement-shell-script-coding | shell | TP-CLI-01, TP-CLI-11 | POSIX `/bin/sh`; `set -u` HOME; specialize-in home |
| requirement-shell-idempotency | shell | TP-LC re-install | Re-install already-installed |
| requirement-shell-interactive-vs-noninteractive | shell | TP-LC self-uninstall JSON | Confirm required |
| requirement-shell-cli-storage | shell | TP-CLI-12 | Isolation |
| requirement-shell-cli-default-interaction | shell | TP-TMPL-TO-PRJ-10, TP-CLI-17, TP-TMPL-TO-PRJ-19 | Off-TTY menu is help; TTY header APP_NAME(VERSION); picker **0** back |
| requirement-shell-sudo-command | shell | TP-TMPL-TO-PRJ-07, 14..16; TP-TX-06,07 | Observed verb-only vs sibling dest `backup *` vs unproven; skip sudo on Termux / Git Bash |
| requirement-shell-termux-ish | shell | TP-TX-01,02,06,07,08 | Empty `pkg` table; detect freeze |
| requirement-domain-tmpl-to-prj | domain | TP-TMPL-TO-PRJ-01..23; TP-TX-06 | Hop + folder-backup gate + unspecialized kit filter + picker back; dest specialized docs folders preserved; Termux local snapshot |
| requirement-actor-role-subject | architecture | (indirect) | Sibling dest is folder-backup sudoers file |

**Absent by design (no TP Core):** this product’s own backup/restore/print-sudoers emit; bare `uninstall` / `where-is-me`.
