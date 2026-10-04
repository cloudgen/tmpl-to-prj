**file**: docs/requirements/requirement-shell-automatic-checksum.md  
**Status**: Active (Version 1.0.0)  
**Area**: shell  
**Key**: `requirement-shell-automatic-checksum`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the project Single Source of Truth for **companion-digest integrity** on tmpl-to-prj channel downloads (`self-install` when `$0` is a shell, and `self-update`).

Specialized from selfmanaged on 2026-10-04. The local `install` copy path does not download and does not use this law.

### 1.1 Human-facing

**In one sentence:** A download is checked against `SCRIPT_URL.sha256` when that file exists; a mismatch stops the install; the name `CHECKSUM` is not shown in help or about.

---

## 2. Core Rules (Mandatory)

1. Companion URL is `${SCRIPT_URL}.sha256`. The ship-unit companion on disk is `src/tmpl-to-prj.sha256` (first field is the hex digest).  
2. When env `CHECKSUM` is set, the download **MUST** match that pin or abort (`checksum_mismatch`). This pin is not a help or about field.  
3. When `CHECKSUM` is unset and the companion fetch returns HTTP 200, compare the first digest field to `util_sha256_file` of the download. Match → success and `INST_AUTO_CHECKSUM_OK=1`. Mismatch → abort. Human mode prints the companion link, expected value, actual value, and PASS or the abort.  
4. When the companion is missing, warn and continue. **MUST NOT** treat that as a digest match.  
5. **MUST NOT** print the token `CHECKSUM` from `help` or `about`.  
6. Stage with `mktemp`, chmod the dest mode, then `mv`. **MUST NOT** `chmod +x` alone.  
7. Digest tools, in order: `sha256sum`, `shasum -a 256`, `openssl dgst -sha256`.  
8. Messages go through `out_*`. Digest bytes returned for `$(util_sha256_file …)` are a data return, not a banner.

### 2.1 Implementation Notes

| Item | Value |
|------|--------|
| Download with pin | `inst_perform_install_download_with_checksum` |
| Download with companion | `inst_perform_install_download_without_checksum` |
| Atomic place | `inst_perform_install_atomic_install` |
| Digest helper | `util_sha256_file` |
| Product channel | `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj` |

---

## 3. Protection Rule (Sacred)

**MUST NOT** skip a present companion or pin, replace atomic install with in-place curl, or advertise `CHECKSUM` in help or about.

---

## 4. Definition of done

| ID | Where | Status |
|----|-------|--------|
| **TP-CLI-04** | `tests/test_cli.sh` | have (help has no `CHECKSUM`) |
| **TP-CLI-06** | `tests/test_cli.sh` | have (about JSON has no `CHECKSUM`) |
| **TP-CLI-30** | `tests/test_cli.sh` | have (channel replace uses the download path) |

**Last Updated**: 2026-10-04  
**Owner**: tmpl-to-prj project maintainers  
**Alignment**: Specialized from selfmanaged `requirement-shell-automatic-checksum`.
