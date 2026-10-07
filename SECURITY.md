# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.6.2 (current) | Yes |
| 1.6.1 | Yes |
| 1.6.0 | Yes |
| 1.5.2 | Yes |
| 1.5.1 | Yes |
| 1.5.0 | Yes |
| 1.4.0 | Yes |
| 1.3.0 | Yes |
| 1.2.1 | Yes |
| 1.2.0 | Yes |
| 1.1.0 | Yes |
| 1.0.1 | Yes |
| 1.0.0 | Yes |

## Reporting a Vulnerability

Please **do not** open a public issue for security-sensitive reports when a private channel is available.

**Maintainer contact (email):** `wongcf22@gmail.com`

- Source of contact: product **author-email** SSOT in [`LICENSE.md`](./LICENSE.md) (Copyright line).  
- Prefer email (or private GitHub security advisories when enabled) for vulnerability details, reproduction steps, and impact.  
- Do not include exploit weaponization guides in public channels.

## Security Design Principles (CIAO)

This project follows **[CIAO](https://github.com/cloudgen/ciao)** / **[CIAO-Lite](https://github.com/cloudgen/ciao-lite)** defensive design. Security-relevant intent:

| Letter | Principle | Security application |
|--------|-----------|----------------------|
| **C** | **Caution** | Unknown commands fail closed. Install fails loud if the target is not writable. A companion digest that does not match stops the install. |
| **I** | **Intentional** | Local lifecycle plus a dest-docs hop. No sudoers-file emit of **this** product. The automatic companion check is the default channel path. An optional pin is for CI only and is not a `help` or `about` setting. |
| **A** | **Anti-fragile** | Isolated scratch (`APP_NAME` + `USERNAME`). Atomic install place. A missing companion warns and continues. That is not a match, and it is not a silent skip. |
| **O** | **Over-protect** | Protection Zones on `out_*` and install. No password sudo. |

Full principles: [CIAO](https://github.com/cloudgen/ciao) · [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

This section is **design posture**, not a third-party certification claim.

## Install integrity and trust

Channel `self-install` and `self-update` use the automatic companion check. Operator steps are in [`README.md`](./README.md).

| Fact | Honest statement |
|------|------------------|
| **Default path** | The program fetches `${SCRIPT_URL}.sha256` when no operator pin is set. A normal install does not need a pin. |
| **Algorithm** | SHA-256 (`sha256sum`, then `shasum -a 256`, then `openssl dgst -sha256`). |
| **Transparency** | Human mode prints the companion **link**, the expected **value**, the actual value, and the **result** (match, mismatch, or missing). |
| **Mismatch** | The install stops. Mismatched bytes are not placed. |
| **Missing sidecar** | Warn and continue. This is not “always verified.” |
| **Optional pin** | A process pin is secondary (CI or a digest you already trust). The same channel is not a stronger check. `help` and `about` do not name it. |
| **Trust bound** | Same-channel SHA-256 shows the download matches the published companion (wrong blob, bit-flip, or a stale pair). It is not a separate signature or a second trust root. |

## Scope notes

- This product does **not** emit or install `/etc/sudoers.d` fragments.  
- This product does **not** write under `/var/backup` itself; it may invoke sibling `folder-backup backup <dest>` when this login is root or a NOPASSWD `backup *` grant exists. It does not ask for a sudo password. A missing `folder-backup` binary skips that step.  
- Uninstall removes only the managed binary.  
- Local `~/.local/bin` install is user-rewritable; prefer global install on multi-user POSIX hosts when a shared CLI is desired. On Termux / Git Bash / Windows cmd this product **MUST NOT** invoke `sudo`.  
- Related docs: [`README.md`](./README.md), [`LICENSE.md`](./LICENSE.md).
