**file**: docs/requirements/requirement-shell-termux-ish.md  
**Status**: Active (Version 1.0.0)  
**Area**: shell  
**Key**: `requirement-shell-termux-ish`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **Termux as a target system** of tmpl-to-prj: detect Termux-like userspace, keep **normal user privilege** only, and own the named `pkg` companion. This product is a POSIX `/bin/sh` script; the named package list is **empty**. Wrapping Linux `apt`/`dnf` is **not** a substitute.

### 1.1 Human-facing

**In one sentence:** On Termux you install and run this CLI as yourself; it does not call `sudo`, and it does not run `pkg` because it needs no extra packages.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Termux login that owns `$PREFIX` | `tmpl-to-prj install` then `tmpl-to-prj plan kit dest` |
| The other role | Linux host with root (not this class) | `sudo tmpl-to-prj install` on a multi-user POSIX host |
| Not this file | Overlay of dest docs | `requirement-domain-tmpl-to-prj` |

| Includes | Excludes |
|----------|----------|
| Detect via `PREFIX` / `TERMUX_VERSION` / Termux usr tree | Wrapping Linux `apt`/`dnf`/`yum` |
| Empty named `pkg` table (no extra tokens) | Unbounded `pkg upgrade` / `pkg uninstall` |
| Skip in-tool `sudo` on detect | Recommending `sudo curl \| sh` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tmpl-to-prj` | ship unit | `util_is_termux` / `t2p_termux_pkg_ensure` |
| `tmpl-to-prj install` | command | local copy into `${USER_BIN}` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Run on Termux | Same hop; dest backup is a local docs snapshot, not `sudo folder-backup` | `tmpl-to-prj apply --force sh-cli-template grok-cli` |
| Install on Termux | User bin only; do not use `sudo` | `sh src/tmpl-to-prj install` |

---

## 2. Core Rules (Mandatory)

### 2.1 Detect

Implementation **MUST** treat any one of these as Termux-ish:

| Signal | Meaning |
|--------|---------|
| `PREFIX` contains `com.termux` | Termux prefix |
| `TERMUX_VERSION` set | Termux environment |
| `/data/data/com.termux/files/usr` exists | Termux usr tree |

Off detect → **MUST NOT** call `pkg`; **MUST NOT** wrap `apt`/`dnf`/`yum`.

On Termux detect, **admin privilege** (Type 1) and **dedicated system user privilege** (Type 2) **MUST** stay unused. Git Bash and Windows cmd are the same privilege class; **MUST NOT** call Termux `pkg` there.

### 2.2 Named package table (this product)

| Package | Why | Owner |
|---------|-----|-------|
| *(none)* | This product is POSIX `/bin/sh`. Termux already ships `sh`. No extra `pkg` tokens. | this file |

**MUST NOT** run unnamed / wildcard `pkg` ensure. An empty table **MUST NOT** invoke `pkg` (including `upgrade`, unrelated `uninstall`, interactive `search`).

Domain REQ **MUST NOT** list wrapping `pkg` as a non-goal. If a later domain need names a package, add a row here in the same change.

### 2.3 Invoke

| Host | MUST | MUST NOT |
|------|------|----------|
| **Termux-ish** | Call `t2p_termux_pkg_ensure` from `inst_local_install`. Empty table → return 0 without `pkg` | Hang on `pkg` prompts; wrap `apt` |
| **Not Termux-ish** | No-op | Wrap `apt` / `dnf` / `yum` as a substitute |
| **`pkg` missing** (only if a named row exists) | Fail closed; Next names the same `pkg install -y …` line | Pretend payloads are ready |
| **`pkg` non-zero** (only if a named row exists) | Fail closed | Continue as success |

Interactive empty argv **MUST NOT** run package ensure as a side effect.

### 2.4 Privilege fence on this class

| Tool | Privilege | In this requirement? |
|------|-----------|----------------------|
| Termux `pkg` as this login into `$PREFIX` | Invoker (**normal user privilege**) | **Yes** (empty table today) |
| Linux `apt`/`dnf`/`yum` | **admin privilege** | **No** |
| In-tool `sudo` | `requirement-shell-sudo-command` | **No** — **MUST NOT** call `sudo` on detect |

On detect, folder-backup dest archive **MUST** fall through to the local dest-docs snapshot (gate **missing**). **MUST NOT** probe `/etc/sudoers.d` as a reason to run `sudo`.

Global install (`--global` / root path) **MUST** fail closed on this class with Next: user-bin `install` — **MUST NOT** recommend `sudo`.

Worked detect + empty ensure (illustration of this product):

```sh
util_is_termux() {
    [ -n "${PREFIX:-}" ] && case "${PREFIX}" in *com.termux*) return 0 ;; esac
    [ -n "${TERMUX_VERSION:-}" ] && return 0
    [ -d /data/data/com.termux/files/usr ] && return 0
    return 1
}

t2p_termux_pkg_ensure() {
    util_is_termux || return 0
    return 0
}
```

### 2.5 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product / APP_NAME | `tmpl-to-prj` |
| Ship unit | `src/tmpl-to-prj` |
| Detect helpers | `util_is_termux` · `util_is_git_bash` · `util_is_windows_cmd` · `util_is_normal_user_only_cli` |
| Ensure helper | `t2p_termux_pkg_ensure` (empty table) |
| Call site | `inst_local_install` |
| Local install dest | `${USER_BIN}/${APP_NAME}` (default `${HOME}/.local/bin/tmpl-to-prj`; operator **MAY** set `USER_BIN` to `$PREFIX/bin`) |
| RAM-drive parent | Default `/dev/shm`; on Termux that path is often absent → hard-disk `${PROJECTS_ROOT}` |

Invocation samples:

```text
tmpl-to-prj install
tmpl-to-prj plan sh-cli-template grok-cli
tmpl-to-prj apply --force sh-cli-template grok-cli
```

### 2.6 Why This Requirement Exists (CIAO)

- **Principle 1 – Caution**: Detect before `pkg` or `sudo`.  
- **Principle 2 – Intentional**: Termux is a named target; empty package table is honest.  
- **Principle 9 – Command types**: Termux `pkg` stays **normal user privilege**; not host `apt`.  
- **Principle 10 – Least privilege**: No sudo on this class.  
- **Principle 13 – Multi environment**: POSIX Linux and Termux.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Termux: named `pkg` as this login remains this layer (empty table today) | In-tool `sudo`; wrap `apt`/`dnf`/`yum`; write `/etc` dests; `useradd`; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same privilege ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** owns Termux detect and the empty `pkg` companion; sudo skip is also `requirement-shell-sudo-command`.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`; `uname -s` is `MINGW*` / `MSYS*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Empty table must not become unbounded `pkg`.  
- **Intentional:** Termux is a target; Linux `apt` is not in scope.  
- **Anti-fragile:** Off-detect skip; missing `/dev/shm` falls through.  
- **Over-protect:** Detect freezes Type 1/2 even if `sudo` exists on PATH.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Treat wrapping Termux `pkg` as a default non-goal or as **admin privilege** host bootstrap.  
2. Equate Termux `pkg` with Linux `apt`/`dnf`/`yum`.  
3. Wrap Linux `apt` because `pkg` is in scope.  
4. Run unnamed / unbounded `pkg`.  
5. Invoke `sudo` / write `/etc` when Termux, Git Bash, or Windows cmd is detected.  
6. Recommend `sudo curl \| sh` on this class.  
7. Strip the **Under command line for normal user only** section.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-local-self-management.md` | `install` call site |
| `docs/requirements/requirement-shell-sudo-command.md` | `util_sudo` skip on detect |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention of `install` |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | Dest backup falls to local snapshot |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-TX-01** | `tests/test_termux.sh` | have (not Termux: stub `pkg` not invoked) |
| **TP-TX-02** | `tests/test_termux.sh` | have (Termux mock: empty table; stub `pkg` not invoked) |
| **TP-TX-06** | `tests/test_termux.sh` | have (Termux detect: stub `sudo` not invoked; apply uses local snapshot) |
| **TP-TX-07** | `tests/test_termux.sh` | have (Git Bash `MSYSTEM`: stub `sudo` not invoked) |
| **TP-TX-08** | `tests/test_termux.sh` | have (`install --global` on Termux mock fails without recommending `sudo`) |
| **TP-TX-03** / **TP-TX-04** | — | n/a until a named package row exists |

**Last Updated**: 2026-09-06  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
