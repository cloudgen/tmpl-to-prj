**file**: docs/requirements/requirement-shell-cli-default-interaction.md  
**Status**: Active (Version 1.6.1)  
**Area**: shell  
**Key**: `requirement-shell-cli-default-interaction`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

tmpl-to-prj **claims** a default function: a **numbered main menu** of `plan`, `apply`, and **8** self-management. The self-management board lists **82–87**. This file merges the tmpl-to-prj domain rows with the selfmanaged menu law (2026-10-04). **Interactive** empty argv **MUST** show this menu and **MUST NOT** self-install. **Non-interactive** empty argv **MUST** self-install (Type O-S) and **MUST NOT** show this menu or help. Command **`menu`** (alias **`main`**) uses the same handler. Off-TTY `menu` still prints help and **MUST NOT** hang.

### 1.1 Human-facing

**In one sentence:** At a real terminal, typing only `tmpl-to-prj` shows plan, apply, and self-management; a pipe with no words places the program.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Pick 1 or 2, then names | `tmpl-to-prj` then `2` |
| The other role | CI / pipe | empty argv = self-install, not this menu |
| Not this file | Install / version on the list | those stay on `help` |

| Includes | Excludes |
|----------|----------|
| Rows `plan`, `apply`, **8** self-management; Exit **9**; under **8** the rows **82–87** and **0** Back | Front-board `install`, `version`, `about`, `help`, or `menu` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Preview at a prompt | Menu row 1 then names | `tmpl-to-prj` then `1` |
| Leave | Exit | `9` |

---

## 2. Core Rules (Mandatory)

### 2.1 Claim and case

Claimed **yes**. Zero-argument REQ exists. TTY empty argv **MUST** use this menu and **MUST NOT** self-install. Off-TTY empty argv **MUST** self-install and **MUST NOT** open this menu (zero-arguments). JSON or quiet with no command **MUST NOT** open this menu and **MUST NOT** self-install.

### 2.2 `menu` / `main`

| Mode | `--json` | MUST |
|------|----------|------|
| Interactive (`TTY=1`) | **Ignore** `--json` | Draw the menu |
| Non-interactive (`TTY=0`) | Follow `--json` | `app_help` (human or JSON help); **MUST NOT** hang |

### 2.3 Main menu

Labels **MUST** be `command: what it does`.

Header **MUST** print **`${APP_NAME}`**(*`${VERSION}`*) (app-name-version-display): live Config `APP_NAME` immediately followed by parenthesized live Config `VERSION`, no space. **`APP_NAME` bold**, **`VERSION` italic**. TTY: SGR 1 / SGR 3 via `util_app_ident`. Off-TTY: plain. **MUST NOT** a bare `${APP_NAME}` on that header. Typical: `[INFO] **tmpl-to-prj**(*1.1.0*) — numbered list of live commands`.

| # | Token | Label |
|---|-------|-------|
| 1 | `plan` | `plan: Show template and project roots (no writes)` |
| 2 | `apply` | `apply: Copy harness docs from the template into the project` |
| **8** | `self-management` | `self-management: this CLI install, version, update, uninstall` |
| 9 | Exit | `Exit` (not a routed-verb) |

1. **9**, **99**, `exit`, `quit`, or an empty line on the front board **MUST** return 0.  
2. **8** or `self-management` **MUST** open the self-management board.  
3. A typed leaf listed under **8** (`version`, `about`, `version-check`, `self-update`, `self-uninstall`, `self-install`) **MAY** run from the front prompt, then the front board **MUST** show again.  
4. `install` is not a listed row (**81** is reserved). Typing it on the menu is a bad pick. The CLI verb `install` stays outside the menu. `help`, `menu`, and `main` **MUST NOT** be rows.  
5. Each command row **MUST** be `N. short: explain` via `out_menu_choice`. On a TTY the short name is bold (SGR **1**) and the explain is italic light gray (SGR **3** + **37**). Exit has no explain.  
6. A bad pick **MUST** `out_error`, name the pick, reprint **this** layer, and read again. **MUST NOT** `out_die`.  
7. A finished `plan`, `apply`, or self-management leaf **MUST** show the front board again. **MUST NOT** leave the program only because the command finished. Picker cancel still returns here.  
8. After `plan`/`apply`, when names are missing on TTY, **MUST** show a numbered **template** list then a numbered **project** list (the current folder when it is a directory and not a refused path, then directory children of the RAM parent and `PROJECTS_ROOT`). A project row is any existing directory (domain SSOT). Template rows **MUST** be unspecialized kits only (domain SSOT). Each of those pickers **MUST** print **0. Back to main menu** as the only numbered back row. **MUST NOT** print a second Back row (**9** / **99**). Choosing **0** (or the all-nines number when it is not an item) **MUST** return to this main menu and **MUST NOT** exit the process.  
9. **MUST NOT** list test-purpose verbs (`list-templates` / `list-projects`) on this main list. **MUST NOT** put `sudo` or `pkg` on the list.

### 2.3.1 Self-management board (parent 8)

**81** `install` stays reserved and **MUST NOT** be printed. Do not renumber **82–87**.

| # | Token | Label |
|---|-------|-------|
| **82** | `version` | `version: show current version` |
| **83** | `about` | `about: show detailed diagnostics` |
| **84** | `version-check` | `version-check: compare local vs remote version` |
| **85** | `self-update` | `self-update: update tmpl-to-prj to a newer remote version` |
| **86** | `self-uninstall` | `self-uninstall: remove tmpl-to-prj` |
| **87** | `self-install` | `self-install: place this CLI only (copy when $0 is a script; download when piped)` |
| **0** | Back | return to the front board |

1. **0**, `back`, or an empty line **MUST** return to the front board and **MUST NOT** run a verb.  
2. A listed number or its token **MUST** run that handler, then the **front** board **MUST** show again.  
3. **9** is not a row on this board. It is a bad pick here.  
4. Header **MUST** be `util_app_ident` plus `— self-management`, via `out_info`.

Handler: `app_default` / `app_default_print_menu` / `app_default_print_self_menu` / `app_default_self_loop` / `app_default_run_self_leaf` / `app_default_run_pick` / `out_menu_choice` / `util_app_ident`.

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
| Same numbered list (`plan` / `apply` / **8** / Exit 9, and **82–87** under **8**) | Put `install`, `sudo`, or `pkg` on the menu |

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

**MUST NOT** put `install`, `version`, `about`, `help`, or `menu` on the **front** board, print **81**, renumber **82–87**, number Exit as 3, `out_die` on a bad pick, hang CI on empty argv, print a bare `${APP_NAME}` on the main-menu header, omit **0. Back to main menu** on TTY name pickers, print a second all-nines Back row, or treat picker **0** as process Exit.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Off-TTY empty argv = self-install; TTY = this menu |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | plan / apply semantics |
| `docs/requirements/requirement-shell-cli-interface.md` | `menu` / `main` tokens |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-TMPL-TO-PRJ-10** | `tests/test_domain_tmpl_to_prj.sh` | have |
| **TP-CLI-07** | `tests/test_cli.sh` | have (off-TTY empty argv self-installs; not this menu) |
| **TP-CLI-31** | `tests/test_cli.sh` | have (stdin pipe self-installs; not help) |
| **TP-CLI-17** | `tests/test_cli.sh` | have (menu header `${APP_NAME}(${VERSION})` bold/italic on TTY; row 8) |
| **TP-CLI-26** | `tests/test_cli.sh` | have (board 82–87, 0 Back, no 81) |
| **TP-CLI-27** | `tests/test_cli.sh` | have (finished 82 redisplays the front board) |
| **TP-CLI-28** | `tests/test_cli.sh` | have (bad pick reprints; process stays up) |
| **TP-TMPL-TO-PRJ-19** | `tests/test_domain_tmpl_to_prj.sh` | have (TTY picker **0** returns to main menu; no duplicate 9 Back row) |

**Last Updated**: 2026-10-07 (1.6.1 project picker lists any directory; domain SSOT owns the dest rule)  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
