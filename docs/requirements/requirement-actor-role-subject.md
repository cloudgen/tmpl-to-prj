**file**: docs/requirements/requirement-actor-role-subject.md  
**Status**: Active (Version 1.0.0)  
**Area**: architecture  
**Key**: `requirement-actor-role-subject`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Light **actor / role / subject** catalog for tmpl-to-prj. There is **no dest approver**. This is not the routed-verb table.

### 1.1 Human-facing

**In one sentence:** You name a template and a project; folder-backup (when installed) archives the project; this CLI copies docs.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator | `id -un` |
| The other role | Sibling folder-backup | dest archive |
| Not this file | Menu labels | default-interaction REQ |

| Includes | Excludes |
|----------|----------|
| Three-column catalog | Approver column; `*-adm` users |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Apply harness docs | You are the operator; dest is the subject | `tmpl-to-prj apply sh-cli-template grok-cli` |

---

## 2. Core Rules (Mandatory)

**MUST** publish this light table (no Approver). **MUST NOT** invent dest review or `*-adm`.

| Actor | Role | Subject |
|-------|------|---------|
| Current login (`id -un`) | Operator | Project named by **project-name** (RAM-first root) |
| Current login | Operator | Template named by **template-name** (RAM-first root) |
| `folder-backup` (sibling global CLI) | Durable backup tool | Dest project root |
| Host sudoers file for this login | Elev grant | Sibling dest `/etc/sudoers.d/folder-backup-<user>`; exact argv `folder-backup backup *` |
| This CLI (`tmpl-to-prj`) | Type 0 applier | Dest `docs/` except restored `docs/requirements/` |

### 2.1 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Dest review | **None** |
| Approver | **None** |

### 2.2 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: Who touches which tree is written down.  
- **Principle 10 – Least privilege**: No invented admin users.

---

## 3. Design Principles

- **Caution:** Another user’s sudoers file is not this login’s grant. Missing `/etc/{{username}}/folder-backup` is not this login’s grant either.  
- **Intentional:** Light table only.  
- **Anti-fragile:** Roles survive hops.  
- **Over-protect:** No fake dest machine.

---

## 4. Protection Rule (Sacred)

**MUST NOT** add an Approver column, invent `*-adm`, or treat the main menu as this catalog.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | Hop subjects |
| `docs/requirements/requirement-class-software-dev.md` | Points here |
| `./src/tmpl-to-prj` | Ship unit |

**Last Updated**: 2026-09-02  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
