# Test plan — tmpl-to-prj

Maps **TP-*** coverage to `tests/`.  
**Suite entry:** `./tests/run.sh`  
**Ship unit:** `src/tmpl-to-prj`  
**Product VERSION:** 1.2.0  
**Last plan update:** 2026-09-06  
**Last suite run:** PASS=175 FAIL=0 SKIP=0 (2026-09-06)

Status: **have** = automated today · **todo** = needed · **optional** · **n/a** · **skip** (environment)

---

## Baseline coverage

| Area | Status | Evidence |
|------|--------|----------|
| Syntax `sh -n` | have | TP-CLI-01 |
| version / help / about human + JSON | have | TP-CLI-02..06 |
| Off-TTY empty argv = help | have | TP-CLI-07 |
| Unknown + quiet + set -u HOME | have | TP-CLI-08..11 |
| Storage isolation | have | TP-CLI-12 |
| No online verbs / no SCRIPT_URL UX | have | TP-CLI-04, TP-CLI-10 |
| Trimmed parent verbs fail closed | have | TP-CLI-13 |
| Main-menu header APP_NAME(VERSION) bold/italic | have | TP-CLI-17 |
| Local install / idempotent / uninstall / mode 0755 | have | TP-LC-01..10 |
| Backup / restore / sudoers emit | n/a | Absent by design (Type 0 template; not a backup product) |
| Online curl / companion checksum | n/a | Local-only product |
| Domain harness-docs hop | have | TP-TMPL-TO-PRJ-01..19 |
| Termux target / normal-user-only | have | TP-TX-01,02,06,07,08 |

### TP-TMPL-TO-PRJ (domain)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-TMPL-TO-PRJ-01 | apply without names fails | `tests/test_domain_tmpl_to_prj.sh` | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-02 | missing template fails | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-03 | RAM-drive wins over hard-disk | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-04 | plan does not mutate dest | test_domain | requirement-domain-tmpl-to-prj | **have** |
| TP-TMPL-TO-PRJ-05 | apply keeps dest requirements and root README | test_domain | requirement-domain-tmpl-to-prj | **have** |
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

---

## TP rows

### TP-CLI (CLI surface)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CLI-01 | `sh -n` ship unit | `tests/test_cli.sh` | requirement-shell-cli-interface | **have** |
| TP-CLI-02 | version human | test_cli | requirement-shell-cli-interface | **have** |
| TP-CLI-03 | version JSON | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-04 | help local verbs; no online; no backup/restore/sudoers | test_cli | requirement-shell-cli-interface · bootstrap-chain | **have** |
| TP-CLI-05 | help JSON short | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-06 | about JSON storage; no domain fields | test_cli | requirement-shell-cli-storage | **have** |
| TP-CLI-07 | off-TTY empty argv help | test_cli | requirement-shell-cli-zero-arguments | **have** |
| TP-CLI-08 | unknown fail-closed | test_cli | requirement-shell-cli-interface | **have** |
| TP-CLI-09 | quiet suppresses version | test_cli | requirement-shell-output-requirements | **have** |
| TP-CLI-10 | online verbs rejected | test_cli | requirement-bootstrap-chain | **have** |
| TP-CLI-11 | env -u HOME version | test_cli | class / defensive | **have** |
| TP-CLI-12 | storage isolation | test_cli | requirement-shell-cli-storage | **have** |
| TP-CLI-13 | backup/restore/sudoers verbs unknown | test_cli | requirement-bootstrap-chain · interface | **have** |
| TP-CLI-17 | TTY menu header `${APP_NAME}(${VERSION})` bold/italic | test_cli | requirement-shell-cli-default-interaction | **have** |

### TP-LC (local lifecycle)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-LC-01 | install → USER_BIN | test_local_lifecycle | requirement-shell-local-self-management | **have** |
| TP-LC-02 | installed binary version | test_local_lifecycle | local self-management | **have** |
| TP-LC-03 | reinstall already-installed | test_local_lifecycle | requirement-shell-idempotency | **have** |
| TP-LC-04 | where-is-me | test_local_lifecycle | local self-management | **have** |
| TP-LC-05 | uninstall JSON no force fail-closed | test_local_lifecycle | interactive-vs-noninteractive | **have** |
| TP-LC-06 | uninstall --force removes | test_local_lifecycle | local self-management | **have** |
| TP-LC-07 | uninstall absent no-op | test_local_lifecycle | idempotency | **have** |
| TP-LC-08 | about shows installed | test_local_lifecycle | local self-management | **have** |
| TP-LC-09 | installed mode is `0755` | test_local_lifecycle | local self-management §2.3.1 | **have** |
| TP-LC-10 | reinstall without force heals `0711` → `0755` | test_local_lifecycle | local self-management §2.3.1 | **have** |

### TP-TX (Termux / command line for normal user only)

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-TX-01 | Not Termux-ish: stub `pkg` not invoked | `tests/test_termux.sh` | requirement-shell-termux-ish | **have** |
| TP-TX-02 | Termux mock: empty named list does not call `pkg` | test_termux | requirement-shell-termux-ish | **have** |
| TP-TX-03 | `pkg` missing → fail closed | — | requirement-shell-termux-ish | **n/a** (empty table) |
| TP-TX-04 | `pkg` non-zero → fail closed | — | requirement-shell-termux-ish | **n/a** (empty table) |
| TP-TX-06 | Termux detect: stub `sudo` / folder-backup not invoked | test_termux | requirement-shell-termux-ish · requirement-shell-sudo-command | **have** |
| TP-TX-07 | Git Bash `MSYSTEM`: stub `sudo` not invoked | test_termux | requirement-shell-sudo-command | **have** |
| TP-TX-08 | Termux `install --global` fails without recommending `sudo` | test_termux | requirement-shell-local-self-management | **have** |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have**.  
2. Do not mark TP **have** without a suite assertion (or honest skip/n/a).  
3. Do not reintroduce online TP-CURL/TP-CSUM or TP-FOLDER-BACKUP as Core without product-mode change.  
4. Do not add domain TP families or a `setup` verb — this product is Type 0 only.
