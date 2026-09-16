# Test plan — tmpl-to-prj

Maps **TP-*** coverage to `tests/`.  
**Suite entry:** `./tests/run.sh`  
**Ship unit:** `src/tmpl-to-prj` (published `./tmpl-to-prj`)  
**Product VERSION:** 1.3.0  
**Last plan update:** 2026-09-16  
**Last suite run:** PASS=254 FAIL=0 SKIP=0 (2026-09-16)

Status: **have** = automated today · **todo** = needed · **optional** · **n/a** · **skip** (environment)

---

## Baseline coverage

| Area | Status | Evidence |
|------|--------|----------|
| Syntax `sh -n` | have | TP-CLI-01 |
| Companion digest matches ship unit | have | test_cli companion |
| version / help / about human + JSON | have | TP-CLI-02..06 |
| Off-TTY empty argv = Type O (fail closed on bad channel) | have | TP-CLI-07 |
| Unknown + quiet + set -u HOME | have | TP-CLI-08..11 |
| Storage isolation | have | TP-CLI-12 |
| Type 0 online verbs present; CHECKSUM not on help | have | TP-CLI-04 |
| Trimmed parent verbs fail closed | have | TP-CLI-13 |
| Main-menu header APP_NAME(VERSION) bold/italic | have | TP-CLI-17 |
| Online install / idempotent / version-check / self-update / self-uninstall | have | TP-LC-* |
| Companion checksum match / mismatch / pin | have | TP-CSUM |
| Backup / restore / sudoers emit | n/a | Absent by design |
| Domain harness-docs hop | have | TP-TMPL-TO-PRJ-01..23 |
| Termux target / normal-user-only | have | TP-TX-01,02,06,07,08 |

### TP-TMPL-TO-PRJ (domain)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-TMPL-TO-PRJ-01 | apply without names fails | `tests/test_domain_tmpl_to_prj.sh` | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-02 | missing template fails | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-03 | RAM-drive wins over hard-disk | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-04 | plan does not mutate dest | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-05 | apply keeps dest specialized docs folders and root README | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-06 | template requirements do not remain | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-07 | observed verb-only fails closed | test_domain | requirement-shell-sudo-command | **have** |
| TP-TMPL-TO-PRJ-08 | missing folder-backup uses local snapshot | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-09 | source equals dest fails | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-10 | off-TTY menu is help | test_domain | requirement-shell-cli-default-interaction | **have** |
| TP-TMPL-TO-PRJ-11 | help lists plan/apply and test-purpose apart | test_domain | requirement-shell-cli-interface | **have** |
| TP-TMPL-TO-PRJ-12 | list-templates numbered genesis kits | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-13 | list-projects current folder + PROJECTS_ROOT | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-14 | `backup *` at `T2P_SUDOERS_FILE` is pass | test_domain | requirement-domain-tmpl-to-prj · INC-20260902-001 | **have** |
| TP-TMPL-TO-PRJ-15 | `backup *` at sudoers.d `folder-backup-<user>` is pass | test_domain | requirement-shell-sudo-command · INC-20260902-001 | **have** |
| TP-TMPL-TO-PRJ-16 | missing dest is unproven, not verb-only | test_domain | requirement-domain-tmpl-to-prj · INC-20260902-001 | **have** |
| TP-TMPL-TO-PRJ-17 | specialized product / incidents / tests are not templates | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-18 | list-templates has no Back row | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-19 | TTY picker 0 returns to main menu (no duplicate 9 Back row) | test_domain | requirement-shell-cli-default-interaction | **have** |
| TP-TMPL-TO-PRJ-20 | dest incident bodies survive apply; kit incidents README is not dest SSOT | test_domain | requirement-domain-tmpl-to-prj · INC-20260910-001 | **have** |
| TP-TMPL-TO-PRJ-21 | dest with no incidents dir keeps template incidents placeholder | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-22 | dest filled checklists / whitelists / housekeeping / docs/reviews survive apply | test_domain | requirement-domain-tmpl-to-prj · INC-20260910-001 | **have** |
| TP-TMPL-TO-PRJ-23 | dest without those dirs keeps kit placeholders | test_domain | requirement-domain-tmpl-to-prj | **have** |

---

## TP rows

### TP-CLI (CLI surface)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CLI-01 | `sh -n` ship unit | `tests/test_cli.sh` | requirement-shell-cli-interface | **have** |
| TP-CLI-02 | version human | test_cli | requirement-shell-cli-interface | **have** |
| TP-CLI-03 | version JSON | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-04 | help Type 0 + domain; no backup/restore/sudoers; no CHECKSUM | test_cli | requirement-shell-cli-interface · bootstrap-chain | **have** |
| TP-CLI-05 | help JSON short | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-06 | about JSON storage + domain fields | test_cli | requirement-shell-cli-storage · domain | **have** |
| TP-CLI-07 | off-TTY empty argv Type O (bad channel non-zero) | test_cli | requirement-shell-cli-zero-arguments | **have** |
| TP-CLI-08 | unknown fail-closed | test_cli | requirement-shell-cli-interface | **have** |
| TP-CLI-09 | quiet suppresses version | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-11 | env -u HOME version | test_cli | class / defensive | **have** |
| TP-CLI-12 | storage isolation | test_cli | requirement-shell-cli-storage | **have** |
| TP-CLI-13 | backup/restore/sudoers verbs unknown | test_cli | requirement-bootstrap-chain · interface | **have** |
| TP-CLI-17 | TTY menu header `${APP_NAME}(${VERSION})` bold/italic | test_cli | requirement-shell-cli-default-interaction | **have** |
| TP-JSON-RAW-01 | `out_json` `@key` raw nested JSON | test_cli | requirement-shell-output-requirements | **have** |

### TP-LC (online lifecycle)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-LC-10 | `inst_maybe_install` JSON/QUIET helper | test_install_lifecycle | requirement-shell-self-management | **have** |
| TP-LC install | install → USER_BIN via local channel | test_install_lifecycle | requirement-shell-self-management | **have** |
| TP-LC idempotent | reinstall already-installed | test_install_lifecycle | requirement-shell-idempotency | **have** |
| TP-LC Type O | empty argv when installed = already-installed | test_install_lifecycle | requirement-shell-cli-zero-arguments | **have** |
| TP-LC version-check | local vs remote | test_install_lifecycle | requirement-shell-self-management | **have** |
| TP-LC self-update | already-latest + downgrade gate | test_install_lifecycle | requirement-shell-self-management | **have** |
| TP-LC self-uninstall | JSON no force fail-closed; --force removes | test_install_lifecycle | interactive-vs-noninteractive | **have** |
| TP-CSUM | companion PASS; CHECKSUM mismatch/match | test_install_lifecycle | requirement-shell-automatic-checksum | **have** |

### TP-TX (Termux / command line for normal user only)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-TX-01 | Not Termux-ish: stub `pkg` not invoked | `tests/test_termux.sh` | requirement-shell-termux-ish | **have** |
| TP-TX-02 | Termux mock: empty named list does not call `pkg` | test_termux | requirement-shell-termux-ish | **have** |
| TP-TX-03 | `pkg` missing → fail closed | — | requirement-shell-termux-ish | **n/a** (empty table) |
| TP-TX-04 | `pkg` non-zero → fail closed | — | requirement-shell-termux-ish | **n/a** (empty table) |
| TP-TX-06 | Termux detect: stub `sudo` / folder-backup not invoked | test_termux | requirement-shell-termux-ish · requirement-shell-sudo-command | **have** |
| TP-TX-07 | Git Bash `MSYSTEM`: stub `sudo` not invoked | test_termux | requirement-shell-sudo-command | **have** |
| TP-TX-08 | Termux `install --global` fails without recommending `sudo` | test_termux | requirement-shell-self-management | **have** |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have**.  
2. Do not mark TP **have** without a suite assertion (or honest skip/n/a).  
3. Online TP-CURL against the public GitHub channel is **optional** (local HTTP channel is Core).  
4. Do not add this product’s own `backup` / `restore` / `print-sudoers` verbs.
