**file**: docs/requirements/requirement-bootstrap-chain.md  
**Status**: Active (Version 5.0.0)  
**Area**: architecture  
**Key**: `requirement-bootstrap-chain`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Declare the **bootstrap chain** for this product: **A = `selfmanaged` → B = `tmpl-to-prj`**. Direction is sacred: ancestor → descendant only. Never reverse-copy this product onto sibling `selfmanaged`.

**cli-template** and **folder-backup** are related products only (historical hop / dest-archive sibling). They are **not** the live origin.

**Direction is sacred:** ancestor → descendant only. Never reverse-copy this leaf onto origin A.

### 1.1 Human-facing

**In one sentence:** This product grew from sibling **selfmanaged**; never copy tmpl-to-prj back onto that origin.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Maintainer of tmpl-to-prj | Edit `src/tmpl-to-prj` |
| The other role | Origin A = `selfmanaged` | Sibling tree; do not overwrite |
| Not this file | Domain hop | `requirement-domain-tmpl-to-prj` |

| Includes | Excludes |
|----------|----------|
| A→B direction | Reverse-copy onto sibling `selfmanaged` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Specialize further | Keep Type 0 architecture; keep domain | Work in this checkout only |

---

## 2. Core Rules (Mandatory)

### 2.1 Direction

1. This product **is** leaf B specialized from A = `selfmanaged`.  
2. Every edge **MUST** be **selfmanaged → tmpl-to-prj** only.  
3. Plans **MUST NOT** copy this ship unit onto sibling `selfmanaged`.  
4. Detected reverse-copy **MUST** be treated as critical pollution (restore A; rebuild B).  
5. Agents **MUST NOT** treat `cli-template` or `folder-backup` as this product’s live origin.

### 2.2 Chain declaration (this product)

| Field | Value |
|-------|--------|
| **Root / hop 0** | `selfmanaged` — Type 0 online self-managed origin (sibling tree; do not overwrite) |
| **Immediate origin (A)** | `selfmanaged` |
| **Leaf (this product B)** | `tmpl-to-prj` |
| **Specialize mode** | Inherit Type 0 online self-management + automatic checksum; **extend** domain harness-docs hop; TTY empty argv is the numbered menu |
| **This ship unit** | `src/tmpl-to-prj` (published channel copy `./tmpl-to-prj`) |
| **This channel ownership** | `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj` |
| **This domain** | harness-docs apply (`plan` / `apply`) — `requirement-domain-tmpl-to-prj` |
| **Related (not origin)** | `folder-backup` — composed sibling for dest archive; **not** parent. `cli-template` — retired historical hop. |

### 2.3 Architecture contracts (inherited from A, extended on B)

| Layer | This product |
|-------|-------------|
| Runtime | POSIX `/bin/sh`, `set -u`, explicit errors |
| Output SSOT | `out_*` family |
| Modular prefixes | `out_`, `inst_`, `util_`, `app_`, `path_`, `prompt_`, `ver_`, `t2p_` |
| Domain prefix | `t2p_` |
| Entry / dispatch | Single `app_main`; always call `app_main "$@"` at end |
| Global flags | `--quiet` / `--json` / `--debug` / `--force` / `--global` plus `--template` / `--project` / `--dry-run` |
| Integrity companion | **Present** — `tmpl-to-prj.sha256` (`requirement-shell-automatic-checksum`) |
| Online lifecycle | **Present** — `install`, `version-check`, `self-update`, `self-uninstall`, `SCRIPT_URL` |
| Empty argv | TTY = numbered menu; off-TTY / JSON / QUIET = Type O install-ensure |
| Backup / restore / sudoers emit | **Absent** as this CLI’s verbs — compose sibling `folder-backup` |

### 2.4 Surface matrix (normative for this product)

| Surface | Decision | Notes for tmpl-to-prj |
|---------|----------|------------------------|
| `out_*` output SSOT | **Keep** from A | Surgical only |
| Modular single-file design | **Keep** | `src/tmpl-to-prj` + repo-root channel copy |
| Global flags + `app_main` | **Keep** | Plus domain flags |
| Storage resolve | **Keep** | Scratch only |
| Idempotency / interactive modes | **Keep** | Type 0 + apply confirm |
| Online channel | **Keep** from A | B’s `SCRIPT_URL`, not A’s |
| Type O empty argv | **Keep off-TTY** | TTY empty argv is the numbered menu |
| Domain backup + restore verbs on **this** CLI | **Absent** | Compose sibling `folder-backup` |
| Sudoers print / install-script / remove-draft | **Absent** | This product does not emit sudoers |
| `install` / `self-update` / `self-uninstall` / `version-check` | **Keep** from A | Online self-managed package |
| Domain / out Protection Zones | **Keep** | Do not simplify `out_*` |

### 2.5 Identity (this product)

| Concern | Value |
|---------|---------|
| `APP_NAME` | `tmpl-to-prj` |
| `VERSION` | `1.3.0` (product version SSOT in ship unit) |
| Primary install story | `curl -fsSL https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/tmpl-to-prj \| sh` |
| README one-liner | **Yes** — Config `SCRIPT_URL` default |

### 2.6 Implementation Notes (this product)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Workspace** | `{{PROJECTS_ROOT}}/tmpl-to-prj` (RAM `/dev/shm/tmpl-to-prj` if present) |
| **Role** | Specialized leaf from `selfmanaged`. Compose `folder-backup`; do not reverse-copy onto A. |
| **Related (not origin)** | `folder-backup` — dest archive sibling; `cli-template` — retired hop |

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

1. Name `cli-template` or `folder-backup` as this product’s live origin.  
2. Reverse-copy this leaf onto sibling `selfmanaged`.  
3. Reintroduce this product’s own `backup` / `restore` / `print-sudoers` verbs.  
4. Leave domain unowned while `plan`/`apply` exist.  
5. Drop online install / Type O off-TTY / `SCRIPT_URL` UX without explicit user order.  
6. Drop Type 0 lifecycle (`install` / `self-update` / `self-uninstall` / `version-check`) while claiming the same architecture as `selfmanaged`.  
7. Re-add a live parent hop without explicit user order.

**Violating this rule is a critical bootstrap-direction regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Chain names **selfmanaged** as hop 0 / origin |
| AC-2 | Ship unit is `src/tmpl-to-prj` with published `./tmpl-to-prj` |
| AC-3 | Help does not list backup / restore / print-sudoers |
| AC-4 | Unknown domain verbs fail closed |
| AC-5 | Off-TTY empty argv is Type O install-ensure; TTY empty argv is the numbered menu |
| AC-6 | Product maps and class law name **selfmanaged** as origin; folder-backup is related only |

---

## 6. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-class-software-dev` | Class gate |
| `requirement-shell-cli-interface` | Type 0 verb catalog |
| `requirement-shell-self-management` | Online Type 0 lifecycle |
| `docs/requirements/index.md` | Registry |

---

## Design-time verification

| TP family / ID | Suite | Status | Note |
|----------------|-------|--------|------|
| **TP-CLI-04,13** | `tests/test_cli.sh` | have | Type 0 + domain help; backup/restore/sudoers unknown |
| **TP-LC-*** | `tests/test_install_lifecycle.sh` | have | online install / Type O off-TTY |
| **TP-CSUM** | `tests/test_install_lifecycle.sh` | have | companion digest |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-03 | Active 1.0.0 | folder-backup: selfmanaged → folder-backup (trim online) |
| 2026-08-13 | Active 2.0.0 | specialize hop; trim backup/restore/sudoers; identity **cli-template** (not host-OS setup) |
| 2026-08-13 | Active 3.0.0 | Retired live hop folder-backup; briefly named selfmanaged → cli-template |
| 2026-08-13 | Active 4.0.0 | **This product is hop 0.** No live parent. selfmanaged and folder-backup are not origins. |
| 2026-09-16 | Active 5.0.0 | **Live origin = selfmanaged.** Inherit online Type 0; domain hop stays on B. |

---

**Last Updated**: 2026-09-16  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
