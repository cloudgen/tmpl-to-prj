# Requirements

Authoritative specialized product law for **tmpl-to-prj** lives here.

**Current state (2026-09-16):** Specialized **software-development** product. Left genesis. Bootstrap **selfmanaged → tmpl-to-prj**. Online Type 0 + domain hop. Termux is a named target. Registry is populated — see `index.md`.

## Product identity (summary)

| Field | Value |
|-------|--------|
| Product / `APP_NAME` | `tmpl-to-prj` |
| Version SSOT | `1.3.0` (ship unit hard-assign) |
| Ship unit | `src/tmpl-to-prj` (published `./tmpl-to-prj`) |
| Default install | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj \| sh` |
| Install mode | **online-installable** |
| Domain surface | **Active** — `requirement-domain-tmpl-to-prj` |

## Class requirement gate

| Class | Required class file |
|-------|---------------------|
| software-development | `requirement-class-software-dev.md` (**Active**) |
| genesis-template | N/A — this workspace is no longer genesis |

## Purpose

- **Plan** designs work by reading and updating these docs.  
- **Implement** delivers code that **traces** to these requirements.  
- **Review** verifies delivery against requirements and CIAO checklists.

## Layout

| Path | Role |
|------|------|
| `docs/requirements/index.md` | Registry of all requirements — keep in sync |
| `docs/requirements/requirement-*.md` | CIAO-style project requirements |

## Status values

Typical: `draft` · `Active` · `approved` · `in-progress` · `done` · `deprecated` · `superseded`

## Rules

1. Never invent paths — verify on disk.  
2. Class files only via class process; non-class via create-specific process.  
3. Never dump harness inventories into this versioned surface.  
4. Online install requirements stay **absent** unless product mode is explicitly changed.  
5. Do **not** create a hollow `requirement-domain-*` that restates Type 0, and do **not** add host `setup`.
