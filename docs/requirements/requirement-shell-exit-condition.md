**file**: docs/requirements/requirement-shell-exit-condition.md  
**Status**: Active (Version 1.0.3)  
**Area**: shell  
**Key**: `requirement-shell-exit-condition`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the catalog of every condition that ends the tmpl-to-prj process. It names the exit function, the status, and the error message for each condition. Output law owns how a line is printed. This file owns when the process stops.

### 1.1 Human-facing

**In one sentence:** When this program stops because something failed, it prints one `[ERROR]` line and leaves with status 1; a finished command or menu Exit leaves with status 0 and no error line.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Person reading the terminal | `tmpl-to-prj nosuch` |
| The other role | A script that checks `$?` | `tmpl-to-prj --json nosuch` |
| Not this file | How colors and JSON are formatted | `requirement-shell-output-requirements` |

| Includes | Excludes |
|----------|----------|
| `out_die` and every `return 1` that becomes the process status | A `[WARN]` that continues the same command |
| Menu Exit (status 0) | A bad menu number, which reprints the menu |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tmpl-to-prj` | ship unit | `out_die` and the messages below |
| `tmpl-to-prj help` | command | verbs that can end the process |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Pass a name this program does not know | The process prints `[ERROR]` and stops. Status is 1. The next step is in the message. | `tmpl-to-prj nosuch` |

---

## 2. Core Rules / Requirements (Mandatory)

1. The ship unit **MUST** set `set -u` and **MUST NOT** set global `set -e`. A failed command **MUST NOT** end the process unless a row below says so.  
2. The only product function that calls `exit` is `out_die`. Its body **MUST** stay: call `out_json_error` with the message, call `out_text` for the error line, then `exit 1`. **MUST NOT** add `exit 0`, `exit 2`, or a second `exit` helper.  
3. Human mode (`JSON=0`): `out_die` **MUST** print `[ERROR] <message>` on stderr, then status 1. Quiet mode still prints that line.  
4. JSON mode (`JSON=1`): `out_die` **MUST** print one stderr object `{"type":"out_error","message":"<message>","code":"unknown"}` and **MUST NOT** print the human `[ERROR]` line. Status is still 1. `out_die` does not pass a code, so the code field stays `unknown`.  
5. A direct command (and non-interactive empty argv, which places the CLI) **MUST** end the process with the status of that command. `return 1` after `out_error` or `out_json_error` is status 1. `return 0` is status 0.  
6. The TTY menu **MUST** end the process with status 0 on choice `9`, `99`, `exit`, `quit`, `Exit`, `QUIT`, an empty line, or end of input. A bad menu number **MUST** `out_error` and read again. It **MUST NOT** call `out_die`.  
7. `out_die` ends the process even when the call comes from the menu. A `return 1` that is not `out_die` does not leave the menu.  
8. Every new `out_die` message and every new `return 1` error message **MUST** add a row to the tables in the same change. A row **MUST** name the condition, the function, the status, and the message text.  
9. A condition this law marks “continue” **MUST NOT** call `out_die` and **MUST NOT** `return 1`.  
10. This product does not install a SIGINT trap and does not define status 130.

### 2.1 Implementation Notes (this project)

Ship unit: `src/tmpl-to-prj`. Exit function:

```sh
out_die() { out_json_error "$*"; out_text out_error "$*"; exit 1; }
```

`app_main "$@"` is the last command of the script. Its return status is the process status unless `out_die` already called `exit 1`.

#### Exit function rows (`out_die`, status 1)

The message is the human `[ERROR]` text. In JSON mode the same text is the `message` field and `code` is `unknown`.

| ID | Condition | Function | Message |
|----|-----------|----------|---------|
| EX-DIE-01 | Resolved persistence directory is `~/.local/bin` | `util_resolve_persistent_storage` | `Persistence storage must not be the install bin directory <path>` |
| EX-DIE-02 | Persistence directory cannot be created or is not writable | `util_resolve_persistent_storage` | `Cannot create persistence storage <path>` |
| EX-DIE-03 | Every cache tier failed | `util_resolve_storage` | `Cannot create cache folder` |
| EX-DIE-04 | `util_mktemp` suffix contains `$$` | `util_mktemp` | `util_mktemp: refuse predictable $$ name template` |
| EX-DIE-05 | `CHECKSUM` is set, human mode, downloaded bytes do not match | `inst_perform_install_download_with_checksum` | `Checksum verification failed. The downloaded file does not match the provided CHECKSUM. Installation aborted for security.` |
| EX-DIE-06 | Human mode, companion `${SCRIPT_URL}.sha256` was fetched and does not match (curl or wget) | `inst_perform_install_download_without_checksum` | `Checksum verification failed (mismatch with <SCRIPT_URL>.sha256). Installation aborted for security.` |
| EX-DIE-07 | Local `install` cannot resolve the running file | `inst_local_install` | `Cannot resolve running ship unit path for local install (not a file path).` |
| EX-DIE-08 | `mkdir` of `GLOBAL_BIN` failed on Termux, Git Bash, or Windows cmd | `inst_local_install` | `Cannot create <GLOBAL_BIN> on a command line for normal user only (Termux / Git Bash / Windows cmd). Next: <APP_NAME> install  (user bin <USER_BIN>) — do not use sudo.` |
| EX-DIE-09 | `mkdir` of `GLOBAL_BIN` failed and this login is not that class | `inst_local_install` | `Cannot create <GLOBAL_BIN> (need root). Run: sudo <APP_NAME> install   or: sudo sh <ship-unit> install` |
| EX-DIE-10 | `mkdir` of the user install directory failed | `inst_local_install` | `Cannot create install directory <dir>` |
| EX-DIE-11 | `GLOBAL_BIN` is not writable on Termux, Git Bash, or Windows cmd | `inst_local_install` | `Cannot write <GLOBAL_BIN> on a command line for normal user only (Termux / Git Bash / Windows cmd). Next: <APP_NAME> install  (user bin <USER_BIN>) — do not use sudo.` |
| EX-DIE-12 | `GLOBAL_BIN` is not writable and this login is not that class | `inst_local_install` | `Cannot write <GLOBAL_BIN> (need root). Run: sudo <APP_NAME> install   or: sudo sh <ship-unit> install --global` |
| EX-DIE-13 | User install directory is not writable | `inst_local_install` | `Install directory not writable: <dir>` |
| EX-DIE-14 | Copy into the install stage failed | `inst_local_install` | `Failed to stage ship unit for install` |
| EX-DIE-15 | `chmod` of the staged file failed | `inst_local_install` | `Failed to chmod <mode> staged ship unit` |
| EX-DIE-16 | Move of the staged file onto the install path failed | `inst_local_install` | `Failed to install to <path>` |
| EX-DIE-17 | `chmod` of the installed file failed | `inst_local_install` | `Installed <path> but failed to set mode <mode>` |
| EX-DIE-18 | Installed file is not readable and executable | `inst_local_install` | `Installed <path> is not readable+executable (mode heal failed)` |
| EX-DIE-19 | Local `uninstall` without `--force` when JSON, quiet, or not a TTY | `inst_local_uninstall` | `Uninstall requires confirmation. Re-run with --force in non-interactive mode.` |
| EX-DIE-20 | `rm` of the local install path failed | `inst_local_uninstall` | `Failed to remove <path>` |
| EX-DIE-21 | `util_sudo` was called when this login is not root, the no-sudo fixture is off, `sudo` exists, and NOPASSWD was not proven. A normal unproven apply does **not** call this function | `util_sudo` | `folder-backup is installed but backup * was not proven for this login (not root, and no NOPASSWD sudoers right for folder-backup backup *). Next: use folder-backup to submit a request and create a sudoer file fragment for backup (folder-backup print-sudoers, then folder-backup generate-sudoer-request, then folder-backup submit-sudoer-request).` |
| EX-DIE-22 | TTY template picker list is empty | `t2p_pick_template` | `No genesis-template (or subclass) found under <RAM>, <PROJECTS_ROOT>, or the current folder. Next: <APP_NAME> apply --template NAME --project NAME` |
| EX-DIE-23 | TTY project picker list is empty | `t2p_pick_project` | `No project folder found (current directory or <PROJECTS_ROOT>). Next: <APP_NAME> apply --template NAME --project NAME` |
| EX-DIE-24 | `plan` or `apply` still has no template-name or project-name (no TTY picker) | `t2p_ensure_names` | `template-name and project-name are required. Next: <APP_NAME> apply <template-name> <project-name> (TTY menu also lists templates and projects by number)` |
| EX-DIE-25 | template-name does not resolve | `t2p_preflight` | `template-name '<name>' was not found as a RAM-drive or hard-disk project. Next: create it, or pass an existing directory.` |
| EX-DIE-26 | project-name does not resolve | `t2p_preflight` | `project-name '<name>' was not found as a RAM-drive or hard-disk project. Next: create it, or pass an existing directory.` |
| EX-DIE-27 | Template root is home, `/`, `/home`, `/dev`, or the RAM mount | `t2p_preflight` | `template root is a refused path. Next: name a project folder, not home or /.` |
| EX-DIE-28 | Project root is one of those refused paths | `t2p_preflight` | `project root is a refused path. Next: name a project folder, not home or /.` |
| EX-DIE-29 | Both names resolve to the same directory | `t2p_preflight` | `template-name and project-name resolved to the same folder. Next: pick two different names.` |
| EX-DIE-30 | Template is not an unspecialized kit | `t2p_preflight` | `template '<name>' is not a genesis-template (or subclass) kit (needs docs/README.md, 0 requirement-*.md, no incident bodies, no product tests). Next: pick an unspecialized kit.` |
| EX-DIE-31 | Project path is not a directory | `t2p_preflight` | `project '<name>' is not a directory. Next: name an existing folder.` |
| EX-DIE-32 | Local dest-docs snapshot copy failed | `t2p_local_docs_snapshot` | `Could not snapshot dest docs. Next: check write access on the project folder.` |
| EX-DIE-33 | **Withdrawn** (2026-10-14, **INC-20261014-001** revised). Gate was pass and `folder-backup backup` exited non-zero. That path is EX-CONT-06 or EX-CONT-07. Do not print this message. Do not exit before overlay | `t2p_backup_dest` | *(withdrawn)* `folder-backup backup failed. The gate already passed, so this is not a sudoers argv miss. Next: read the folder-backup error above and re-run apply after that backup succeeds.` |
| EX-DIE-34 | Cannot move dest `docs/requirements` aside | `t2p_overlay_docs` | `Could not move dest docs/requirements aside. Next: check write access.` |
| EX-DIE-35 | Cannot move dest `docs/incidents`, `checklists`, `whitelists`, `housekeeping`, or `reviews` aside | `t2p_overlay_docs` | `Could not move dest docs/<name> aside. Next: check write access.` |
| EX-DIE-36 | Cannot remove dest `docs` after the aside moves | `t2p_overlay_docs` | `Could not remove dest docs after saving specialized dest docs folders. Next: restore from <aside> and <storage>/t2p-*-<stamp>.` |
| EX-DIE-37 | Template has no `docs/` (asides restored when possible) | `t2p_overlay_docs` | `Template has no docs/ folder. Dest specialized docs folders were restored when possible.` |
| EX-DIE-38 | Copy of template `docs` failed (asides restored when possible) | `t2p_overlay_docs` | `Could not copy template docs. Dest specialized docs folders were restored when possible.` |
| EX-DIE-39 | Template docs copied but dest requirements could not be moved back | `t2p_overlay_docs` | `Copied template docs but could not restore dest requirements from <aside>.` |
| EX-DIE-40 | Template docs copied but another specialized dest folder could not be moved back | `t2p_overlay_docs` | `Copied template docs but could not restore dest <name> from <aside>.` |
| EX-DIE-41 | Apply confirm answered no (not `--force`) | `t2p_apply` | `Apply cancelled. Next: re-run with --force if you meant to skip the confirm.` |
| EX-DIE-42 | `--template` has no following name | `app_main` | `--template needs a template-name. Next: <APP_NAME> apply --template NAME --project NAME` |
| EX-DIE-43 | `--project` has no following name | `app_main` | `--project needs a project-name. Next: <APP_NAME> apply --template NAME --project NAME` |
| EX-DIE-44 | `plan` or `apply` already has both names and another token remains | `app_main` | `Unknown extra argument: <token>. Next: '<APP_NAME> help'.` |
| EX-DIE-45 | Token is not a flag or a known command | `app_main` | `Unknown command or flag: <token>. See '<APP_NAME> help'.` |

#### Return status 1 (no `exit` call; the process still ends on a direct command)

Human mode uses `out_error` (`[ERROR]` on stderr). JSON mode uses `out_json_error` with the code in the table. Non-interactive empty argv uses the same rows when `self-install` fails (`app_main` returns that status). From the TTY menu these rows do not call `exit`; the menu stays up unless the row is an `out_die` row above.

| ID | Condition | Function | JSON code | Message |
|----|-----------|----------|-----------|---------|
| EX-RET-01 | `version-check` cannot read a remote version | `ver_check` | `network_error` | `Failed to fetch remote version (SCRIPT_URL may be unset or unreachable)` |
| EX-RET-02 | `self-update` cannot read a remote version | `inst_self_update` | `network_error` | `Failed to fetch latest version (SCRIPT_URL may be unset or unreachable)` |
| EX-RET-03 | `self-update` would downgrade and `--force` is off | `inst_self_update` | `downgrade_blocked` | Human: `Refusing silent downgrade: local <local> is newer than remote <remote>.` JSON: `Refusing downgrade from <local> to <remote> (use --force)` |
| EX-RET-04 | Channel download with curl failed | download helpers | `network_error` | `Download failed (curl)` |
| EX-RET-05 | Channel download with wget failed | download helpers | `network_error` | `Download failed (wget)` |
| EX-RET-06 | Neither curl nor wget is on `PATH` | download helpers | `missing_dependency` | `Neither curl nor wget found` |
| EX-RET-07 | JSON mode and `CHECKSUM` does not match (human mode is EX-DIE-05) | `inst_perform_install_download_with_checksum` | `checksum_mismatch` | `Checksum verification failed (provided CHECKSUM does not match)` |
| EX-RET-08 | JSON mode and the companion digest does not match (human mode is EX-DIE-06) | `inst_perform_install_download_without_checksum` | `checksum_mismatch` | `Automatic checksum verification failed` |
| EX-RET-09 | Stage temp file could not be created | `inst_perform_install`, `inst_self_install`, `inst_self_install_copy_from_script` | `io_error` | `Failed to create temporary file` |
| EX-RET-10 | Companion-digest temp file could not be created | `inst_perform_install_download_without_checksum` | `io_error` | `Failed to create temporary file for checksum` |
| EX-RET-11 | Channel place could not create `GLOBAL_BIN` | `inst_perform_install_prepare_target` | `io_error` | `Failed to create <GLOBAL_BIN>` |
| EX-RET-12 | Channel place could not create `USER_BIN` | `inst_perform_install_prepare_target` | `io_error` | `Failed to create <USER_BIN>` |
| EX-RET-13 | Copy of the running script into the stage failed | `inst_self_install_copy_from_script` | `io_error` | `Failed to copy <src>` |
| EX-RET-14 | Move onto the channel install path failed | `inst_perform_install_atomic_install`, `inst_self_install_copy_from_script` | `io_error` | `Failed to move to <INSTALL_PATH>` |
| EX-RET-15 | `self-uninstall` without `--force` when JSON, quiet, or not a TTY | `inst_self_uninstall_confirm_and_remove` | `confirm_required` | `Uninstall requires --force in non-interactive mode (refusing to remove <path>).` |
| EX-RET-16 | TTY `self-uninstall` confirm answered no | `inst_self_uninstall_confirm_and_remove` | (human only) | `Uninstall cancelled by user.` (plain text, then status 1) |
| EX-RET-17 | `rm` of the channel install path failed | `inst_self_uninstall_confirm_and_remove` | `permission_denied` | `Failed to remove <path> (permission denied?)` |

#### Status 0 (the process ends without an error line)

| ID | Condition | Status |
|----|-----------|--------|
| EX-OK-01 | `version`, `about`, `help`, `where-is-me`, `list-templates`, `list-projects`, `plan`, or a finished `apply` | 0 |
| EX-OK-02 | Local `install` or `self-install` placed the file, or it was already installed and `--force` was off | 0 |
| EX-OK-03 | `version-check` fetched a remote version (newer, same, or local newer). A missing remote version is EX-RET-01 | 0 |
| EX-OK-04 | `self-update` is already current, or the replace finished | 0 |
| EX-OK-05 | Local `uninstall` removed the file, the file was already absent, or the TTY confirm answered no (`Uninstall cancelled`, then return 0) | 0 |
| EX-OK-06 | `self-uninstall` found nothing to remove, or the remove finished | 0 |
| EX-OK-07 | TTY menu choice `9`, `99`, `exit`, `quit`, or an empty line, or the menu read hit end of input | 0 |
| EX-OK-08 | Template or project picker choice `0` / back: `plan` or `apply` returns 0 and does not overlay. On the menu, that returns to the list | 0 |
| EX-OK-09 | Non-interactive empty argv `self-install` succeeded | 0 |

#### Does not end the process

| ID | Condition | What happens |
|----|-----------|----------------|
| EX-CONT-01 | `folder-backup` is not in `GLOBAL_BIN` or `USER_BIN` | `[WARN]`, local dest-docs snapshot, template copy continues |
| EX-CONT-02 | Sudoers fragment is missing, verb-only, or password-only | `[WARN]` (unproven text may match EX-DIE-21), local snapshot, copy continues. **MUST NOT** call `util_sudo` |
| EX-CONT-03 | Bad main-menu or self-management number | `[ERROR] Not a menu choice …`, reprint, read again |
| EX-CONT-04 | `util_sudo` on Termux, Git Bash, or Windows cmd | `return 1`, no `sudo`, no `out_die` |
| EX-CONT-05 | Companion `${SCRIPT_URL}.sha256` is missing | `[WARN]` and the install continues without that check |
| EX-CONT-06 | Gate was pass and `folder-backup backup` exited non-zero, and the child text reports a file-count gap | `[WARN]` names **file-counting-method** (symlinks and soft links are not counted). Local dest-docs snapshot. Overlay continues. **MUST NOT** print `[ERROR]`. **MUST NOT** name sudoers argv. **INC-20261014-001** |
| EX-CONT-07 | Gate was pass and `folder-backup backup` exited non-zero for any other reason | `[WARN]` that the backup did not finish. Local dest-docs snapshot. Overlay continues. **MUST NOT** print `[ERROR]`. **MUST NOT** name sudoers argv. The gate already passed |

### 2.2 Why This Requirement Exists (CIAO)

- **Principle 1 – Caution:** a failure names itself and stops, or a warning says the work continues.  
- **Principle 2 – Intentional:** one table is the list of endings, taken from `out_die` and the `return 1` messages.  
- **Principle 5 – Single source of output:** this file does not invent a second printer.  
- **Principle 15 – Helpful usage:** fatal messages include a next step when the ship unit already prints one.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class, admin privilege and a dedicated system user stay unused.

**This requirement:** EX-DIE-08 and EX-DIE-11 are the global-install exits on that class. They name the user install and say not to use sudo. EX-CONT-04 returns without `sudo` and without `out_die`. **MUST NOT** add an exit that runs `sudo`, wraps `apt`, or recommends `sudo curl | sh`. Git Bash and Windows cmd **MUST NOT** call Termux `pkg`.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Status 1 always has a message. Status 0 does not pretend a warning was fatal.  
- **Intentional:** The tables match the ship unit’s strings.  
- **Anti-fragile:** JSON and human mode both end with the same status.  
- **Over-protect:** Do not replace `out_die` with a bare `exit`, and do not turn EX-CONT rows into exits.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Add a second `exit` helper or call `exit` outside `out_die`.  
2. Make a missing `folder-backup` binary or a missing sudoers fragment into an `out_die` (EX-CONT-01, EX-CONT-02).  
3. Turn a passed backup that exits non-zero into an `out_die` or an `[ERROR]` (EX-CONT-06 and EX-CONT-07 warn, and the overlay continues). A file-count misalignment is `[WARN]` and names **file-counting-method**. It is not a sudoers argv miss. EX-DIE-33 stays withdrawn.  
4. Exit the process on a bad menu number.  
5. Drop a new error message from these tables.  
6. Print a sudo password prompt as an exit path.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_die` printing |
| `docs/requirements/requirement-shell-cli-interface.md` | Unknown token |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Menu Exit and bad-pick retry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv |
| `docs/requirements/requirement-shell-local-self-management.md` | Local install and uninstall exits |
| `docs/requirements/requirement-shell-self-management.md` | version-check, self-update, self-uninstall |
| `docs/requirements/requirement-shell-cli-self-install.md` | self-install failures |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Companion digest mismatch |
| `docs/requirements/requirement-shell-cli-storage.md` | Cache and persistence exits |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | Confirm versus `--force` |
| `docs/requirements/requirement-shell-sudo-command.md` | When `util_sudo` may run |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | plan / apply exits and continue rows |
| `src/tmpl-to-prj` | Implementation |

## Design-time verification

| TP-ID | Suite | Status | Note |
|-------|-------|--------|------|
| TP-EXIT-01 | `tests/test_cli.sh` | todo | Unknown token is EX-DIE-45, status 1, `[ERROR]`, and the help pointer |
| TP-EXIT-02 | `tests/test_cli.sh` | todo | `--json` unknown token is status 1, stderr JSON `type` `out_error`, no `[ERROR]` line |
| TP-EXIT-03 | `tests/test_domain_tmpl_to_prj.sh` | todo | Missing names is EX-DIE-24. Unproven backup is EX-CONT-02 (status 0, `[WARN]`, no `[ERROR]`) |
| TP-EXIT-04 | `tests/test_cli.sh` | todo | Menu choice `9` is EX-OK-07. A bad menu number is EX-CONT-03 and the process stays up |
| TP-EXIT-05 | `tests/test_domain_tmpl_to_prj.sh` | have | Passed backup non-zero is EX-CONT-06 (file-count, `[WARN]`, **file-counting-method**, no `[ERROR]`, overlay) and EX-CONT-07 (any other non-zero, `[WARN]`, overlay). **TP-TMPL-TO-PRJ-26**, **TP-TMPL-TO-PRJ-31** |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## Terminologies

### Error-handling

**Definition:** Error-handling is the deliberate design for when something goes wrong: how a system detects failure, classifies severity, reports it on the correct channel, contains damage, recovers or exits, and leaves the system in a known, safe state.

**Human daily-life explanation:** Error-handling is the household plan for when something breaks: notice it, say how bad it is, tell the right person, stop the mess spreading, and leave the kitchen in a known state. A silent fail is not a plan.

**Daily-life example:** The oven beeps and you pull the tray, open a window, and write “do not use until cool” on a sticky note. That is error-handling, not pretending dinner is fine.

### Graceful exit

**Definition:** Graceful exit is the outcome when the operator sends Ctrl-C while a long child is still running: stop that child, do not publish the unfinished result, and return status 130. It is not this product’s failure catalog, and it is not a tool’s ordinary non-zero exit.

**Human daily-life explanation:** A graceful exit is what you do when you hit the stop button on a blender before the smoothie is finished. You turn the machine off and you do not pour the half-blend into the glass.

**Daily-life example:** The oven timer is still running and you press cancel. You take the tray out and you do not set it on the table as the meal. This program does not define that Ctrl-C path. Its endings are the tables above.

### Well-known exit condition

**Definition:** A well-known exit condition is one row of a closed catalog of conditions that end the process. The catalog has two families. A non-zero ending prints a fatal message and leaves with a status other than 0. A clean ending leaves with status 0 and no fatal line. Exit, quit, an empty line, or end of input on a nested menu layer returns only to the parent and is not a process ending. The same controls on the front menu are a clean ending. A direct command's non-zero return is a non-zero ending. That same return does not end the process when a menu is still the caller and the call is not the fatal-exit helper. A product requirement fills the message text for its rows. Each kind is its own term named exit-condition- plus the kind slug. This term does not freeze one product's sentences, function names, or host paths.

**Human daily-life explanation:** A well-known exit condition is a reason the visit is over. Either something required went wrong and the host says so as you leave, or you are finished and the door closes quietly. Walking out of a side room only puts you back in the front room. That is not the end of the visit.

**Daily-life example:** You order a meal and the kitchen has no pot it must use. They stop and tell you why. If you say goodbye at the front door, the visit ends with no alarm. A missing spare napkin is not this term. That miss is a well-known don't-exit condition.

The EX-DIE, EX-RET, and EX-OK tables above are this product's filling of that catalog. Status 0 rows are still endings.

### Well-known don't-exit condition

**Definition:** A well-known don't-exit condition is one row of a closed catalog of misses that look like a stop and must not end the process. The program warns or reprints, names the miss, and continues the work the operator asked for. The rows are an optional sibling tool that is absent, an optional grant that is missing or too narrow, a bad menu number, elevation on a command line for normal user only, a missing optional companion digest, a non-fatal return while a menu is still the caller, leaving only a nested menu layer, picker back while a menu is still up, and the sentence before a known long job. A check the operator named as the job still ends the process and is a well-known exit condition: a refused path, a missing required name, and a required side command that was started and exited non-zero. Do not ask for a password to hide a missing grant. Pain PP-A-30 is the failure to keep this split. Each continue kind is its own term named no-exit-condition- plus the kind slug.

**Human daily-life explanation:** A well-known don't-exit condition is a miss that looks like a reason to close, while the visit continues. The host names the miss and still brings the thing you asked for.

**Daily-life example:** The coat check is closed. They say so and still serve the meal. If you call a dish number that is not on the board, they show the board again. If the stove they already lit then fails, that is a well-known exit condition. If you say goodbye at the front door, that is also an exit, not this term.

The EX-CONT table above is this product's filling of that catalog. A missing optional backup tool and an unproven grant stay in that table.

### Exit condition: already desired state

**Definition:** exit-condition-already-desired-state is the well-known exit condition in which the file is already installed, already current, or already absent, and the command defines that as success. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-already-desired-state means the thing you asked for is already the way you wanted, so nothing changes.

**Daily-life example:** The program is already the current one. The command leaves quietly with status 0.

### Exit condition: declined fatal confirm

**Definition:** exit-condition-declined-fatal-confirm is the well-known exit condition in which the operator declined a confirm the product defines as a stop. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-declined-fatal-confirm means you said no, and the house rule says that no means leave with an alarm.

**Daily-life example:** You decline the question and the product treats that decline as a stop.

### Exit condition: declined status-zero confirm

**Definition:** exit-condition-declined-status-zero-confirm is the well-known exit condition in which the operator declined a confirm the product defines as status 0. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-declined-status-zero-confirm means you said no, and the house rule says that no is a quiet leave, not an alarm.

**Daily-life example:** You decline a remove question and the product leaves with status 0 and a plain cancelled line.

### Exit condition: destination not a directory

**Definition:** exit-condition-dest-not-directory is the well-known exit condition in which the destination path is not a directory. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-dest-not-directory means you asked to set the table on a single spoon instead of in a room.

**Daily-life example:** The destination name is a file, not a folder. The host stops.

### Exit condition: digest mismatch

**Definition:** exit-condition-digest-mismatch is the well-known exit condition in which a declared checksum, or a companion digest that was fetched, does not match the bytes. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-digest-mismatch means the seal number on the jar does not match the wax on the lid.

**Daily-life example:** The downloaded file disagrees with the checksum you were given. The install stops.

### Exit condition: direct command back

**Definition:** exit-condition-direct-command-back is the well-known exit condition in which a picker back choice is the process status, and the hop does not run. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-direct-command-back means you were asked to pick, you said back, and that answer is the whole visit.

**Daily-life example:** A direct command opens a picker, you choose back, and the process leaves with status 0 without doing the hop.

### Exit condition: direct fetch or channel failed

**Definition:** exit-condition-direct-fetch-or-channel-failed is the well-known exit condition in which, on a direct command, the remote version is unreadable, the download failed, the fetch tool is missing, a downgrade is refused, or a temp file or channel place failed. On that direct command the process ends with a fatal message and a status other than 0. From a menu, these stay up unless the product uses the fatal-exit helper. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-direct-fetch-or-channel-failed means you asked directly for the remote copy and the fetch, the tools, or the place-down failed.

**Daily-life example:** You run the update as its own command and the download fails. That command ends. The same failure from inside the menu stays on the menu unless the fatal helper is used.

### Exit condition: elevation called unproven

**Definition:** exit-condition-elevation-called-unproven is the well-known exit condition in which an elevation wrapper was called when this login is not root and a no-password grant was not proven. The ordinary missing-grant path does not call the wrapper. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-elevation-called-unproven means someone rang the manager's bell even though this visit was not supposed to, and this person has no standing key.

**Daily-life example:** The elevation helper runs without a proven no-password grant. That call stops. A normal unproven optional grant never rings that bell.

### Exit condition: empty argv place succeeded

**Definition:** exit-condition-empty-argv-place-succeeded is the well-known exit condition in which non-interactive empty argv placed the program. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-empty-argv-place-succeeded means you start the program with no extra words, nobody is at the keyboard, and the place-down works.

**Daily-life example:** An automated run with no arguments places the program and leaves with status 0.

### Exit condition: empty required picker

**Definition:** exit-condition-empty-required-picker is the well-known exit condition in which a picker the command requires has no live rows. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-empty-required-picker means the board you must choose from is blank.

**Daily-life example:** The list of kits is empty, so there is nothing to point at. The host stops and says how to name one yourself.

### Exit condition: extra argument

**Definition:** exit-condition-extra-argument is the well-known exit condition in which the command already has its operands and another token remains. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-extra-argument means the order already has both names and you added another word.

**Daily-life example:** Two names were enough and a leftover word remains. The host stops.

### Exit condition: flag missing value

**Definition:** exit-condition-flag-missing-value is the well-known exit condition in which a flag that needs a value has none. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-flag-missing-value means you said with and did not say with what.

**Daily-life example:** A flag that needs a name is the last word on the line. The host stops.

### Exit condition: front menu leave

**Definition:** exit-condition-front-menu-leave is the well-known exit condition in which the front menu receives Exit, quit, an empty line, or end of input. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-front-menu-leave means you say goodbye at the front door, you say nothing, or you walk away from the front board.

**Daily-life example:** You choose Exit on the front board. The process leaves with status 0.

### Exit condition: hop mutate failed

**Definition:** exit-condition-hop-mutate-failed is the well-known exit condition in which a required snapshot, aside move, remove, copy, or restore of the operator's hop failed. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-hop-mutate-failed means the actual move of the papers you asked for did not complete.

**Daily-life example:** The host cannot set the new pages in place, or cannot put the saved pages back. The visit stops.

### Exit condition: install place failed

**Definition:** exit-condition-install-place-failed is the well-known exit condition in which the install directory cannot be created or written, or stage, mode, move, or the readable-and-executable heal failed. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-install-place-failed means the tool will not sit on its hook: the hook cannot be made, the tool will not move onto it, or it is not both readable and runnable afterward.

**Daily-life example:** The copy onto the install hook fails. The host stops.

### Exit condition: path not found

**Definition:** exit-condition-path-not-found is the well-known exit condition in which a named path does not resolve to a folder the command can use. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-path-not-found means you named a room and that room is not in the building.

**Daily-life example:** You ask for the blue closet and there is no such door. The host stops and says so.

### Exit condition: predictable scratch

**Definition:** exit-condition-predictable-scratch is the well-known exit condition in which a scratch name template contains the shell pid token `$$`. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-predictable-scratch means the scrap paper would use a name anyone can guess.

**Daily-life example:** A temporary ticket whose pattern includes that pid token is refused before it is created.

### Exit condition: refused path

**Definition:** exit-condition-refused-path is the well-known exit condition in which the named root is the login home, the filesystem root, the parent of home directories, a device directory, or a RAM mount the product lists as refused. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-refused-path means you pointed at the whole house, the street of houses, or the furnace room, and those are not a project room.

**Daily-life example:** You say to use the home hallway. The host refuses that place and stops.

### Exit condition: remove failed

**Definition:** exit-condition-remove-failed is the well-known exit condition in which the managed file could not be removed. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-remove-failed means you agreed to throw the tool away and the bin would not take it.

**Daily-life example:** The delete of the installed file is denied. The host stops and the file is still there.

### Exit condition: required name missing

**Definition:** exit-condition-required-name-missing is the well-known exit condition in which a required name is still empty and no terminal picker will fill it. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-required-name-missing means you cannot hand in a blank order when nobody is standing there to point at the board.

**Daily-life example:** Both name lines are empty and you are not at the counter. The visit stops.

### Exit condition: same folder

**Definition:** exit-condition-same-folder is the well-known exit condition in which two required names resolve to the same directory. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-same-folder means you named the source room and the destination room and they are the same room.

**Daily-life example:** You ask to copy the kitchen onto the kitchen. The host stops.

### Exit condition: started required command failed

**Definition:** exit-condition-started-required-command-failed is the well-known exit condition in which a required side command was started and exited non-zero. An optional tool that was never started is not this row. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-started-required-command-failed means the helper you already sent into the kitchen comes back and says the job failed.

**Daily-life example:** A required side command starts and then exits with a failure. The main job does not continue.

### Exit condition: storage unusable

**Definition:** exit-condition-storage-unusable is the well-known exit condition in which persistence or cache cannot be created or is not writable, or persistence resolved to the install bin directory. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-storage-unusable means there is nowhere safe to put the notepad, or the only shelf offered is the shelf where the tools themselves live.

**Daily-life example:** The notebook drawer will not open, or it is the same drawer as the installed program. The host stops.

### Exit condition: uninstall unconfirmed

**Definition:** exit-condition-uninstall-unconfirmed is the well-known exit condition in which remove is asked when there is no terminal, or when machine output or quiet mode is on, and force is off. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-uninstall-unconfirmed means nobody is at the counter to say yes, so the host will not throw the tool away.

**Daily-life example:** A script asks to remove the program and there is no person to confirm. It stops instead of deleting.

### Exit condition: unknown token

**Definition:** exit-condition-unknown-token is the well-known exit condition in which the token is not a known command or flag. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-unknown-token means you asked, on a direct order, for a dish the house does not serve.

**Daily-life example:** You type a word the program does not know. It stops and points at help.

### Exit condition: verb finished

**Definition:** exit-condition-verb-finished is the well-known exit condition in which the command completed the work it was asked to do. The process ends with status 0 and no fatal line. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-verb-finished means the meal is on the table and the visit is over.

**Daily-life example:** The copy finishes. The process leaves with status 0 and no alarm.

### Exit condition: wrong source shape

**Definition:** exit-condition-wrong-source-shape is the well-known exit condition in which the source is not the kit shape that command requires. The process ends with a fatal message and a status other than 0. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** exit-condition-wrong-source-shape means you handed over a finished scrapbook when the job needs a blank kit.

**Daily-life example:** The folder has extra bound-in chapters the kit must not have. The host stops.

### No-exit condition: bad menu choice

**Definition:** no-exit-condition-bad-menu-choice is the well-known don't-exit condition in which the pick is not on this list. Print the loud line, reprint this layer, and read again. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-bad-menu-choice means you call a number that is not on this board, and the host shows the board again.

**Daily-life example:** You say 3 and the board has 1, 2, and 9. The process stays up.

### No-exit condition: menu nonfatal return

**Definition:** no-exit-condition-menu-nonfatal-return is the well-known don't-exit condition in which a non-zero return while a menu is still the caller, and the call is not the fatal-exit helper. The menu stays up. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-menu-nonfatal-return means a side errand from the front desk comes back unhappy, and you are still at the desk.

**Daily-life example:** A failure that would end a direct command comes back to the menu without the fatal helper. The menu stays.

### No-exit condition: normal-user-only elevation

**Definition:** no-exit-condition-normal-user-only-elevation is the well-known don't-exit condition in which on a command line for normal user only, the elevation wrapper returns without sudo and without the fatal exit. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-normal-user-only-elevation means this counter has no manager's bell. The wrapper comes back without calling one and without throwing you out.

**Daily-life example:** On that class of terminal the elevation helper returns without sudo. That return is not itself a process exit.

### No-exit condition: optional backup failed

**Definition:** no-exit-condition-optional-backup-failed is the well-known don't-exit condition in which an optional backup was started and exited non-zero, including a file-count misalignment under **file-counting-method**. Warn. Do not print `[ERROR]` for that misalignment. Continue the hop. Take the weaker local copy. Starting the optional command does not make it required. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-optional-backup-failed means the spare locker receipt comes back wrong, including a ribbon counted as a sheet. The host says so as a warning and still serves the meal.

**Daily-life example:** The coat-check slip says one extra item because of a ribbon. You hear a warning, and you still get your table.

### No-exit condition: optional digest absent

**Definition:** no-exit-condition-optional-digest-absent is the well-known don't-exit condition in which the companion digest is missing. Warn and continue the install. The process stays up. A digest that was fetched and does not match is exit-condition-digest-mismatch, not this row. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-optional-digest-absent means the seal slip was never in the envelope. The host says so and still accepts the jar.

**Daily-life example:** The companion checksum file is missing. The install continues after a warning.

### No-exit condition: optional grant unproven

**Definition:** no-exit-condition-optional-grant-unproven is the well-known don't-exit condition in which an optional grant file is missing, names only the verb, or would allow a password prompt. Warn. Do not call the elevation wrapper. Do not ask for a password. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-optional-grant-unproven means you have no key for an optional lock, so the host skips that lock and does not ask you to invent a password.

**Daily-life example:** The grant file is absent. The host warns and continues, and does not call the elevation wrapper.

### No-exit condition: optional tool absent

**Definition:** no-exit-condition-optional-tool-absent is the well-known don't-exit condition in which an optional sibling tool is not in the global bin or the user bin. Warn, name the miss, and continue the hop. Do not make the miss fatal. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-optional-tool-absent means a helper the meal does not require is not on staff. The host says so and still serves.

**Daily-life example:** The optional helper is not installed. You get a warning and the main job still runs.

### No-exit condition: picker back on menu

**Definition:** no-exit-condition-picker-back-on-menu is the well-known don't-exit condition in which back on a picker, while a menu is still up, returns to that menu and does not run the hop. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-picker-back-on-menu means you say back while the front desk is still open. You see the front board again. The meal is not served.

**Daily-life example:** From the menu you open a picker and choose back. The hop does not run and the menu returns.

### No-exit condition: slow-choice notice

**Definition:** no-exit-condition-slow-choice-notice is the well-known don't-exit condition in which the sentence before a known long job. It is not an exit decision. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-slow-choice-notice means the waiter says this dish takes time. That sentence is not the end of the visit.

**Daily-life example:** You pick a slow job. The board says it takes time, then the work starts. The process does not exit because of that sentence.

### No-exit condition: submenu leave

**Definition:** no-exit-condition-submenu-leave is the well-known don't-exit condition in which exit, quit, an empty line, or end of input on a nested layer returns to the parent only. The process stays up. It is one row of that catalog, not the whole catalog.

**Human daily-life explanation:** no-exit-condition-submenu-leave means you leave the side room and you are back at the front board.

**Daily-life example:** You choose Exit on a nested list. The process is still running on the parent list.

## 6. Status history

| Date | Status | Notes |
|------|--------|-------|
| 2026-10-10 | Active 1.0.0 | Exit catalog from `out_die` and the `return 1` messages in `src/tmpl-to-prj` |
| 2026-10-10 | Active 1.0.1 | Terminology substance for well-known exit condition and well-known don't-exit condition. Exit tables unchanged. |
| 2026-10-10 | Active 1.0.2 | One term per kind: exit-condition-* (27) and no-exit-condition-* (9). Exit tables unchanged. |
| 2026-10-14 | Active 1.0.3 | EX-DIE-33 withdrawn. EX-CONT-06 and EX-CONT-07: a started optional backup that exits non-zero warns and overlay continues. File-count misalignment is `[WARN]` and names **file-counting-method**. **INC-20261014-001**, revised. |

**Last Updated**: 2026-10-14  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
