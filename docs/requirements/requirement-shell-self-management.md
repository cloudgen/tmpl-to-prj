**file**: docs/requirements/requirement-shell-self-management.md  
**Status**: Active (Version 1.1.0)  
**Area**: shell  
**Key**: `requirement-shell-self-management`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the project Single Source of Truth for **channel self-management** of tmpl-to-prj: `version-check`, `self-update`, `self-uninstall`, and the channel half of `about`.

It was specialized from sibling **selfmanaged** (bootstrap A → this product B) on 2026-10-04. Local copy verbs stay on `requirement-shell-local-self-management.md`. They are **not** aliases of these verbs.

**Scope:** Compare, replace, and remove the managed binary using the configured channel.  
**Out of scope:** Empty-argv routing (`requirement-shell-cli-zero-arguments`: TTY menu, non-interactive 0-argv `inst_self_install`). Local `install` / `uninstall` / `where-is-me` at mode **0755**. Domain `plan` / `apply`. Checksum math (`requirement-shell-automatic-checksum.md`). This product’s own `backup` / `restore` / `print-sudoers` verbs.

### 1.1 Human-facing

**In one sentence:** After the program is on disk, you can compare it with the channel, replace it when the channel is newer, or remove it — and removal does not happen unless you confirm or pass `--force`.

| You do… | What it means | What you type |
|---------|---------------|---------------|
| See if a newer file exists | Compare local version to the channel. Do not mutate the install. | `tmpl-to-prj version-check` |
| Update | If the channel is newer, replace the installed file. If already latest, say so. | `tmpl-to-prj self-update` |
| Remove | JSON without `--force` fails with “confirm required.” | `tmpl-to-prj --json self-uninstall` |

---

## 2. Core Rules (Mandatory)

### 2.1 Command surface

| Command | Purpose | Handler |
|---------|---------|---------|
| `version-check` | Compare local version with the channel | `ver_check` |
| `self-update` | Replace the installed CLI from the trusted channel | `inst_self_update` |
| `self-uninstall` | Remove the managed binary and clean PATH only when the user bin is empty | `inst_self_uninstall` |
| `about` | Diagnostics, including the install channel when `SCRIPT_URL` is set | `app_about` |

`version` stays local and **MUST NOT** fetch the network. `install` **MUST NOT** call `inst_self_update` or `inst_self_install`.

### 2.2 Self-update

| Requirement | Meaning |
|-------------|---------|
| Trusted source | Fetch only from Config `SCRIPT_URL` (env may override) |
| Semver | Upgrade when remote is newer (`ver_gt`). **MUST NOT** downgrade unless `--force` |
| Integrity | Companion digest or pinned `CHECKSUM` before replace when the download path runs. Missing companion warns and continues (automatic-checksum law). Mismatch aborts |
| Atomic install | Temp file, then `mv` onto the install path. **MUST NOT** curl onto the live path |
| Reuse | `self-update` **MUST** call `inst_perform_install` for the download replace. No second download path |
| Fail loud | Unreachable or empty channel **MUST NOT** be reported as “already latest” |
| Output | `out_*` only |

### 2.3 Version check

Human mode shows local and remote. JSON fields: `local_version`, `remote_version`, `is_latest`. Same `ver_gt` family as update. Missing channel fails with a fetch error.

### 2.4 Self-uninstall

1. Resolve the managed path with `util_get_install_bin_path`. Remove only that file.  
2. Already absent → success no-op.  
3. Interactive confirm unless `--force`. Non-interactive, `--json`, or `--quiet` without `--force` → fail closed (`confirm_required`). **MUST NOT** say the user cancelled.  
4. PATH cleanup only when this login is not root **and** `${USER_BIN}` is missing or empty.  
5. **MUST NOT** delete home trees or unrelated binaries. **MUST NOT** wrap `sudo` to finish removal.

### 2.5 Privilege

Type 0 (this login). Root may write `${GLOBAL_BIN}`. Non-root writes `${USER_BIN}`. On Termux, Git Bash, or Windows cmd, self-management stays on the user path and **MUST NOT** recommend `sudo curl | sh`.

### 2.6 Dual-mode matrix (with local lifecycle)

| Concern | Local (`install` / `uninstall` / `where-is-me`) | Channel (`self-install` / `self-update` / `self-uninstall` / `version-check`) |
|---------|--------------------------------------------------|---------------------------------------------------------------------------------|
| Primary | Copy the running ship unit. No network | Place or refresh from `SCRIPT_URL`, or copy when `$0` is the script |
| Empty argv | TTY menu. **Not** `inst_local_install` | Non-interactive 0-argv calls `inst_self_install` |
| Verb | `install` → `inst_local_install` | `self-install` → `inst_self_install`. **Not** an alias |
| Mode | Always **0755** | **0755** if root, else **0700**. Normal-user-only CLIs stay **0700** |
| Remove | `uninstall` | `self-uninstall` (same file, plus PATH cleanup when the user bin is empty) |
| Refresh | `install --force` from this file | `self-update` from the channel. No silent downgrade |
| Menu | Not a front row. **81** stays hidden | Front **8**. Board **82–87** |

Both writers use the same privilege-correct path (`${USER_BIN}/${APP_NAME}` or `${GLOBAL_BIN}/${APP_NAME}`). The last successful writer sets the mode.

### 2.7 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product | `tmpl-to-prj` |
| Ship unit | `src/tmpl-to-prj` |
| Version | `VERSION="1.6.2"` |
| Channel | `SCRIPT_URL` default `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj` |
| Compare | `ver_gt`, `inst_get_version`, `util_fetch_remote_version` |
| Paths | `GLOBAL_BIN` `/usr/local/bin`; `USER_BIN` `${HOME}/.local/bin` |

---

## 3. Design Principles

- **Caution:** No silent downgrade. Unreachable channel fails loud.  
- **Intentional:** Channel verbs are separate from local `install`.  
- **Anti-fragile:** Already-latest and already-removed are success no-ops.  
- **Over-protect:** Atomic replace. PATH cleanup only when the user bin is empty.

---

## 4. Protection Rule (Sacred)

**Future assistants MUST NOT**:

1. Remove digest verification on a downloaded update when a companion or pin is present.  
2. Allow a silent downgrade without `--force`.  
3. Curl onto the live binary.  
4. Delete more than the managed binary.  
5. Rename `version-check`, `self-update`, or `self-uninstall` without updating help in the same change.  
6. Make `install` an alias of `self-update` or `self-install`.  
7. Make empty argv call `inst_local_install`, or route non-interactive 0-argv to help.  
8. Recommend password `sudo` for self-update or self-uninstall.  
9. Print `CHECKSUM` in `help` or `about`.

---

## 5. Definition of done

| ID | Where | Status |
|----|-------|--------|
| **TP-CLI-10** | `tests/test_cli.sh` | have (unreachable channel fails loud) |
| **TP-CLI-30** | `tests/test_cli.sh` | have (downgrade refused; newer file replaces; JSON uninstall needs `--force`) |

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `requirement-shell-cli-self-install.md` | `self-install` place |
| `requirement-shell-local-self-management.md` | `install` / `uninstall` / `where-is-me` |
| `requirement-shell-automatic-checksum.md` | Companion digest |
| `requirement-shell-cli-interface.md` | Dispatcher catalog |
| `src/tmpl-to-prj` | Ship unit |

**Last Updated**: 2026-10-04  
**Owner**: tmpl-to-prj project maintainers  
**Alignment**: Specialized from selfmanaged `requirement-shell-self-management` (A→B). CIAO / CIAO-Lite.
