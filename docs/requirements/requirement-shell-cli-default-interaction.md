**file**: docs/requirements/requirement-shell-cli-default-interaction.md  
**Status**: Active (Version 1.3.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-default-interaction`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

tmpl-to-prj **claims** a default function: a **numbered main menu** of `plan` and `apply`. `requirement-shell-cli-zero-arguments` exists (not online-installable). **Interactive** empty argv **MUST** show this menu. **Non-interactive** empty argv **MUST** stay help. Command **`menu`** (alias **`main`**) uses the same handler.

### 1.1 Human-facing

**In one sentence:** At a real terminal, typing only `tmpl-to-prj` shows numbered plan/apply; in a script it prints help.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Pick 1 or 2, then names | `tmpl-to-prj` then `2` |
| The other role | CI / pipe | empty argv = help |
| Not this file | Install / version on the list | those stay on `help` |

| Includes | Excludes |
|----------|----------|
| Rows `plan` and `apply`; Exit **9** | `help`, install, uninstall, where-is-me, version, about, `menu` itself |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Preview at a prompt | Menu row 1 then names | `tmpl-to-prj` then `1` |
| Leave | Exit | `9` |

---

## 2. Core Rules (Mandatory)

### 2.1 Claim and case

Claimed **yes**. Zero-argument REQ exists; product is **non-online-installable**. TTY empty argv **MUST** use this menu. Off-TTY empty argv **MUST** be help (zero-arguments).

### 2.2 `menu` / `main`

| Mode | `--json` | MUST |
|------|----------|------|
| Interactive (`TTY=1`) | **Ignore** `--json` | Draw the menu |
| Non-interactive (`TTY=0`) | Follow `--json` | `app_help` (human or JSON help); **MUST NOT** hang |

### 2.3 Main menu

Labels **MUST** be `command: what it does`.

Header **MUST** print **`${APP_NAME}`**(*`${VERSION}`*) (app-name-version-display): live Config `APP_NAME` immediately followed by parenthesized live Config `VERSION`, no space. **`APP_NAME` bold**, **`VERSION` italic**. TTY: SGR 1 / SGR 3 via `util_app_ident`. Off-TTY: plain. **MUST NOT** a bare `${APP_NAME}` on that header. Typical: `[INFO] **tmpl-to-prj**(*1.2.1*) — numbered list of live commands`.

| # | Token | Label |
|---|-------|-------|
| 1 | `plan` | `plan: Show template and project roots (no writes)` |
| 2 | `apply` | `apply: Copy harness docs from the template into the project` |
| 9 | Exit | `Exit` (not a routed-verb) |

N = 2 → Exit **9**. Accept number or verb. After `plan`/`apply`, when names are missing on TTY, **MUST** show a numbered **template** list then a numbered **project** list (current folder if it is a project, then `PROJECTS_ROOT`). Template rows **MUST** be unspecialized kits only (domain SSOT). Each of those pickers **MUST** print **0. Back to main menu** as the only numbered back row. **MUST NOT** print a second Back row (**9** / **99**). Choosing **0** (or the all-nines number when it is not an item) **MUST** return to this main menu and **MUST NOT** exit the process. **MUST NOT** list install/setup, self-managed, version, about, help, or test-purpose verbs (`list-templates` / `list-projects` stay off this main list).

Handler: `app_default` / `app_default_print_menu` / `app_default_run_pick` / `util_app_ident`.

### 2.4 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product | `tmpl-to-prj` |
| Claimed | yes |
| Case | TTY empty argv = menu (zero-arg retarget on B) |
| Exit | 9 |
| Header | `util_app_ident` → **`${APP_NAME}`**(*`${VERSION}`*) |

### 2.5 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: Claimed menu; labels match the kept command list.  
- **Principle 16 – Interactive**: No hang off-TTY.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same numbered list (`plan` / `apply` / Exit 9) | Put `install` / `sudo` / `pkg` on the menu |

**This requirement:** menu membership is unchanged on Termux.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles

- **Caution:** Off-TTY never waits on Choice.  
- **Intentional:** Two operational rows only.  
- **Anti-fragile:** `menu` aliases `main`.  
- **Over-protect:** Lifecycle verbs stay off the list.

---

## 4. Protection Rule (Sacred)

**MUST NOT** put install/version/about/help on the numbered list, number Exit as 3, hang CI on empty argv, print a bare `${APP_NAME}` (no parenthesized `${VERSION}`, unstyled on TTY) on the main-menu header, omit **0. Back to main menu** on TTY name pickers, print a second all-nines Back row, or treat picker **0** as process Exit.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Off-TTY empty argv = help |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | plan / apply semantics |
| `docs/requirements/requirement-shell-cli-interface.md` | `menu` / `main` tokens |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-TMPL-TO-PRJ-10** | `tests/test_domain_tmpl_to_prj.sh` | have |
| **TP-CLI-07** | `tests/test_cli.sh` | have (off-TTY empty argv = help) |
| **TP-CLI-17** | `tests/test_cli.sh` | have (menu header `${APP_NAME}(${VERSION})` bold/italic on TTY) |
| **TP-TMPL-TO-PRJ-19** | `tests/test_domain_tmpl_to_prj.sh` | have (TTY picker **0** returns to main menu; no duplicate 9 Back row) |

**Last Updated**: 2026-09-03  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
