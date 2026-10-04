**file**: docs/requirements/requirement-bootstrap-chain.md  
**Status**: Active (Version 4.2.0)  
**Area**: architecture  
**Key**: `requirement-bootstrap-chain`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Declare the **bootstrap chain** for this product: **A = `selfmanaged` → B = `tmpl-to-prj`**. Direction is sacred: ancestor → descendant only. Never reverse-copy this product onto `selfmanaged`.

**Historical hop:** `cli-template` remains an earlier ancestor. Do not reverse-copy onto `cli-template` either. **`folder-backup` is not an origin.** It is a composed sibling for dest archive.

User order on 2026-10-04 re-opened the live parent hop and added selfmanaged self-management plus the merged main menu, while keeping every tmpl-to-prj feature (plan/apply, Type N empty argv, local `install` at mode 0755, folder-backup gate, Termux freeze).

### 1.1 Human-facing

**In one sentence:** This product is specialized from **selfmanaged**; never copy tmpl-to-prj back onto that origin.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Maintainer of tmpl-to-prj | Edit `src/tmpl-to-prj` |
| The other role | Origin A = `selfmanaged` | Sibling tree; do not overwrite |
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

1. This product **is** leaf B specialized from A = `selfmanaged`.  
2. The live edge **MUST** be **selfmanaged → tmpl-to-prj** only. Historical hop `cli-template` stays in history and **MUST NOT** be overwritten.  
3. Plans **MUST NOT** copy this ship unit onto sibling `selfmanaged` or `cli-template`.  
4. Detected reverse-copy **MUST** be treated as critical pollution (restore A; rebuild B).  
5. Agents **MUST NOT** treat `folder-backup` as this product’s live origin.

### 2.2 Chain declaration (this product)

| Field | Value |
|-------|--------|
| **Historical hop** | `cli-template` — earlier Type 0 template (sibling tree; do not overwrite) |
| **Immediate origin (A)** | `selfmanaged` |
| **Leaf (this product B)** | `tmpl-to-prj` |
| **Specialize mode** | Inherit selfmanaged self-management and menu law; keep tmpl-to-prj domain, Type N empty argv, and local 0755 `install` |
| **This ship unit** | `src/tmpl-to-prj` |
| **This channel** | `https://raw.githubusercontent.com/cloudgen/tmpl-to-prj/main/src/tmpl-to-prj` — not selfmanaged’s channel |
| **This domain** | harness-docs apply (`plan` / `apply`) — `requirement-domain-tmpl-to-prj` |
| **Related (not origin)** | `folder-backup` — composed sibling for dest archive; **not** parent |

### 2.3 Architecture contracts (this origin owns)

These structural contracts are inherited from selfmanaged and kept with the tmpl-to-prj exceptions in the surface matrix.

| Layer | This origin |
|-------|-------------|
| Runtime | POSIX `/bin/sh`, `set -u`, explicit errors |
| Output SSOT | `out_*` family |
| Modular prefixes | `out_`, `inst_`, `util_`, `app_`, `path_`, `prompt_`, `t2p_` |
| Domain prefix | `t2p_` |
| Entry / dispatch | Single `app_main`; always call `app_main "$@"` at end |
| Global flags | `--quiet` / `--json` / `--debug` / `--force` / `--global` |
| Integrity companion | **Present** — `${SCRIPT_URL}.sha256`; `CHECKSUM` pin not shown in help/about |
| Online lifecycle | **Present** — `self-install`, `version-check`, `self-update`, `self-uninstall`, `SCRIPT_URL` |
| Local lifecycle | **Present** — `install` / `uninstall` / `where-is-me` at mode **0755** (not an alias of `self-install`) |
| Empty argv | Interactive = menu; off-TTY = help (Type N kept; not Type O) |
| Backup / restore / sudoers emit | **Absent** as this CLI’s verbs — compose sibling `folder-backup` |

### 2.4 Surface matrix (normative for this product)

| Surface | Decision | Notes for tmpl-to-prj |
|---------|----------|------------------------|
| `out_*` output SSOT | **Keep** | This origin’s family |
| Modular single-file design | **Keep** | Ship unit under `src/` |
| Global flags + `app_main` | **Keep** | Plus `--template` / `--project` / `--dry-run` |
| Storage resolve | **Keep** | Scratch only |
| Idempotency / interactive modes | **Keep** | Lifecycle only |
| Online channel | **Keep** (B’s URL, not A’s) | `self-install` / `self-update` / `version-check` |
| Type O empty argv | **Absent** (authorized exception) | TTY empty argv = menu; off-TTY = help |
| Domain backup + restore verbs on **this** CLI | **Absent** | Compose sibling `folder-backup`; do not add `backup`/`restore` tokens here |
| Sudoers print / install-script / remove-draft | **Absent** | This product does not emit sudoers |
| Local `install` / `uninstall` / `where-is-me` | **Keep** | Local self-managed package |
| Domain / out Protection Zones | **Keep spirit** | Do not simplify `out_*` |

### 2.5 Identity (this origin)

| Concern | Value |
|---------|---------|
| `APP_NAME` | `tmpl-to-prj` |
| `VERSION` | `1.5.1` (product version SSOT in ship unit) |
| Primary install story | Local `install` (0755) and channel `self-install` / `curl \| sh` of this product’s `SCRIPT_URL` |
| README one-liner | Channel URL is this product’s, not selfmanaged’s |

### 2.6 Implementation Notes (this product)

| Item | Value |
|------|--------|
| **Product** | `tmpl-to-prj` |
| **Workspace** | `{{PROJECTS_ROOT}}/tmpl-to-prj` (RAM `/dev/shm/tmpl-to-prj` if present) |
| **Role** | Specialized leaf from `selfmanaged`. Keep domain and local install. Compose `folder-backup`; do not reverse-copy onto A. |
| **Related (not origin)** | `folder-backup` — dest archive sibling |

### 2.7 Why This Requirement Exists (CIAO)

- **Principle 2 – Intentional**: This product is the origin. Parent hops are not implied.  
- **Principle 4 / 20 – Over-protect**: Reverse-copy onto this origin is a critical pollution class.  
- **Principle 21 – Dual policies**: Identity lives in Implementation Notes and ship-unit Config.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Do not invent host `setup` or other OS-mutating verbs to fill the product name.  
- **Intentional:** Leaf specialized from selfmanaged, with tmpl-to-prj domain kept.  
- **Anti-fragile:** Do not overwrite selfmanaged.  
- **Over-protect:** Channel is this product’s URL. Empty argv stays Type N. Local install stays 0755.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Name `folder-backup` as this product’s live origin.  
2. Reverse-copy this leaf onto sibling `cli-template` / `src/cli-template`.  
3. Reintroduce this product’s own `backup` / `restore` / `print-sudoers` verbs.  
4. Leave domain unowned while `plan`/`apply` exist.  
5. Remove channel self-management or point `SCRIPT_URL` at selfmanaged without a new user order.  
6. Drop local `install` (0755) or Type N empty argv while claiming all tmpl-to-prj features are kept.  
7. Reverse-copy this leaf onto `selfmanaged`.

**Violating this rule is a critical bootstrap-direction regression.**

---

## 5. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Chain names **selfmanaged** as immediate origin; `cli-template` is historical |
| AC-2 | Ship unit is `src/tmpl-to-prj` |
| AC-3 | Help does not list this product’s backup / restore / print-sudoers verbs |
| AC-4 | Unknown domain verbs fail closed |
| AC-5 | Empty argv is Type N (TTY menu / off-TTY help) |
| AC-6 | `SCRIPT_URL` names `tmpl-to-prj`, not `selfmanaged` |

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
| **TP-CLI-04,10,13** | `tests/test_cli.sh` | have | channel verbs present; backup/restore/sudoers unknown; unreachable channel fails loud |
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
| 2026-09-06 | Active 4.1.0 | Notes aligned; origin remained cli-template |
| 2026-10-04 | Active 4.2.0 | User order: live origin **selfmanaged → tmpl-to-prj**; keep domain, Type N, local 0755 install |

---

**Last Updated**: 2026-10-04  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
