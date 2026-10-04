**file**: docs/requirements/requirement-shell-cli-zero-arguments.md  
**Status**: Active (Version 1.2.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-zero-arguments`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **zero-argument (empty argv) dispatcher behavior** of the tmpl-to-prj POSIX shell CLI.

### 1.0 Product type

| Field | Value for tmpl-to-prj |
|-------|-------------------------|
| **Empty-argv type** | **Type O-S** for non-interactive 0-argv. **TTY menu kept** |
| **Rationale** | The documented one-liner is `curl -fsSL …/src/tmpl-to-prj \| sh` with no command token. That line is non-interactive 0-argv and **MUST** call `inst_self_install`. Showing help is a misalignment. A terminal with no words still shows the numbered menu and **MUST NOT** install |

Type N (off-TTY help) does **not** apply. A product that documents that one-liner is Type O. Depth is **Type O-S** (ship unit only, not a payload). Interactive empty argv stays the menu.

### 1.1 Human-facing

**In one sentence:** On a terminal, running `tmpl-to-prj` with no words shows the numbered list; a pipe with no words places the program.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator at a terminal | `tmpl-to-prj` then `9` |
| The other role | Automation / pipe | `curl … \| sh` self-installs; does not hang; does not print help |
| Not this file | What the numbered rows are | `requirement-shell-cli-default-interaction` |

| Includes | Excludes |
|----------|----------|
| TTY menu; non-interactive 0-argv self-install | Non-interactive 0-argv as help; TTY 0-argv as install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open the menu | Empty argv on a TTY | `tmpl-to-prj` |
| Place from a pipe | Non-interactive 0-argv; `$0` is the shell | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj \| sh` |

---

## 2. Core Rules (Mandatory)

### 2.1 Single meaning of empty argv

1. When **argv is empty** (`$# -eq 0` at entry to `app_main`) **and** `TTY=1`, the dispatcher **MUST** route to the main menu (`app_default`) — `requirement-shell-cli-default-interaction`. It **MUST NOT** call `inst_self_install`.  
2. When argv is empty **and** `TTY=0`, the dispatcher **MUST** call **`inst_self_install`** and return that status. It **MUST NOT** call `app_help`.  
3. Already installed and force off → success text “already installed”. **MUST NOT** print full help. **MUST NOT** download again.  
4. A place failure (network, checksum, I/O) **MUST** exit non-zero.  
5. Explicit `tmpl-to-prj help` remains the full-usage path.  
6. Explicit `tmpl-to-prj install` remains the local **0755** copy. It is **not** the empty-argv handler and **not** an alias of `self-install`.  
7. Script entry **MUST** always call `app_main "$@"` (no basename product-name gate that blocks a pipe).  
8. `sh path/to/tmpl-to-prj` with no words off a TTY copies that file (no download). `curl … \| sh` has `$0` equal to the shell and downloads `SCRIPT_URL`. A test that only runs `sh path` does **not** prove the pipe.  
9. `--json` or `--quiet` with no command token is the JSON/help special case. It **MUST NOT** self-install and **MUST NOT** open the menu. That line is not the 0-argv one-liner.

### 2.2 Normative matrix

| Invocation | Behavior |
|------------|----------|
| `tmpl-to-prj` (no args, TTY) | Main menu; exit 0 after pick or Exit; no install |
| `tmpl-to-prj` (no args, off-TTY) | `inst_self_install`; not help |
| `curl … \| sh` (no args) | Same place path; `$0` is the shell, so download |
| `tmpl-to-prj help` | Show help; exit 0 |
| `tmpl-to-prj install` | Local install ensure (mode 0755) |
| `--json` or `--quiet` with no command | Help (JSON when `--json`); **not** self-install; **not** the menu |

### 2.3 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Type** | **Type O-S** off-TTY (self-install, ship unit only). **TTY menu kept** |
| **Default COMMAND** | TTY: menu handler; off-TTY 0-argv: `inst_self_install` |
| **Contrast Type N** | Type N off-TTY help does **not** apply while the README one-liner has no command token |

### 2.4 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: The documented one-liner and the dispatcher are the same path.  
- **Principle 1 – Caution**: A failed place is non-zero. A terminal with no words does not install.  
- **Principle 16 – Interactive**: The pipe does not prompt. Help stays the explicit `help` verb.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same split: TTY menu; non-interactive 0-argv self-install to the user bin at mode **0700** | Treat empty argv as `sudo` install or `pkg` ensure |

**This requirement:** non-interactive 0-argv still self-installs on Termux. It does not become help, and it does not gain admin privilege.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Place failure is loud. TTY 0-argv does not install.  
- **Intentional**: Type O-S for the pipe; menu for the terminal.  
- **Anti-fragile**: A checkout `sh path` with no words copies offline.  
- **Over-protect**: A Type N label does not waive the one-liner.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Route non-interactive 0-argv to help, or treat a green “Usage:” assertion as proof of the one-liner.  
2. Route TTY 0-argv to `inst_self_install`.  
3. Skip the online-install checklist because a file still says Type N, while the README shows `curl … \| sh` with no command token.  
4. Make bare invocation run domain `backup` or `pkg`.  
5. Make `install` an alias of `self-install`.

**Violating this rule is a critical dispatcher regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Off-TTY empty argv self-installs and does not show help; TTY empty argv shows the menu and does not install |
| AC-2 | Non-interactive empty argv is Type O-S. Type N help is not this product’s empty-argv law |
| AC-3 | `install` remains an explicit local command and is not the empty-argv handler |
| AC-4 | A stdin pipe (`cat ship \| sh`) with 0 argv is tested. `sh path` alone does not prove it |

---

## 6. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-shell-cli-interface` | Dispatcher command table |
| `requirement-shell-local-self-management` | Explicit install |
| `requirement-bootstrap-chain` | Trim of Type O from parent |
| `docs/requirements/index.md` | Registry |

---

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-07** | `tests/test_cli.sh` | have (off-TTY 0-argv copies; not help) |
| **TP-CLI-31** | `tests/test_cli.sh` | have (stdin pipe downloads; unreachable pipe is non-zero and not help) |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-03 | Active | Type N for local-only folder-backup |
| 2026-10-04 | Active 1.2.0 | Non-interactive 0-argv is Type O-S self-install. TTY menu stays. The one-liner must not show help |

---

**Last Updated**: 2026-10-04  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
