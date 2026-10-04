# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.5.1] - 2026-10-04

### Fixed

- **INC-20261004-002**: After the folder-backup gate passed, a non-zero `folder-backup backup` was reported as “check sudoers argv (backup *)”. The gate had already proved that argv. Apply still stops before overlay. The Next line points at the folder-backup error already printed. The 1421 != 1418 count on a tree with symlinks stays a sibling folder-backup comparison (`find -type f` versus non-directory tar members) and is not changed here. Law: `requirement-domain-tmpl-to-prj` **1.7.1**. Suite **TP-TMPL-TO-PRJ-26**.

## [1.5.0] - 2026-10-04

### Added

- Self-management from sibling **selfmanaged** (bootstrap A → this product, A stays unchanged): `self-install`, `version-check`, `self-update`, `self-uninstall`, and companion `${SCRIPT_URL}.sha256`. Channel default: `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj`.
- Main menu merge: front rows **1** plan, **2** apply, **8** self-management, **9** Exit. Under **8**: **82** version, **83** about, **84** version-check, **85** self-update, **86** self-uninstall, **87** self-install, **0** Back. **81** stays hidden. A finished command returns to the front board. A bad pick reprints that board.

### Kept

- Off-TTY empty argv is still help (Type N). `install` / `uninstall` / `where-is-me` stay the local copy at mode **0755** and are not aliases of `self-install` (non-root self-install is mode **0700**).
- `plan` / `apply`, dest specialized-docs preserve, folder-backup gate (root or NOPASSWD `backup *` only; no password sudo), Termux / Git Bash / Windows cmd privilege freeze, and template/project picker **0** back.

## [1.4.0] - 2026-10-04

### Fixed

- **INC-20261004-001**: `apply` asked for a sudo password when `folder-backup` was installed and this login had no proven backup right. The gate now tests that the `folder-backup` binary exists and otherwise skips it (local dest-docs snapshot). When the binary exists, dest backup runs only if this login is root or a sudoers fragment (or `sudo -n -l`) grants NOPASSWD `folder-backup backup *` (`sudo -n` only). Otherwise apply stops before overlay and tells the operator to use `folder-backup` to submit a request and create a sudoer file fragment for a later backup (`print-sudoers`, then `generate-sudoer-request`, then `submit-sudoer-request`). A terminal is not a grant. Law: `requirement-domain-tmpl-to-prj` **1.7.0**, `requirement-shell-sudo-command` **1.4.0**. Suite **TP-TMPL-TO-PRJ-24..25**.

## [1.3.0] - 2026-09-27

### Changed

- Cache folder is per login and per process. Linux: `/dev/shm/cache/cache-${APP_NAME}-${login}-$$`, then `/tmp/cache/...`, then `${HOME}/.cache/cache-${APP_NAME}-$$`. Git Bash: `/tmp/cache/...`, then `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` (no 2nd fallback). Mac: `/tmp/cache/...`, then `~/Library/Caches/...`, then `~/cache/cache-${APP_NAME}-$$`. A skipped tier is silent. Persistence is `${HOME}/.local/tmpl-to-prj`. `about` prints Cache folder used, preferred, 1st fallback, 2nd fallback when that host has one, and Persistence storage. Law: `requirement-shell-cli-storage` **1.2.0**.

## [1.2.1] - 2026-09-10

### Fixed

- **Apply wiped dest specialized `docs/` folders** other than requirements. Overlay now `mv`s dest `docs/incidents/`, `docs/checklists/`, `docs/whitelists/`, `docs/housekeeping/`, and dest `docs/reviews/` aside with `docs/requirements/`, then restores each folder dest **had**. Kit placeholders stay only when dest lacked that directory. Portable folders (skills, terms, templates, policies, human-intro, dest `docs/README.md`) still come from the kit. Law: `requirement-domain-tmpl-to-prj` **1.6.0**. Suite **TP-TMPL-TO-PRJ-20..23**. Incident class **INC-20260910-001**.

## [1.2.0] - 2026-09-06

### Added

- **Termux** is a supported target system (command line for this login only). Detect via `PREFIX` / `TERMUX_VERSION` / Termux usr tree. Named `pkg` table is **empty** (this program is POSIX `/bin/sh`).
- Git Bash and Windows cmd share the same privilege freeze: no in-tool `sudo`, no Linux `apt`, no Termux `pkg`.
- Product README **Examples**, **Platform Compatibility**, **Related Projects**, **Contributing**, and **License** sections.

### Changed

- On Termux / Git Bash / Windows cmd, dest backup uses the local dest-docs snapshot; `util_sudo` does not run. Global install fails without recommending `sudo`.
- Requirements: human-facing blocks, leftover `cli-template` identity in Implementation Notes retargeted to `tmpl-to-prj`, and a section **Under command line for normal user only** on related shell and domain law.

### Tests

- **TP-TX-01** stub `pkg` is not invoked off Termux.
- **TP-TX-02** Termux mock + empty table does not call `pkg` on `install`.
- **TP-TX-06** Termux apply does not invoke stub `sudo` / folder-backup.
- **TP-TX-07** Git Bash `MSYSTEM` apply does not invoke stub `sudo`.
- **TP-TX-08** Termux `install --global` fails with Next: user-bin install — do not use sudo.

## [1.1.0] - 2026-09-03

### Fixed

- TTY template list no longer treats specialized products as kits just because `docs/README.md` still says Template name / genesis-template after a hop. A template is an unspecialized kit: `docs/`, **0** `requirement-*.md`, no incident bodies, no product tests.
- TTY template and project pickers print **one** back row: **0. Back to main menu**. Choosing **0** (or **9** / **99** when that number is not an item) returns to the plan/apply menu. **MUST NOT** also print **9. Back to main menu**.

### Tests

- **TP-TMPL-TO-PRJ-17** specialized README / incidents / tests are not listed; apply of a specialized source fails closed.
- **TP-TMPL-TO-PRJ-18** `list-templates` stays print-only (no back row).
- **TP-TMPL-TO-PRJ-19** TTY `2` then `0` then `9` returns to the main menu and exits 0; picker does not print **9. Back to main menu**.

## [1.0.1] - 2026-09-02

### Changed

- Main-menu header prints **`${APP_NAME}`**(*`${VERSION}`*) (bold name, italic version on TTY; plain off-TTY). Helper: `util_app_ident`.

### Fixed

- **INC-20260902-001**: folder-backup gate looked at harness dest `/etc/<user>/folder-backup` and called a miss “verb-only too narrow”. Sibling dest is `/etc/sudoers.d/folder-backup-<user>` (`backup *`). Gate now probes that dest (legacy unsuffixed; optional harness path), corroborates with `sudo -n -l` when overrides are unset, splits **narrow** (observed verb-only) from **unproven**, and on TTY operates `sudo folder-backup backup <dest>` when verb-only is not observed.

### Tests

- **TP-TMPL-TO-PRJ-14** star grant at `T2P_SUDOERS_FILE` → pass.
- **TP-TMPL-TO-PRJ-15** star grant at `T2P_SUDOERS_D_DIR/folder-backup-<user>` → pass.
- **TP-TMPL-TO-PRJ-16** missing dest is unproven, not verb-only.
- **TP-CLI-17** TTY main-menu header is `${APP_NAME}(${VERSION})` with SGR 1 / SGR 3.

### Docs

- In-tool sudo law specializes **`LM-SHELL-SUDO-COMMAND`** (C0–C6 + studied allow table). Filled **`CL-LEAST-PRIVILEGE`** and **`CL-SHELL-TTY-PRIVILEGE-TRAPS`**. Emit sudoers checklists remain N/A.

## [1.0.0] - 2026-09-02

### Added

- **tmpl-to-prj** specialized from **cli-template** (A→B).
- Domain verbs **`plan`** and **`apply`** with parameters **template-name** and **project-name** (`--template` / `--project`).
- RAM-drive-first resolve (`T2P_RAM_ROOT` then `PROJECTS_ROOT`); fail closed if missing.
- Dest `docs/requirements/` moved aside before overlay, then restored.
- folder-backup readiness gate (global binary + matching `backup *` sudoers); dest backup when PASS; local dest-docs snapshot when the binary is missing; fail closed when grant is too narrow.
- Interactive numbered main menu (`plan` / `apply` / Exit 9); after those, TTY numbered **template** list then **project** list (current folder and `~/prjs`).
- Test-purpose `list-templates` / `list-projects` print the same inventories without writes.
- Law: domain SSOT, coding-style, sudo wrap, actor/role/subject, default-interaction.
- Suite **TP-TMPL-TO-PRJ-01..13**.

### Changed

- Identity SSOT: `APP_NAME=tmpl-to-prj`, `REPO_NAME=tmpl-to-prj`, ship unit `src/tmpl-to-prj`.
- Empty argv: TTY → menu; off-TTY → help.
- Bootstrap chain: cli-template → tmpl-to-prj.

### Removed

- Leftover bootstrap ship unit `src/cli-template` after A→B copy.

### Intentionally absent

- Online install / Type O
- This product’s own `backup` / `restore` / `print-sudoers` verbs
