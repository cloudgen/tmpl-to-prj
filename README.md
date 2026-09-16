# tmpl-to-prj - Copy harness docs from a genesis template into a named project

![Version](https://img.shields.io/badge/Version-1.3.0-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/cloudgen/tmpl-to-prj?style=flat-square)](https://github.com/cloudgen/tmpl-to-prj)

**tmpl-to-prj** is a small POSIX `/bin/sh` program you install **for yourself**. You name a **template** (genesis-template or a subclass such as sh-cli-template) and a **project**. It copies the template’s `docs/` onto the project and puts the project’s own specialized docs folders back (requirements, incidents, filled checklists, whitelists, housekeeping, dest `docs/reviews/`) so product law and dest history are not replaced by a blank kit.

| You | The other role | Not this |
|-----|----------------|----------|
| A login who already has two project folders | Sibling `folder-backup`, when globally installed, archives the dest tree | A host-OS manager or a sudoers emitter |

**Includes / excludes:** Includes RAM-drive-first lookup of both names, a dest backup when `folder-backup` is ready, and `mv` of dest specialized docs folders. Excludes overlay of dest `src/`, tests, root README, or `AGENTS.md`. On **Termux** (and Git Bash / Windows cmd) it stays a command line for **you only**: no `sudo`, no Linux `apt`.

**Practice:**

| Step | What it means | What you type |
|------|---------------|---------------|
| Install for yourself | Place the program on your PATH | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj \| sh` |
| Preview | Show which RAM or disk roots would be used. No writes. | `tmpl-to-prj plan sh-cli-template grok-cli` |
| Apply | Archive dest (if ready), replace dest docs, restore dest specialized docs folders. | `tmpl-to-prj apply --force sh-cli-template grok-cli` |

## Features

- **Self-management**: `install`, `version-check`, `self-update`, `self-uninstall`, `version`, `about`, `help`
- **Harness-docs hop**: `plan` and `apply` with **template-name** and **project-name**
- **RAM-drive first**: `/dev/shm/<name>` wins over `${HOME}/prjs/<name>` when both exist (on Termux, `/dev/shm` is often absent — hard-disk `prjs` is used)
- **Specialized dest docs preserved**: dest `docs/requirements/`, `docs/incidents/`, filled `docs/checklists/`, `docs/whitelists/`, `docs/housekeeping/`, and dest `docs/reviews/` are moved aside, then restored
- **folder-backup compose**: dest archive when the global binary is ready on a POSIX host with a matching grant; skipped on Termux / Git Bash / Windows cmd (local dest-docs snapshot instead)
- **Automatic checksum (SHA-256)**: online install / self-update fetches `${SCRIPT_URL}.sha256` itself; human mode shows companion **link**, expected **value**, and **result**; mismatch aborts; missing sidecar warns and continues
- **Termux target**: detect Termux-like userspace; no extra `pkg` list (this program is `/bin/sh` only)
- **Numbered menu** on a real terminal (empty argv or `menu`)
- **Empty argv in a pipe** is install-ensure (`curl | sh`), not help
- **Fail-closed**: unknown commands exit non-zero
- **CIAO / CIAO-Lite** defensive design (Protection Zones, `out_*` output SSOT)

## Quick Installation

### Online (recommended)

Copy-paste (channel URL is Config default in `./tmpl-to-prj`):

**Per-user (non-root):**

```sh
curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj | sh
```

**System-wide (root / elevated — not Termux):**

```sh
sudo curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj | sudo sh
```

Then verify:

```sh
tmpl-to-prj about
```

### Integrity (automatic checksum)

**Primary path:** the program downloads the companion digest **itself**. You do **not** set `CHECKSUM` for normal online install or self-update.

| Mode | When | Algorithm | What happens |
|------|------|-----------|--------------|
| **Automatic (default)** | `CHECKSUM` **unset** (default one-liner) | **SHA-256** via `sha256sum` | After download, fetch companion **`${SCRIPT_URL}.sha256`**. Human mode shows the companion **link**, expected **value**, and **result**. **Match** → install continues. **Mismatch** → install **aborts**. **Sidecar missing** → **warning**, install continues (best-effort). |
| **Strict pin (optional)** | `CHECKSUM` set to an out-of-band hex digest | **SHA-256** | Download must match the pin exactly; **mismatch aborts**. Secondary—CI / freeze installs only. |

Default channel companion path (`${SCRIPT_URL}.sha256`):

```text
https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj.sha256
```

In this repository the companion file is **`tmpl-to-prj.sha256`** (bare 64-char hex of `./tmpl-to-prj`). Same-channel SHA-256 proves **consistency** of the two files on that channel; it is not a substitute for signed releases.

### From a local checkout

```sh
chmod +x ./tmpl-to-prj
./tmpl-to-prj install
tmpl-to-prj version
```

On Termux, Git Bash, or Windows cmd, use the **local / per-user** path. Do not run `sudo` for this program there.

After install, on a terminal:

```text
$ tmpl-to-prj
[INFO] **tmpl-to-prj**(*1.3.0*) — numbered list of live commands
1. plan: Show template and project roots (no writes)
2. apply: Copy harness docs from the template into the project
9. Exit
Choice:
```

Choose a number, or type the command name. `9` exits. A number or name that is **not** on this list prints an error and lets you choose again — it does **not** exit.

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

tmpl-to-prj version-check
tmpl-to-prj self-update
tmpl-to-prj self-uninstall --force
```

**Environment (selected):**

| Variable | Role |
|----------|------|
| `T2P_RAM_ROOT` | RAM-drive parent (default `/dev/shm`) |
| `PROJECTS_ROOT` | Hard-disk projects parent (default `${HOME}/prjs`) |
| `REPO_USER` | Git host owner (default `cloudgen`) |
| `REPO_NAME` | Git repository name (default `tmpl-to-prj`) |
| `SCRIPT_URL` | Online install channel (default `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj`) |
| `USER_BIN` | Per-user install destination (default `~/.local/bin`) |
| `GLOBAL_BIN` | Global install destination (default `/usr/local/bin`) |

**Source repository:** `cloudgen/tmpl-to-prj`. Config identity: `REPO_USER=cloudgen`, `REPO_NAME=tmpl-to-prj`.

## Examples

Preview without writing:

```sh
tmpl-to-prj plan sh-cli-template grok-cli
```

Apply and keep the dest project’s specialized docs folders:

```sh
tmpl-to-prj apply --force sh-cli-template grok-cli
```

On Termux, the same domain commands work after a local install. Dest backup uses a snapshot under the project (not `sudo folder-backup`).

## Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| POSIX Linux (`/bin/sh`) | **Supported** | Primary runtime. RAM-drive `/dev/shm` when present. Online install. |
| Termux (Android userspace) | **Supported** | Command line for this login only. No `sudo`. No extra `pkg`. User-bin install. |
| Other UNIX with `/bin/sh` + `mktemp` + `date` | **Best effort** | Same install story. |
| Git Bash / Windows cmd | **Privilege freeze** | Same “normal user only” ceiling; no Termux `pkg`; no `sudo`. POSIX hop may still need a UNIX-like tree. |
| Windows without a POSIX `sh` | **Not supported** | This is a `/bin/sh` program. |

## Related Projects

| Project | Relation |
|---------|----------|
| **selfmanaged** | Bootstrap origin (A). Do not reverse-copy this product onto it. |
| **folder-backup** | Sibling CLI composed for dest archive when globally installed on POSIX. |
| **genesis-template** / **sh-cli-template** | Typical **template-name** kits (unspecialized `docs/`). |

## Contributing

Keep CIAO / CIAO-Lite Protection Zones. Trace behavior to live `docs/requirements/`. Run `./tests/run.sh` before a change is claimed done. Do not reverse-copy this product onto sibling `selfmanaged`.

## License

MIT. See [`LICENSE.md`](./LICENSE.md).

## Last Update

2026-09-16 — Specialized from sibling **selfmanaged** (online Type 0 + automatic checksum). Domain hop unchanged. Apply still keeps dest specialized docs folders. Version **1.3.0**.
