# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.2.1 (current) | Yes |
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
| **C** | **Caution** | Unknown commands fail closed; install fails loud if the target is not writable. |
| **I** | **Intentional** | Local lifecycle plus a dest-docs hop; no sudoers-file emit of **this** product. |
| **A** | **Anti-fragile** | Isolated scratch (`APP_NAME` + `USERNAME`); atomic install place with mode **0755**. |
| **O** | **Over-protect** | Protection Zones on `out_*` and install; no online channel UX. |

Full principles: [CIAO](https://github.com/cloudgen/ciao) · [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

This section is **design posture**, not a third-party certification claim.

## Scope notes

- This product does **not** emit or install `/etc/sudoers.d` fragments.  
- This product does **not** write under `/var/backup` itself; it may invoke sibling `folder-backup backup <dest>` when that grant exists.  
- Uninstall removes only the managed binary.  
- Local `~/.local/bin` install is user-rewritable; prefer global install on multi-user POSIX hosts when a shared CLI is desired. On Termux / Git Bash / Windows cmd this product **MUST NOT** invoke `sudo`.  
- Related docs: [`README.md`](./README.md), [`LICENSE.md`](./LICENSE.md).
