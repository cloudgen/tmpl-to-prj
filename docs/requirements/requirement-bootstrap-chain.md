**file**: docs/requirements/requirement-bootstrap-chain.md  
**Status**: Active (Version 4.1.0)  
**Area**: architecture  
**Key**: `requirement-bootstrap-chain`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Declare the **bootstrap chain** for this product: **A = `cli-template` → B = `tmpl-to-prj`**. Direction is sacred: ancestor → descendant only. Never reverse-copy this product onto `cli-template`.

**This product does not point to selfmanaged or folder-backup as origin.** Those names are retired hops / related products only. Historical copy sources stay in status history.

**Direction is sacred:** when a descendant exists, ancestor → descendant only. Never reverse-copy a descendant onto this origin.

### 1.1 Human-facing

**In one sentence:** This product grew from **cli-template**; never copy tmpl-to-prj back onto that origin.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Maintainer of tmpl-to-prj | Edit `src/tmpl-to-prj` |
| The other role | Origin A = `cli-template` | Sibling tree; do not overwrite |
| Not this file | Domain hop | `requirement-domain-tmpl-to-prj` |

| Includes | Excludes |
|----------|----------|
| A→B direction | Reverse-copy onto `src/cli-template` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Specialize further | Keep architecture; retarget identity | Work in this checkout only |

---

## 2. Core Rules (Mandatory)

### 2.1 Direction

1. This product **is** leaf B specialized from A = `cli-template`.  
2. Every edge **MUST** be **cli-template → tmpl-to-prj** only.  
3. Plans **MUST NOT** copy this ship unit onto sibling `src/cli-template`.  
4. Detected reverse-copy **MUST** be treated as critical pollution (restore A; rebuild B).  
5. Agents **MUST NOT** treat `folder-backup` as this product’s live origin.

### 2.2 Chain declaration (this product)

| Field | Value |
|-------|--------|
| **Root / hop 0** | `cli-template` — Type 0 template origin (sibling tree; do not overwrite) |
| **Immediate origin (A)** | `cli-template` |
| **Leaf (this product B)** | `tmpl-to-prj` |
| **Specialize mode** | Type 0 local-only + domain harness-docs hop; inherit architecture; retarget identity |
| **This ship unit** | `src/tmpl-to-prj` |
| **This channel ownership** | **None** — local-only install by design |
| **This domain** | harness-docs apply (`plan` / `apply`) — `requirement-domain-tmpl-to-prj` |
| **Related (not origin)** | `folder-backup` — composed sibling for dest archive; **not** parent |

### 2.3 Architecture contracts (this origin owns)

These are **this product’s** structural contracts. Descendants inherit them. They are **not** “inherited from selfmanaged” as live law.

| Layer | This origin |
|-------|-------------|
| Runtime | POSIX `/bin/sh`, `set -u`, explicit errors |
| Output SSOT | `out_*` family |
| Modular prefixes | `out_`, `inst_`, `util_`, `app_`, `path_`, `prompt_`, `t2p_` |
| Domain prefix | `t2p_` |
| Entry / dispatch | Single `app_main`; always call `app_main "$@"` at end |
| Global flags | `--quiet` / `--json` / `--debug` / `--force` / `--global` |
| Integrity companion | **Absent** (no product channel digest law) |
| Online lifecycle | **Absent** (`version-check`, `self-update`, `self-uninstall`, Type O, `SCRIPT_URL` UX) |
| Local lifecycle | **Present** — `install` / `uninstall` / `where-is-me` |
| Empty argv | Interactive = menu; off-TTY = help (not Type O) |
| Backup / restore / sudoers emit | **Absent** as this CLI’s verbs — compose sibling `folder-backup` |

### 2.4 Surface matrix (normative for this product)

| Surface | Decision | Notes for tmpl-to-prj |
|---------|----------|------------------------|
| `out_*` output SSOT | **Keep** | This origin’s family |
| Modular single-file design | **Keep** | Ship unit under `src/` |
| Global flags + `app_main` | **Keep** | Plus `--template` / `--project` / `--dry-run` |
| Storage resolve | **Keep** | Scratch only |
| Idempotency / interactive modes | **Keep** | Lifecycle only |
| Online channel | **Absent** | Not install source; not help/about product UX |
| Type O empty argv | **Absent** | TTY empty argv = menu; off-TTY = help |
| Domain backup + restore verbs on **this** CLI | **Absent** | Compose sibling `folder-backup`; do not add `backup`/`restore` tokens here |
| Sudoers print / install-script / remove-draft | **Absent** | This product does not emit sudoers |
| Local `install` / `uninstall` / `where-is-me` | **Keep** | Local self-managed package |
| Domain / out Protection Zones | **Keep spirit** | Do not simplify `out_*` |

### 2.5 Identity (this origin)

| Concern | Value |
|---------|---------|
| `APP_NAME` | `tmpl-to-prj` |
| `VERSION` | `1.0.0` (product version SSOT in ship unit) |
| Primary install story | Local copy from running ship unit → `${USER_BIN}` (default `~/.local/bin`) |
| README one-liner | **No** `curl \| sh` channel claim |

### 2.6 Implementation Notes (this product)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Workspace** | `{{PROJECTS_ROOT}}/tmpl-to-prj` (RAM `/dev/shm/tmpl-to-prj` if present) |
| **Role** | Specialized leaf from `cli-template`. Compose `folder-backup`; do not reverse-copy onto A. |
| **Related (not origin)** | `folder-backup` — dest archive sibling |

### 2.7 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: This product is the origin. Parent hops are not implied.  
- **Principle 4 / 20 – Over-protect**: Reverse-copy onto this origin is a critical pollution class.  
- **Principle 21 – Dual policies**: Identity lives in Implementation Notes and ship-unit Config.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Do not invent host `setup` or other OS-mutating verbs to fill the product name.  
- **Intentional:** Type 0 bootstrap/template origin only. Domain SSOT stays absent.  
- **Anti-fragile:** This origin stays intact so descendants can specialize from it.  
- **Over-protect:** Registry lists online and domain surfaces as absent by design.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Name `folder-backup` as this product’s live origin.  
2. Reverse-copy this leaf onto sibling `cli-template` / `src/cli-template`.  
3. Reintroduce this product’s own `backup` / `restore` / `print-sudoers` verbs.  
4. Leave domain unowned while `plan`/`apply` exist.  
5. Reintroduce online install / Type O / `SCRIPT_URL` UX without explicit user order.  
6. Drop Type 0 lifecycle while claiming this product is the Type 0 template origin.  
7. Re-add a live parent hop without explicit user order.

**Violating this rule is a critical bootstrap-direction regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Chain names **cli-template** as hop 0 / origin; no live parent |
| AC-2 | Ship unit is `src/tmpl-to-prj` |
| AC-3 | Help does not list backup / restore / print-sudoers |
| AC-4 | Unknown domain verbs fail closed |
| AC-5 | Empty argv is Type N help |
| AC-6 | Product maps and class law do **not** name selfmanaged or folder-backup as origin |

---

## 6. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-class-software-dev` | Class gate |
| `requirement-shell-cli-interface` | Type 0 verb catalog |
| `requirement-shell-local-self-management` | Local install package |
| `docs/requirements/index.md` | Registry |

---

## Design-time verification

| TP family / ID | Suite | Status | Note |
|----------------|-------|--------|------|
| **TP-CLI-04,10,13** | `tests/test_cli.sh` | have | no online verbs; backup/restore/sudoers unknown |
| **TP-CLI-07** | `tests/test_cli.sh` | have | Type N empty argv |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-03 | Active 1.0.0 | folder-backup: selfmanaged → folder-backup (trim online) |
| 2026-08-13 | Active 2.0.0 | specialize hop; trim backup/restore/sudoers; identity **cli-template** (not host-OS setup) |
| 2026-08-13 | Active 3.0.0 | Retired live hop folder-backup; briefly named selfmanaged → cli-template |
| 2026-08-13 | Active 4.0.0 | **This product is hop 0.** No live parent. selfmanaged and folder-backup are not origins. |

---

**Last Updated**: 2026-08-13  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
