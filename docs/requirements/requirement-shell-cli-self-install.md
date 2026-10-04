**file**: docs/requirements/requirement-shell-cli-self-install.md  
**Status**: Active (Version 1.0.0)  
**Area**: shell  
**Key**: `requirement-shell-cli-self-install`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the product law for **how tmpl-to-prj places itself on the channel path**: the `self-install` verb.

Specialized from selfmanaged on 2026-10-04. **Specialization kept by user order (“maintain all the features of tmpl-to-prj”):**

1. Empty argv stays **Type N** (TTY menu, off-TTY help). It **MUST NOT** call `inst_self_install`.  
2. `install` stays the local **0755** copy (`inst_local_install`). It is **not** an alias of `self-install`.

### 1.1 Human-facing

**In one sentence:** `tmpl-to-prj self-install` copies this file when you run the script, and downloads the channel when `$0` is the shell.

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Place from a checkout | Copy the running file. No network | `sh src/tmpl-to-prj self-install` |
| Place from a pipe | `$0` is `sh`. Download `SCRIPT_URL` | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj \| sh` |
| Local multi-user copy | Separate verb, mode **0755** | `sh src/tmpl-to-prj install` |

---

## 2. Core Rules (Mandatory)

### 2.1 Route

1. `tmpl-to-prj self-install` **MUST** call `inst_self_install`.  
2. `tmpl-to-prj install` **MUST** call `inst_local_install` (mode **0755**, no network).  
3. Empty argv **MUST NOT** call `inst_self_install` or `inst_maybe_install`.  
4. Menu **87** or the token `self-install` **MUST** call `inst_self_install`.  
5. Menu **81** / the token `install` on the menu is a bad pick. The CLI verb `install` still works outside the menu.

### 2.2 `$0` source

| `$0` | Place |
|------|-------|
| Interpreter basename `sh` `bash` `dash` `ash` `zsh` `ksh` `mksh` `yash` `posh` `csh` `tcsh` `fish` `busybox` | Download `SCRIPT_URL` and the companion digest |
| Readable regular file | **Copy** that file. **MUST NOT** download |
| Basename only, `command -v` finds a readable file | Copy that file |

A pipe **MUST** still reach `app_main`. `$0` is not a product-name gate.

### 2.3 Copy

1. Resolve an absolute readable path.  
2. Stage with `util_mktemp` (not a `$$` name).  
3. `cp`, then `chmod` the dest mode, then `mv`, then `chmod` again.  
4. **MUST NOT** `chmod +x` alone (`0600` plus `+x` becomes **0711**).  
5. **MUST NOT** fetch `SCRIPT_URL` on the copy path.

### 2.4 Dest mode (self-install and channel download)

| Invoker | Path | Mode |
|---------|------|------|
| root (and not a normal-user-only CLI) | `${GLOBAL_BIN}/tmpl-to-prj` | **0755** |
| any other login | `${USER_BIN}/tmpl-to-prj` | **0700** |
| Termux, Git Bash, Windows cmd | `${USER_BIN}/tmpl-to-prj` only | **0700** |

Local `install` is a different writer and uses **0755** on both paths (`requirement-shell-local-self-management.md`).

### 2.5 Already installed

Force off → success, no copy, no download. `--force` replaces using the `$0` rule.

### 2.6 Normal-user-only

No in-tool `sudo`. Do not print `sudo curl | sh`. Git Bash and Windows cmd do not call Termux `pkg` on this path.

### 2.7 Implementation Notes

| Item | Value |
|------|--------|
| Handler | `inst_self_install` |
| Detect | `inst_argv0_is_shell_interpreter`, `inst_resolve_self_script` |
| Copy | `inst_self_install_copy_from_script` |
| Dest mode | `inst_cli_dest_mode` |
| Download | `inst_perform_install_download_*` then `inst_perform_install_atomic_install` |
| Channel | `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj` |

---

## 3. Protection Rule (Sacred)

**MUST NOT**:

1. Route empty argv to `inst_self_install`.  
2. Make `install` call `inst_self_install`.  
3. Use `chmod +x` as the only mode change on a `mktemp` file.  
4. Leave a self-install global dest at **0700** or **0711** on a normal root install.  
5. Leave a self-install user dest at **0755** (that mode belongs to `install`).  
6. Recommend password sudo for this place path.

---

## 4. Definition of done

| ID | Where | Status |
|----|-------|--------|
| **TP-CLI-07** | `tests/test_cli.sh` | have (off-TTY empty argv is help) |
| **TP-CLI-29** | `tests/test_cli.sh` | have (self-install copy, mode 0700; `install --force` heals 0755) |
| **TP-LC-09** | `tests/test_local_lifecycle.sh` | have (`install` mode 0755) |

**Last Updated**: 2026-10-04  
**Owner**: tmpl-to-prj project maintainers  
**Alignment**: Specialized from selfmanaged `requirement-shell-cli-self-install`, with the Type N and local-0755 exceptions above.
