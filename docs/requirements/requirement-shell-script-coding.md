**file**: docs/requirements/requirement-shell-script-coding.md  
**Status**: Active (Version 1.0.1)  
**Area**: shell  
**Key**: `requirement-shell-script-coding`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **POSIX `/bin/sh` coding style** of tmpl-to-prj. **Without this file, portable shell lessons arrive raw.**

### 1.1 Human-facing

**In one sentence:** The ship unit is one `/bin/sh` file: `out_*` for messages, `t2p_*` for the docs hop, `set -u`, no silent success.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Edit `src/tmpl-to-prj` | Follow prefixes |
| The other role | Modular-function REQ owns the prefix table | `requirement-shell-modular-function-design` |
| Not this file | Domain overlay semantics | `requirement-domain-tmpl-to-prj` |

| Includes | Excludes |
|----------|----------|
| Interpreter, unset handling, no raw product `echo` | Sudoers JSON schema; dest backup deposit path |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Change the CLI | Keep `out_*` / `t2p_*` / `set -u` | Open `src/tmpl-to-prj` |

---

## 2. Core Rules (Mandatory)

1. **MUST** ship as POSIX `/bin/sh` (`#!/bin/sh`), `set -u`, explicit `out_die` (not global `set -e`).  
2. **MUST** use defined prefixes (`out_`, `inst_`, `util_`, `app_`, `t2p_`, `prompt_`).  
3. **MUST NOT** print product messages with raw `echo`/`printf` outside `out_*` (class-B return-via-stdout excepted).  
4. **MUST** measure `[ -t 0 ]` / `[ -t 1 ]` for TTY **outside** functions at entry; helpers consume `TTY`.  
5. Temps **MUST** use `mktemp` under storage `TMPDIR`, not `$$` names.  
6. In-tool sudo **MUST** use `util_sudo` (`requirement-shell-sudo-command`) — this file **points**, it does not own the wrap body.  
7. Output SSOT **points** at `requirement-shell-output-requirements`. Prefix table **points** at `requirement-shell-modular-function-design`.

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Ship unit | `src/tmpl-to-prj` |
| Interpreter | `/bin/sh` |
| Domain prefix | `t2p_` |
| Version SSOT | `VERSION=` hard-assign in `src/tmpl-to-prj` |

### 2.2 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: Style is law so later hops do not dump raw lessons.  
- **Principle 5 – Output SSOT**: `out_*` only.  
- **Principle 16 – Interactive**: TTY measured outside functions.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Helpers consume `TTY`; in-tool elev only via `util_sudo` (which skips on this class) | Add `sudo` / `apt` / `useradd` in new helpers |

**This requirement:** coding of helpers must not grow Type 1/2 on detect.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles

- **Caution:** Assume unset HOME.  
- **Intentional:** One ship unit.  
- **Anti-fragile:** Isolated tests.  
- **Over-protect:** Fail closed; no OS-tool sudoers from this product.

---

## 4. Protection Rule (Sacred)

**MUST NOT** add `set -e` as the only error policy, drop prefixes, or treat coding skills as product law in place of this file.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix table |
| `docs/requirements/requirement-shell-sudo-command.md` | `util_sudo` |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-01** | `tests/test_cli.sh` | have |
| **TP-CLI-11** | `tests/test_cli.sh` | have |

Privilege TTY / least-privilege checklists: **point** at `requirement-shell-sudo-command` (**`CL-LEAST-PRIVILEGE`** · **`CL-SHELL-TTY-PRIVILEGE-TRAPS`**).

**Last Updated**: 2026-09-02  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
