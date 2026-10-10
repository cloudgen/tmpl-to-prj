**file**: docs/requirements/requirement-shell-cli-interface.md  
**Status**: Active (Version 2.4.1)  
**Area**: shell  
**Key**: `requirement-shell-cli-interface`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for the **POSIX shell CLI interface** of tmpl-to-prj: command surface, privilege typing, global flags, dispatcher behavior, help/about contracts, and mode rules.

Domain verb catalog ownership is `requirement-domain-tmpl-to-prj` (dual mention). Full lifecycle rules live in `requirement-shell-local-self-management.md`.

### 1.1 Human-facing

**In one sentence:** You type `tmpl-to-prj` plus a command; unknown words fail closed; empty argv is a menu on a terminal and self-install in a pipe.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator | `tmpl-to-prj help` |
| The other role | Domain hop owner | `requirement-domain-tmpl-to-prj` |
| Not this file | How `out_*` prints | `requirement-shell-output-requirements` |

| Includes | Excludes |
|----------|----------|
| Command table, flags, dispatcher | This product’s `backup` / `print-sudoers` verbs |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| See the list | Help names plan/apply and install | `tmpl-to-prj help` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Command surface (portable shape)

Every command **MUST** map to exactly one privilege type. Unclassified commands are incomplete design.

| Category | Privilege | Meaning |
|----------|-----------|---------|
| **Type 0 – CLI lifecycle + diagnostics** | Invoking user | `install`, `uninstall`, `where-is-me`, `version`, `about`, `help`, `menu`, `main`, `self-install`, `version-check`, `self-update`, `self-uninstall` |
| **Type 0 – Domain** | Invoking user | `plan`, `apply` (in-tool sudo of sibling `folder-backup` only) |
| **Type 1 – Narrow elevated host ops** | Controlled sudo | **Not this product’s emit** — sibling `folder-backup` |
| **Type 2 – Dedicated system user app ops** | Dedicated app user | **Not in scope** |

### 2.2 Global flags (portable)

| Flag | Env / state | Behavior |
|------|-------------|----------|
| `--quiet`, `-q` | `QUIET=1` | Suppress non-error human output; errors still visible |
| `--json` | `JSON=1` (implies quiet) | Machine-readable structured output |
| `--debug` | `DEBUG=1` | Extra diagnostics on stderr; must not break JSON purity on stdout |
| `--force` | `FORCE=1` / force policy | Skip uninstall confirm or force reinstall only where documented |
| `--global` | `FORCE_GLOBAL=1` | Install to `GLOBAL_BIN` |
| `--template NAME` | `TEMPLATE_NAME` | Genesis-template or subclass name |
| `--project NAME` | `PROJECT_NAME` | Dest project name |
| `--dry-run` | `DRY_RUN=1` | `apply` behaves as `plan` |

Additional flags **MAY** be added only when documented here (or a superseding requirement) and wired in the dispatcher.

**Forbidden flags (trimmed):** `--allow-test-local`, `--disk`, `--ram` as this product’s flags.

### 2.3 Dispatcher and entry rules

1. **Single entry:** `app_main` **MUST** parse global flags and route commands.  
2. **Unknown command:** **MUST** fail loudly with pointer to `help` (via output SSOT).  
3. **Empty argv:** TTY → main menu; off-TTY → `inst_self_install` (not help) (`requirement-shell-cli-zero-arguments.md` · `requirement-shell-cli-default-interaction.md`).  
4. **No raw user I/O:** User-facing messages **MUST** go through `out_*`.  
5. Script end **MUST** call `app_main "$@"` (no basename gate that blocks dispatch).  
6. This product’s tokens **MUST NOT** include `backup`, `restore`, `print-sudoers`, `print-sudoers-install-script`, `remove-project-sudoers` — those **MUST** fail as unknown.

### 2.4 Help surface

`help` **MUST** list:

- Usage line  
- Every supported Type 0 command with one-line purpose  
- Global flags  
- Local `install` (mode 0755, no network) and channel self-management (`SCRIPT_URL`). **MUST NOT** name `CHECKSUM`

In JSON mode, help **MUST NOT** dump long human text; return a short structured success/note object.

`help` **MUST** list operational domain verbs (`plan`, `apply`, `menu`) **apart** from test-purpose (none in v1). **MUST NOT** list this product’s own backup, restore, or sudoers-file verbs.

### 2.5 Implementation Notes (this project)

| Item | Value for tmpl-to-prj |
|------|-------------------------|
| **Product / binary name** | `tmpl-to-prj` (`APP_NAME`) |
| **Primary executable** | `src/tmpl-to-prj` (POSIX `/bin/sh`, single-file ship unit) |
| **Dispatcher** | `app_main` |
| **Output SSOT** | `out_text` + wrappers (`out_info`, `out_success`, `out_warn`, `out_error`, `out_die`, `out_plain`, `out_json`, …) |
| **Version SSOT** | `VERSION="1.6.3"` hard-assign in ship unit |
| **Install paths** | Global: `GLOBAL_BIN` default `/usr/local/bin`; User: `USER_BIN` default `${HOME}/.local/bin` |
| **Primary install story** | User bin: `~/.local/bin/tmpl-to-prj` via `install` (0755) or `self-install` (0700 unless root) |
| **Online channel** | `SCRIPT_URL` default `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj` |
| **Type 1 / Type 2 commands** | None |
| **Dedicated system user** | Not required |
| **About** | Type 0 plus RAM/projects roots (`requirement-domain-tmpl-to-prj`) |

#### Supported commands (normative for this project)

| Command | Type | Handler family | Required behavior |
|---------|------|----------------|-------------------|
| *(no args — empty argv)* | Type 0 | `app_main` → `app_default` or `inst_self_install` | TTY menu; off-TTY self-install — not help |
| `install` | Type 0 | `inst_local_install` | Copy running ship unit to privilege-correct bin; idempotent unless `--force` |
| `uninstall` | Type 0 | `inst_local_uninstall` | Remove managed binary; confirm unless `--force` |
| `where-is-me` | Type 0 | `app_where_is_me` | Running + install paths + installed flag |
| `version` | Type 0 | `app_version` | Local `VERSION` only; no network |
| `about` | Type 0 | `app_about` | Diagnostics, cache folder lines and persistence (`requirement-shell-cli-storage` 1.2.0), plus RAM/projects roots |
| `help` | Type 0 | `app_help` | Full usage in human mode; short JSON note in JSON mode |
| `plan` | Type 0 | `t2p_plan` | Dual mention: domain SSOT |
| `apply` | Type 0 | `t2p_apply` | Dual mention: domain SSOT |
| `menu` / `main` | Type 0 | `app_default` | Dual mention: default-interaction |
| `list-templates` | Type 0 test-purpose | `t2p_cmd_list_templates` | Dual mention: domain SSOT; RAM parent, current folder, and `PROJECTS_ROOT`; `requirement-*.md` excludes; help lists apart |
| `list-projects` | Type 0 test-purpose | `t2p_cmd_list_projects` | Dual mention: domain SSOT. Any existing directory. No `docs/` or `AGENTS.md` test. Help lists apart |
| `self-install` | Type 0 | `inst_self_install` | Copy when `$0` is the script; download when `$0` is a shell. Not an alias of `install` |
| `version-check` | Type 0 | `ver_check` | Local vs `SCRIPT_URL`. Fail loud if the channel is unreachable |
| `self-update` | Type 0 | `inst_self_update` | Newer channel replaces. No silent downgrade |
| `self-uninstall` | Type 0 | `inst_self_uninstall` | Remove managed binary; confirm unless `--force` |

#### Global flags (normative wiring)

| Flag | Required wiring |
|------|-----------------|
| `--quiet`, `-q` | `QUIET=1` in `app_main` |
| `--json` | `JSON=1` and `QUIET=1` in `app_main` |
| `--debug` | `DEBUG=1` in `app_main` |
| `--force` | `FORCE=1` (and install reinstall policy when applicable; skip apply confirm) |
| `--global` | `FORCE_GLOBAL=1` |
| `--template NAME` | `TEMPLATE_NAME` |
| `--project NAME` | `PROJECT_NAME` |
| `--dry-run` | `DRY_RUN=1` |

#### Dispatcher acceptance criteria

1. Unknown token after flag parse → `out_die` with pointer to `tmpl-to-prj help`.  
2. Zero-arg → TTY menu / off-TTY self-install (not help).  
3. Command routing table in `app_main` **must** include every row above and **no** trimmed parent verbs.  
4. Help text **must** stay aligned with that table.

#### Explicitly out of scope

- Domain: `backup`, `restore`  
- Sudoers-file: `print-sudoers`, `print-sudoers-install-script`, `remove-project-sudoers`  
- Type 1 host-mutating setup  
- Type 2 app runtime under a dedicated system user  

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution**: Unknown commands fail loud; force gates destructive ops.  
- **CIAO Principle 2 – Intentional**: Every command has one privilege type and one handler family.  
- **CIAO Principle 5 – Single Source of Output**: Central `out_*`.  
- **CIAO Principle 6 – Single Point of Entry**: `app_main` is the dispatcher SSOT.  
- **CIAO Principle 9 – Three Types of Commands**: Type 0 lifecycle only.  
- **CIAO Principle 10 – Least-Privilege User**: No invented system-user requirement for binary lifecycle.  
- **CIAO Principle 16 – Interactive vs Non-Interactive**: No hang in non-interactive mode.  
- **CIAO Principle 4 / 20 – Over-protect**: Protection Rule blocks privilege and UX regressions.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same command table (`plan` / `apply` / `install` / channel self-management) | In-tool `sudo`; wrap `apt`; recommend `sudo curl \| sh`; Type 1 host setup |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** owns the verb catalog. Detect helpers live on the ship unit; Termux `pkg` is `requirement-shell-termux-ish`.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Fail closed on unknown verbs, including trimmed parent verbs.  
- **Intentional**: Type 0 catalog is the whole product surface.  
- **Anti-fragile**: Same dispatcher contract as parent.  
- **Over-protect**: Do not silently restore domain verbs “because the name is cli-template.”

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Add domain or sudoers verbs without a new Active requirement and explicit user order.  
2. Change non-interactive 0-argv from self-install back to help, or change TTY 0-argv from the menu to install.  
3. Bypass `out_*` for user-facing messages.  
4. Hide the channel from help, or print the token `CHECKSUM` in help or about.  
5. Collapse Type 1/2 into “just run as root.”

**Violating this rule is a critical CLI-surface regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Help lists install / uninstall / where-is-me / version / about / help |
| AC-2 | Help and about omit backup / restore / print-sudoers |
| AC-3 | Unknown and trimmed verbs exit non-zero |
| AC-4 | Empty argv is TTY menu / off-TTY self-install |

---

## 6. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-shell-cli-zero-arguments` | Empty argv |
| `requirement-shell-local-self-management` | install / uninstall / where-is-me |
| `requirement-shell-output-requirements` | `out_*` |
| `requirement-bootstrap-chain` | Trimmed surfaces |
| `requirement-shell-termux-ish` | Termux target |
| `requirement-shell-cli-storage` | About cache folder and persistence lines |
| `docs/requirements/index.md` | Registry |

---

## Design-time verification

| TP family / ID | Suite | Status | Note |
|----------------|-------|--------|------|
| **TP-CLI-01..13** | `tests/test_cli.sh` | have | includes stripped-verb fail-closed |
| **TP-LC-*** | `tests/test_local_lifecycle.sh` | have | lifecycle |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-03 | Active 1.0.0 | folder-backup Type 0 + domain verbs |
| 2026-08-13 | Active 2.0.0 | cli-template Type 0 only |
| 2026-09-06 | Active 2.1.0 | Termux target; human-facing; empty argv AC is TTY menu / off-TTY help |
| 2026-09-27 | Active 2.2.0 | `about` cache lines follow `requirement-shell-cli-storage` 1.2.0 (used / preferred / 1st / 2nd) |
| 2026-10-04 | Active 2.4.0 | Off-TTY empty argv is self-install. TTY menu stays |
| 2026-10-07 | Active 2.4.1 | `list-projects` dual mention: any directory dest (domain 1.10.0) |

---

**Last Updated**: 2026-10-07  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
