**file**: docs/requirements/requirement-shell-sudo-command.md  
**Status**: Active (Version 1.3.0)  
**Area**: shell  
**Key**: `requirement-shell-sudo-command`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **in-tool sudo** on tmpl-to-prj: one wrapping function, **check before sudo**, and the only allowed elevated argv — sibling `folder-backup backup <dest-root>`.

### 1.1 Human-facing

**In one sentence:** When dest backup needs root, this CLI calls `sudo folder-backup backup <project-root>` after proving the matching sudoers line — it never `sudo cp`s docs itself.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator | Matching NOPASSWD or a terminal password |
| The other role | Sibling `folder-backup` | The elevated program |
| Not this file | Overlay of docs | `requirement-domain-tmpl-to-prj` |

| Includes | Excludes |
|----------|----------|
| `util_sudo`; skip sudo when already root | This product’s `print-sudoers`; OS-tool grants |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Apply with a ready grant | Dest archive then overlay | `tmpl-to-prj apply --force sh-cli-template grok-cli` |

---

## 2. Core Rules (Mandatory)

C0–C6 (check before sudo + wrap):

| # | This product |
|---|--------------|
| **C0** | Every in-tool `sudo` is this wrap. chmod is **not** this product’s elev case. |
| **C1** | Probe is **already-root** (`id -u` = 0). **MUST NOT** use `[ -O dest]` to skip `folder-backup backup` (deposit still needs root). |
| **C2** | Probe match → **MUST NOT** `sudo`. |
| **C3** | Probe miss → `util_sudo` may run the allow-table argv. `sudo -n` **only** when that row is NOPASSWD and matches the full argv. Else TTY password `sudo`. |
| **C4** | **MUST NOT** probe `sudo true` / `sudo mkdir` / `sudo cp` / `sudo ls` / `sudo stat`. |
| **C5** | Already-root **MUST** run the argv without `sudo`. |
| **C6** | Exactly one wrap (`util_sudo`). **MUST NOT** scatter `sudo`. |

Also:

1. **MUST** publish a **sudo allow table** from a **studied** fragment (`print-sudoers` dest, readable file, or `sudo -n -l`). **MUST NOT** guess dest or argv.  
2. This wrap **MUST** pass only the allow-table row with **This wrap? = yes**.  
3. **MUST NOT** hang on a password under `--json` / non-TTY when no matching NOPASSWD exists — fail closed with Next.  
4. Fixture `T2P_BACKUP_NOSUDO=1` **MAY** skip sudo (CI stub). Production apply **MUST NOT** set that flag.  
5. This CLI **MUST NOT** emit sudoers. Sibling `print-sudoers` is the emit path. Create-sudoers / sudoers-content checklists are **N/A**.  
6. On a **command line for normal user only** (Termux, Git Bash, Windows cmd), `util_sudo` **MUST** return non-zero **without** invoking `sudo`. Folder-backup gate **MUST** be **missing** (local dest-docs snapshot). **MUST NOT** recommend `sudo` as Next on that class.

Worked wrap (C5 then password `sudo`; NOPASSWD uses `sudo -n` only for the allow-table row):

```sh
util_sudo() {
    if [ "$(id -u 2>/dev/null || echo 1)" -eq 0 ]; then
        "$@"
        return $?
    fi
    command -v sudo >/dev/null 2>&1 || return 1
    sudo "$@"
}
```

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Wrap | `util_sudo` in `src/tmpl-to-prj` |
| Caller | `t2p_backup_dest` |
| Sudoers file family | Sibling dest `/etc/sudoers.d/folder-backup-{{username}}` (legacy `/etc/sudoers.d/folder-backup`). Optional `/etc/{{username}}/folder-backup` is **not** the sibling dest. |
| Grant shape | `NOPASSWD: {{GLOBAL_BIN}}/folder-backup backup *` |

Sudo allow table (studied from sibling `print-sudoers` dest + readable fragment + `sudo -n -l`; **this wrap**):

| Binary | Verb | Operand | Fragment dest | NOPASSWD? | This wrap? |
|--------|------|---------|---------------|-----------|------------|
| `{{GLOBAL_BIN}}/folder-backup` | `backup` | `*` (one extra folder = dest root) | `/etc/sudoers.d/folder-backup-{{username}}` | yes | **yes** — only allowed `util_sudo` argv |

Sibling fragment **also** lists `restore *`. That is **not** this wrap. `print-sudoers` **also** emits `--json backup *` / `--json restore *`; the installed fragment and `sudo -n -l` on this host do **not**. This CLI **MUST NOT** wrap those argvs.

### 2.2 Why This Requirement Exists (CIAO)

- **Principle 10 – Least privilege**: One sibling argv, not OS tools.  
- **Principle 1 – Caution**: Check before sudo (C0–C6).  
- **Principle 9**: Elevation is the sibling’s Type 1 surface, not this product’s emit.  
- **Principle 16**: Off-TTY / `--json` must not hang on a password.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| `util_sudo` no-ops (non-zero, no `sudo` binary) | In-tool `sudo`; wrap `apt`/`dnf`; write `/etc`; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** owns the wrap skip on detect. Termux `pkg` companion is `requirement-shell-termux-ish`.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles

- **Caution:** Grant-too-narrow is not “no TTY”.  
- **Intentional:** One wrap.  
- **Anti-fragile:** Already-root skips sudo.  
- **Over-protect:** No `/etc` writes from this CLI.

---

## 4. Protection Rule (Sacred)

**MUST NOT** emit sudoers, wrap `cp`/`rm`/`tar`/`restore`/`--json` with sudo, guess fragment dest or argv, treat a missing `/etc/{{username}}/folder-backup` as verb-only, skip detect of `/etc/sudoers.d/folder-backup-{{username}}` when the global binary exists on a POSIX host, or invoke `sudo` when Termux / Git Bash / Windows cmd is detected.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | Gate + dest backup |
| `docs/requirements/requirement-shell-script-coding.md` | Points here |
| `docs/requirements/requirement-shell-termux-ish.md` | Detect freeze |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-TMPL-TO-PRJ-07** | `tests/test_domain_tmpl_to_prj.sh` | have (observed verb-only fail) |
| **TP-TMPL-TO-PRJ-14..16** | `tests/test_domain_tmpl_to_prj.sh` | have (star dest / unproven ≠ verb-only) |
| **TP-TX-06** / **TP-TX-07** | `tests/test_termux.sh` | have (Termux / Git Bash: stub `sudo` not invoked) |

Checklist gates (IDs; filled basenames, no harness folder prefix):

| Gate | Status |
|------|--------|
| **CL-LEAST-PRIVILEGE** | have (`2026-09-02-checklist-least-privilege-tmpl-to-prj-sudo.md`) |
| **CL-SHELL-TTY-PRIVILEGE-TRAPS** | have (`2026-09-02-checklist-shell-tty-privilege-traps-tmpl-to-prj-sudo.md`) |
| **CL-CREATE-SUDOERS-SECURITY** | n/a — this CLI does not emit sudoers |
| **CL-SUDOERS-FILE-CONTENT** | n/a — this CLI does not emit sudoers |

**Last Updated**: 2026-09-06  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
