**file**: docs/requirements/requirement-shell-cli-zero-arguments.md  
**Status**: Active (Version 1.0.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-zero-arguments`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **zero-argument (empty argv) dispatcher behavior** of the tmpl-to-prj POSIX shell CLI.

### 1.0 Product type

| Field | Value for tmpl-to-prj |
|-------|-------------------------|
| **Empty-argv type** | **Type N — Non-online-install** |
| **Rationale** | Product is **local-only**; no `curl \| sh` channel; **TTY** empty argv shows the **main menu**; **off-TTY** empty argv shows **help**, not install-ensure |

Type O (online-install empty-argv = install-ensure) does **not** apply.

### 1.1 Human-facing

**In one sentence:** On a terminal, running `tmpl-to-prj` with no words shows the numbered list; in a script it prints help.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator at a terminal | `tmpl-to-prj` then `9` |
| The other role | Automation / pipe | `tmpl-to-prj` prints help; does not hang |
| Not this file | What the numbered rows are | `requirement-shell-cli-default-interaction` |

| Includes | Excludes |
|----------|----------|
| TTY menu; off-TTY help | Empty argv as install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open the menu | Empty argv on a TTY | `tmpl-to-prj` |

---

## 2. Core Rules (Mandatory)

### 2.1 Single meaning of empty argv

1. When **argv is empty** (`$# -eq 0` at entry to `app_main`) **and** `TTY=1`, the dispatcher **MUST** route to the main menu (`app_default`) — `requirement-shell-cli-default-interaction`.  
2. When argv is empty **and** `TTY=0`, the dispatcher **MUST** route to **`help`** (`app_help`).  
3. Empty argv **MUST NOT** perform install or any state-changing ensure.  
4. Explicit `tmpl-to-prj help` remains a valid full-usage path.  
5. Explicit `tmpl-to-prj install` remains the only first-time local install path (plus documented force refresh).  
6. Script entry **MUST** always call `app_main "$@"` (no basename product-name gate that blocks dispatch).

### 2.2 Normative matrix

| Invocation | Behavior |
|------------|----------|
| `tmpl-to-prj` (no args, TTY) | Main menu; exit 0 after pick or Exit |
| `tmpl-to-prj` (no args, off-TTY) | Show help; exit 0 |
| `tmpl-to-prj help` | Show help; exit 0 |
| `tmpl-to-prj install` | Local install ensure |
| Flags only (e.g. `--json` with no command) | **MUST** still resolve to help (or fail with clear usage if product chooses fail-closed) — default: **help** after flag parse with no command token |

### 2.3 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Type** | **Type N** (local-only; TTY menu is still not install-ensure) |
| **Default COMMAND** | TTY: menu handler; off-TTY: `help` |
| **Contrast Type O** | Type O install-ensure is **not** this origin’s empty-argv law |

### 2.4 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: Empty argv meaning is explicit and not left as “whatever the parent did.”  
- **Principle 1 – Caution**: Avoid surprise install on bare invocation for an ops CLI.  
- **Principle 16 – Interactive**: Help is the safe human default for local tools.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same empty-argv split (TTY menu / off-TTY help) | Treat empty argv as `sudo` install or `pkg` ensure |

**This requirement:** empty argv still is not install-ensure on Termux.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: No silent ensure on empty argv.  
- **Intentional**: Type N declared in law.  
- **Anti-fragile**: Help works offline.  
- **Over-protect**: Do not reintroduce Type O without reclassifying product install mode.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Change empty argv to install-ensure while the product remains local-only.  
2. Copy Type O empty-argv law wholesale without updating this file and install mode.  
3. Make bare invocation run domain `backup`.

**Violating this rule is a critical dispatcher regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Off-TTY empty argv shows help and does not install; TTY empty argv shows the menu |
| AC-2 | Type N is the declared empty-argv type |
| AC-3 | `install` remains an explicit command |

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
| **TP-CLI-07** | `tests/test_cli.sh` | have |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-03 | Active | Type N for local-only folder-backup |

---

**Last Updated**: 2026-08-03  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
