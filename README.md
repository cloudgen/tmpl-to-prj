# tmpl-to-prj - Copy harness docs from a genesis template into a named project

![Version](https://img.shields.io/badge/Version-1.5.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)

**tmpl-to-prj** is a small POSIX `/bin/sh` program. You name a **template** (genesis-template or a subclass such as sh-cli-template) and a **project**. It copies the template’s `docs/` onto the project and puts the project’s own specialized docs folders back (requirements, incidents, filled checklists, whitelists, housekeeping, dest `docs/reviews/`) so product law and dest history are not replaced by a blank kit.

| You | The other role | Not this |
|-----|----------------|----------|
| A login who already has two project folders | Sibling `folder-backup`, when globally installed, archives the dest tree | A host package manager, or a program that writes sudoers fragments |

**Includes / excludes:** Includes RAM-drive-first lookup of both names, a dest backup when `folder-backup` is ready, and `mv` of dest specialized docs folders. Excludes overlay of dest `src/`, tests, root README, or `AGENTS.md`. On **Termux** (and Git Bash / Windows cmd) it stays a command line for **you only**: no `sudo`, no Linux `apt`.

**Practice:**

| Step | What it means | What you type |
|------|---------------|---------------|
| Preview | Show which RAM or disk roots would be used. No writes. | `tmpl-to-prj plan sh-cli-template grok-cli` |
| Apply | Archive dest (if ready), replace dest docs, restore dest specialized docs folders. | `tmpl-to-prj apply --force sh-cli-template grok-cli` |

## Features

- **Local lifecycle**: `install`, `uninstall`, `where-is-me`, `version`, `about`, `help` (copy, mode 0755)
- **Channel self-management**: `self-install`, `version-check`, `self-update`, `self-uninstall`
- **SHA-256 companion**: a channel download checks `${SCRIPT_URL}.sha256` by itself (match continues, mismatch stops, a missing file warns and continues)
- **Harness-docs hop**: `plan` and `apply` with **template-name** and **project-name**
- **RAM-drive first**: `/dev/shm/<name>` wins over `${HOME}/prjs/<name>` when both exist (on Termux, `/dev/shm` is often absent — hard-disk `prjs` is used)
- **Specialized dest docs preserved**: dest `docs/requirements/`, `docs/incidents/`, filled `docs/checklists/`, `docs/whitelists/`, `docs/housekeeping/`, and dest `docs/reviews/` are moved aside, then restored
- **folder-backup compose**: dest archive when the global binary is ready on a POSIX host with a matching grant; skipped on Termux / Git Bash / Windows cmd (local dest-docs snapshot instead)
- **Termux target**: detect Termux-like userspace; no extra `pkg` list (this program is `/bin/sh` only)
- **Numbered menu** on a real terminal: 1 plan, 2 apply, 8 self-management (82–87), 9 Exit
- **Empty argv in a script** prints help (does not install)
- **Fail-closed**: unknown commands exit non-zero
- **CIAO / CIAO-Lite** defensive design (Protection Zones, `out_*` output SSOT)

## Quick Installation

**This login (the program downloads the script):**

```sh
curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj | sh
```

**Shared bin on a multi-user POSIX host** (not Termux, Git Bash, or Windows cmd):

```sh
sudo curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj | sudo sh
```

`SCRIPT_URL` already defaults to that address. A non-root channel place uses mode **0700**. Root uses mode **0755** under `/usr/local/bin`.

**This checkout (no download):**

```sh
sh src/tmpl-to-prj install
sh src/tmpl-to-prj install --force
sudo sh src/tmpl-to-prj install
```

`install` copies this file at mode **0755** and does not use the network. `sh src/tmpl-to-prj self-install` also copies this file when `$0` is the script (mode **0700** when you are not root) and does not download. On Termux, set `USER_BIN=$PREFIX/bin` if that directory should be on `PATH`, then run `tmpl-to-prj version`. Do not run `sudo` for this program on Termux, Git Bash, or Windows cmd.

### Integrity

Channel `self-install` and `self-update` use **SHA-256**. The program downloads the companion itself. A normal install does not need a pin.

| Outcome | What happens |
|---------|----------------|
| Companion present and the digest matches | Install continues. Human mode prints the companion **link**, the expected **value**, the actual value, and **PASS**. |
| Companion present and the digest does not match | Install stops. The file is not placed. |
| Companion missing | A warning is printed and the install continues. That is not a match. |

The companion URL is `${SCRIPT_URL}.sha256`. In this repository the file is `src/tmpl-to-prj.sha256` (the first field is the hex digest). Tools, in order: `sha256sum`, `shasum -a 256`, `openssl dgst -sha256`.

**Advanced (CI only).** If `CHECKSUM` is set to a hex digest from a source you trust outside this channel, the download must match that pin or the install stops. Reading the pin from the same URL is the same trust as the automatic check. `help` and `about` do not mention that name.

### Numbered list

After install, on a terminal, run `tmpl-to-prj` with no arguments. Live capture:

```text
[INFO] **tmpl-to-prj**(*1.5.1*) — numbered list of live commands
1. **plan**: *Show template and project roots (no writes)*
2. **apply**: *Copy harness docs from the template into the project*
8. **self-management**: *this CLI install, version, update, uninstall*
9. Exit
Choice:
```

Choose **8**:

```text
[INFO] **tmpl-to-prj**(*1.5.1*) — self-management
82. **version**: *show current version*
83. **about**: *show detailed diagnostics*
84. **version-check**: *compare local vs remote version*
85. **self-update**: *update tmpl-to-prj to a newer remote version*
86. **self-uninstall**: *remove tmpl-to-prj*
87. **self-install**: *place this CLI only (copy when $0 is a script; download when piped)*
0. Back
Choice:
```

`9` leaves. `0` on the self-management list returns to the front list. After a command finishes, the front list is shown again. A number or name that is not on that list prints an error and shows the list again.

## Usage

```sh
tmpl-to-prj help
tmpl-to-prj about
tmpl-to-prj --json about

tmpl-to-prj plan sh-cli-template grok-cli
tmpl-to-prj apply --template sh-cli-template --project grok-cli
tmpl-to-prj apply --force --dry-run genesis-template my-cli
tmpl-to-prj list-templates
tmpl-to-prj list-projects

tmpl-to-prj install
tmpl-to-prj self-install
tmpl-to-prj version-check
tmpl-to-prj self-update
tmpl-to-prj where-is-me
tmpl-to-prj uninstall --force
```

`--json` prints machine-readable output and implies `--quiet`. `--quiet` hides info and success lines. Errors still print.

**Environment (selected):**

| Variable | Role |
|----------|------|
| `T2P_RAM_ROOT` | RAM-drive parent (default `/dev/shm`) |
| `PROJECTS_ROOT` | Hard-disk projects parent (default `${HOME}/prjs`) |
| `REPO_USER` | Git host owner (default `cloudgen`) |
| `REPO_NAME` | Git repository name (default `tmpl-to-prj`) |
| `SCRIPT_URL` | Channel (default `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj`) |
| `USER_BIN` | Per-user install destination (default `~/.local/bin`) |
| `GLOBAL_BIN` | Global install destination (default `/usr/local/bin`) |

**Source repository:** `https://github.com/cloudgen/tmpl-to-prj`. Config identity: `REPO_USER=cloudgen`, `REPO_NAME=tmpl-to-prj`.

## Examples

Preview without writing:

```sh
tmpl-to-prj plan sh-cli-template grok-cli
```

Apply and keep the dest project’s specialized docs folders:

```sh
tmpl-to-prj apply --force sh-cli-template grok-cli
```

On Termux, the same commands work after a local install. Dest backup uses a snapshot under the project (not `sudo folder-backup`).

## Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| POSIX Linux (`/bin/sh`) | **Supported** | Primary runtime. RAM-drive `/dev/shm` when present. |
| Termux (Android userspace) | **Supported** | Command line for this login only. No `sudo`. No extra `pkg`. User-bin install. |
| Other UNIX with `/bin/sh` + `mktemp` + `date` | **Best effort** | Same local install story. |
| Git Bash / Windows cmd | **Privilege freeze** | Same “normal user only” ceiling; no Termux `pkg`; no `sudo`. POSIX hop may still need a UNIX-like tree. |
| Windows without a POSIX `sh` | **Not supported** | This is a `/bin/sh` program. |

## Related Projects

| Project | Relation |
|---------|----------|
| **selfmanaged** | Bootstrap origin (A). Do not reverse-copy this product onto it. |
| **cli-template** | Historical hop. Do not reverse-copy this product onto it. |
| **folder-backup** | Sibling CLI composed for dest archive when globally installed on POSIX. |
| **genesis-template** / **sh-cli-template** | Typical **template-name** kits (unspecialized `docs/`). |

## Contributing

Keep CIAO / CIAO-Lite Protection Zones. Trace behavior to live `docs/requirements/`. Run `./tests/run.sh` before a change is claimed done. Keep `SCRIPT_URL` on this product. Do not add `backup`, `restore`, or `print-sudoers` as verbs of this program.

## License

MIT. See [`LICENSE.md`](./LICENSE.md).

## Last Update

2026-10-04 — A folder-backup failure after a passed gate no longer says to check sudoers argv. Apply still stops before overlay and points at the folder-backup error. Version **1.5.1**.

2026-10-04 — Specialized from selfmanaged: channel self-management and merged menu (1 plan, 2 apply, 8 self-management, 9 Exit). Channel downloads check a SHA-256 companion (match continues, mismatch stops, a missing file warns and continues). Local `install` (0755), off-TTY help, plan/apply, and the no-password folder-backup gate stay. Version **1.5.0**.

2026-10-04 — Dest backup no longer asks for a sudo password. `folder-backup` runs only when this login is root or holds NOPASSWD `backup *`; otherwise apply says to submit a request and create a sudoer file fragment. Missing `folder-backup` still skips to a local dest-docs snapshot. Version **1.4.0**.
