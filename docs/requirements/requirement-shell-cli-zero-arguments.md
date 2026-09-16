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
| **Empty-argv type** | **Hybrid** — TTY numbered menu; off-TTY Type O install-ensure |
| **Rationale** | Origin A (`selfmanaged`) is Type O (`curl \| sh`). Domain B claims a numbered menu. **TTY** empty argv shows the **main menu**; **off-TTY** / JSON / QUIET empty argv is **install-ensure**. |

Type N (off-TTY help) does **not** apply to off-TTY empty argv.

### 1.1 Human-facing

**In one sentence:** On a terminal, running `tmpl-to-prj` with no words shows the numbered list; under a pipe (`curl | sh`) it installs or confirms it is already installed.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator at a terminal | `tmpl-to-prj` then `9` |
| The other role | One-liner / automation | `curl -fsSL …/tmpl-to-prj \| sh` |
| Not this file | What the numbered rows are | `requirement-shell-cli-default-interaction` |

| Includes | Excludes |
|----------|----------|
| TTY menu; off-TTY Type O | Off-TTY empty argv as help |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Open the menu | Empty argv on a TTY | `tmpl-to-prj` |
| First install from the internet | Empty argv off-TTY | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj \| sh` |

---

## 2. Core Rules (Mandatory)

### 2.1 Single meaning of empty argv

1. When **argv is empty** (`$# -eq 0` at entry to `app_main`) **and** `TTY=1` **and** not JSON/quiet, the dispatcher **MUST** route to the main menu (`app_default`) — `requirement-shell-cli-default-interaction`.  
2. When argv is empty **and** (`TTY=0` **or** JSON **or** quiet), the dispatcher **MUST** perform **Type O install-ensure** (`inst_perform_install` / `inst_maybe_install`): not installed → install; already installed → success no-op; failure **MUST** be non-zero.  
3. Explicit `tmpl-to-prj help` remains a valid full-usage path.  
4. Explicit `tmpl-to-prj install` remains a valid install path.  
5. Script entry **MUST** always call `app_main "$@"` (no basename product-name gate that blocks dispatch).

### 2.2 Normative matrix

| Invocation | Behavior |
|------------|----------|
| `tmpl-to-prj` (no args, TTY, not JSON/quiet) | Main menu; exit 0 after pick or Exit |
| `tmpl-to-prj` (no args, off-TTY) | Type O install-ensure |
| `curl … \| sh` | Type O install-ensure (off-TTY) |
| `tmpl-to-prj help` | Show help; exit 0 |
| `tmpl-to-prj install` | Install ensure (download channel) |
| Flags only (e.g. `--json` with no command) | After flag parse with no command token: **help** (not empty argv) |

### 2.3 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Type** | Hybrid: TTY menu; off-TTY Type O |
| **Default COMMAND** | TTY: menu handler; off-TTY: install-ensure |
| **Channel** | Config `SCRIPT_URL` default `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj` |

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
| Same empty-argv split (TTY menu / off-TTY Type O) | Treat empty argv as `sudo` install or `pkg` ensure |

**This requirement:** off-TTY empty argv still installs to **user bin** on Termux (no `sudo`).

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Off-TTY empty argv is install-ensure; TTY empty argv is the menu.  
- **Intentional**: Hybrid declared in law (A Type O + B menu).  
- **Anti-fragile**: `curl \| sh` still works.  
- **Over-protect**: Do not drop Type O off-TTY while claiming the same architecture as selfmanaged.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Change off-TTY empty argv to help while the product remains online-installable.  
2. Replace TTY empty argv with install-ensure (drop the numbered menu) without updating default-interaction law.  
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
| `requirement-shell-self-management` | Explicit install |
| `requirement-bootstrap-chain` | Inherit Type O off-TTY from selfmanaged |
| `docs/requirements/index.md` | Registry |

---

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-07 / Type O empty argv** | `tests/test_cli.sh` · `tests/test_install_lifecycle.sh` | have |

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
