# tmpl-to-prj - Copy harness docs from a genesis template into a named project

![Version](https://img.shields.io/badge/Version-1.2.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)

**tmpl-to-prj** is a small POSIX `/bin/sh` program. You name a **template** (genesis-template or a subclass such as sh-cli-template) and a **project**. It copies the template’s `docs/` onto the project and puts the project’s own specialized docs folders back (requirements, incidents, filled checklists, whitelists, housekeeping, dest `docs/reviews/`) so product law and dest history are not replaced by a blank kit.

| You | The other role | Not this |
|-----|----------------|----------|
| A login who already has two project folders | Sibling `folder-backup`, when globally installed, archives the dest tree | A host-OS manager, an online `curl\|sh` installer, or a sudoers emitter |

**Includes / excludes:** Includes RAM-drive-first lookup of both names, a dest backup when `folder-backup` is ready, and `mv` of dest specialized docs folders. Excludes overlay of dest `src/`, tests, root README, or `AGENTS.md`. On **Termux** (and Git Bash / Windows cmd) it stays a command line for **you only**: no `sudo`, no Linux `apt`.

**Practice:**

| Step | What it means | What you type |
|------|---------------|---------------|
| Preview | Show which RAM or disk roots would be used. No writes. | `tmpl-to-prj plan sh-cli-template grok-cli` |
| Apply | Archive dest (if ready), replace dest docs, restore dest specialized docs folders. | `tmpl-to-prj apply --force sh-cli-template grok-cli` |

## Features

- **Self-management**: `install`, `uninstall`, `where-is-me`, `version`, `about`, `help`
- **Harness-docs hop**: `plan` and `apply` with **template-name** and **project-name**
- **RAM-drive first**: `/dev/shm/<name>` wins over `${HOME}/prjs/<name>` when both exist (on Termux, `/dev/shm` is often absent — hard-disk `prjs` is used)
- **Specialized dest docs preserved**: dest `docs/requirements/`, `docs/incidents/`, filled `docs/checklists/`, `docs/whitelists/`, `docs/housekeeping/`, and dest `docs/reviews/` are moved aside, then restored
- **folder-backup compose**: dest archive when the global binary is ready on a POSIX host with a matching grant; skipped on Termux / Git Bash / Windows cmd (local dest-docs snapshot instead)
- **Termux target**: detect Termux-like userspace; no extra `pkg` list (this program is `/bin/sh` only)
- **Numbered menu** on a real terminal (empty argv or `menu`)
- **Empty argv in a script** prints help (does not install)
- **Fail-closed**: unknown commands exit non-zero
- **CIAO / CIAO-Lite** defensive design (Protection Zones, `out_*` output SSOT)

## Quick Installation

**Local (this login — POSIX Linux and Termux):**

```sh
sh src/tmpl-to-prj install
# or force refresh after updates
sh src/tmpl-to-prj install --force

# Ensure ~/.local/bin is on PATH (on Termux you may set USER_BIN=$PREFIX/bin), then:
tmpl-to-prj version
```

**Global (multi-user POSIX hosts only — not Termux):**

```sh
sudo sh src/tmpl-to-prj install
```

On Termux, Git Bash, or Windows cmd, use the **local** path. Do not run `sudo` for this program there.

At a real terminal, empty argv shows the numbered list:

```text
[INFO] **tmpl-to-prj**(*1.2.1*) — numbered list of live commands
1. plan: Show template and project roots (no writes)
2. apply: Copy harness docs from the template into the project
9. Exit
Choice:
```

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
tmpl-to-prj where-is-me
tmpl-to-prj uninstall --force
```

**Environment (selected):**

| Variable | Role |
|----------|------|
| `T2P_RAM_ROOT` | RAM-drive parent (default `/dev/shm`) |
| `PROJECTS_ROOT` | Hard-disk projects parent (default `${HOME}/prjs`) |
| `REPO_USER` | Git host owner (default `cloudgen`) |
| `REPO_NAME` | Git repository name (default `tmpl-to-prj`) |
| `SCRIPT_URL` | Online install channel (default **empty** — local only) |
| `USER_BIN` | Per-user install destination (default `~/.local/bin`) |
| `GLOBAL_BIN` | Global install destination (default `/usr/local/bin`) |

**Source repository:** local-only. Config identity: `REPO_USER=cloudgen`, `REPO_NAME=tmpl-to-prj`.

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
| **cli-template** | Bootstrap origin (A). Do not reverse-copy this product onto it. |
| **folder-backup** | Sibling CLI composed for dest archive when globally installed on POSIX. |
| **genesis-template** / **sh-cli-template** | Typical **template-name** kits (unspecialized `docs/`). |

## Contributing

Keep CIAO / CIAO-Lite Protection Zones. Trace behavior to live `docs/requirements/`. Run `./tests/run.sh` before a change is claimed done. Do not reintroduce an online `curl|sh` channel unless product law is explicitly changed.

## License

MIT. See [`LICENSE.md`](./LICENSE.md).

## Last Update

2026-09-13 — Apply keeps dest specialized docs folders (requirements, incidents, filled checklists, whitelists, housekeeping, dest `docs/reviews/`). **INC-20260910-001**. Version **1.2.1**.
