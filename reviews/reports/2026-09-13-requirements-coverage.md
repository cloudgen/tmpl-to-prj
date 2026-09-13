# Report: requirements + coverage — tmpl-to-prj 1.2.1

**Date:** 2026-09-13  
**Mode:** C-full-product (requirement review + sufficient check + RTM)  
**Status:** findings fixed in the same change  
**Ship unit:** `src/tmpl-to-prj` `VERSION=1.2.1`  
**Suite:** PASS=198 FAIL=0 SKIP=0 (`./tests/run.sh`)

## Summary

Class gate Pass: software-development, one Active `requirement-class-software-dev`, one Active domain SSOT `requirement-domain-tmpl-to-prj` **1.6.0**. Registry ↔ disk match (17/17). Uncommitted 1.2.1 overlay already owned dest specialized `docs/` folders and TP-20..23. This pass closed leftover law/coverage honesty gaps: CLI help still said test-purpose was none in v1; RTM omitted coding-style; TP-23 did not prove kit `docs/reviews/` when dest lacked it; public `reviews/` still named cli-template.

## Requirement review (registry + class)

### Registry inventory (Step −1)

- Registered on disk: 17 rows in `docs/requirements/index.md` (class, bootstrap-chain, project-folder, actor-role-subject, CLI family, coding-style, sudo, Termux-ish, domain).
- On disk, not in registry: none.
- In registry, missing on disk: none.
- Foreign candidates in registered law: none remaining after 1.2.0 retarget (L-T2P-ID-01 closed). Public `reviews/README.md` and `reviews/index.md` still said **cli-template** / `src/cli-template` **1.0.0** — product-surface identity, not a requirement file; **fixed this turn**.
- Scope: registry-only plus public `reviews/` coverage maps (user asked requirements and coverage).

### Bootstrap / rewrite gate (Step 0)

- Direction: **cli-template → tmpl-to-prj**; shared Type 0 architecture; local-only (no reverse-copy).
- Edits: authorized (user: review, fix, commit, push). Surgical law/tests/reviews only; no tree rewrite.

### Class gate (Step −2)

- Project nature: software-development. Pass.
- Actor/role/subject: Active light `requirement-actor-role-subject` (no dest approver). Pass.
- Dest fence residual: considered — no dest fence conditions. Pass.
- Coding-style related REQ: Active `requirement-shell-script-coding` (specialize-in intention present). Pass (RTM row was missing; **fixed**).
- Install-mode: local-only (`install` + `uninstall` + `where-is-me`). Pass.

## Requirement sufficient check

### Claim

- ID: **C-full-product**
- Text: Full specialized tmpl-to-prj including domain hop.

### SSOT preflight

- Identity: aligned (`APP_NAME=tmpl-to-prj`, `VERSION=1.2.1`, `REPO_USER=cloudgen`, empty `SCRIPT_URL`).
- Notes: class residual version SSOT matches ship unit.

### Live surfaces

- Lifecycle: install, uninstall, where-is-me, version, about, help.
- Domain: plan, apply, menu/main; test-purpose list-templates, list-projects.
- Help-only: none (help matches dispatcher).

### Ownership matrix (post-fix)

| Surface | Class | Owner | Status |
|---------|-------|-------|--------|
| Dispatcher verbs | lifecycle + domain | CLI interface + topic owners | ok |
| Help test-purpose heading | domain / CLI | CLI 2.1.1 + domain 1.6.0 | ok (was Gap: “none in v1”) |
| Overlay dest specialized docs folders | domain | `requirement-domain-tmpl-to-prj` 1.6.0 | ok |
| Local install 0755 | lifecycle | local-self-management | ok |
| Termux / Git Bash freeze | lifecycle | termux-ish + sudo-command | ok |
| Coding-style specialize-in | shell | script-coding | ok (RTM row added) |

### Artifact filename + content

- Kind: dest overlay folders (not allocated product filenames). Filename grammar N/A. Overlay table + recipe + samples via TP fixtures. Status: ok.

### Dual mention (Step 3h)

- Every routed verb on CLI REQ and topic-owner. Topic-owner invocation samples present. Help is not counted as second mention. **Was Fail** on help law vs live testers; **fixed** 2.1.1.

### In-tool sudo allow table (Step 3j)

- Studied dest `/etc/sudoers.d/folder-backup-<user>` + argv `backup *`. Pass (INC-20260902-001 class).

### Verdict

- **Sufficient** after this-turn fixes.
- Rationale: domain surface is owned; dest specialized-folder preserve is law + TP-20..23; leftover honesty gaps closed.

## Issues

### Issue 1 -- Severity: bug
- File: `docs/requirements/requirement-shell-cli-interface.md:83`
- Description: Help MUST said test-purpose **(none in v1)** while dispatcher, help body, and TP-TMPL-TO-PRJ-11 list `list-templates` / `list-projects`.
- Suggestion: Name those verbs as the apart test-purpose set. Bump 2.1.1.
- Lesson: L-T2P-ID-01 class (stale notes vs live catalog)
- Test: TP-TMPL-TO-PRJ-11
- Status: closed

### Issue 2 -- Severity: bug
- File: `tests/test_domain_tmpl_to_prj.sh` (TP-TMPL-TO-PRJ-23)
- Description: Law 1.6.0 and the test-plan row include dest `docs/reviews/` keep-or-placeholder. Kit fixture had no `docs/reviews/`, so TP-23 could not prove the placeholder path.
- Suggestion: Kit includes `docs/reviews/README.md`; assert dest-without-dir keeps `FROM-KIT-DREV-README`; dest-with-dir does not take the kit README.
- Lesson: L-T2P-INC-01
- Test: TP-TMPL-TO-PRJ-22/23
- Status: closed

### Issue 3 -- Severity: suggestion
- File: `reviews/requirement-test-matrix.md`
- Description: Active `requirement-shell-script-coding` had DTV (TP-CLI-01/11) but no RTM row. CLI DTV omitted TP-CLI-17 and TP-TMPL-TO-PRJ-11.
- Suggestion: Add RTM row; extend CLI DTV.
- Test: TP-CLI-01, TP-CLI-11, TP-CLI-17, TP-TMPL-TO-PRJ-11
- Status: closed

### Issue 4 -- Severity: suggestion
- File: `reviews/README.md:1`
- Description: Public reviews surface still titled cli-template, ship unit `src/cli-template` VERSION 1.0.0.
- Suggestion: Retarget README + report index to tmpl-to-prj 1.2.1.
- Lesson: L-T2P-ID-01
- Test: n/a (docs identity)
- Status: closed

### Issue 5 -- Severity: nit
- File: `reviews/cli-routed-verb-table.md`
- Description: Apply human-readable added a parenthetical not present on the default-interaction menu label or TP-CLI-17.
- Suggestion: Keep verb-table label equal to the menu MUST row; help owns the long apply recipe.
- Test: TP-CLI-17
- Status: closed

## Non-findings

| Check | Result |
|-------|--------|
| Class + domain SSOT uniqueness | Pass |
| Local-only / no SCRIPT_URL UX | Pass (TP-CLI-04/10) |
| Trimmed backup/restore/print-sudoers | Pass (TP-CLI-13) |
| Overlay recipe vs ship unit `t2p_overlay_docs` | Pass |
| Termux Under-command-line sections on related shell + domain REQs | Pass (output-only N/A) |
| Human-facing §1.1 on all 17 REQs | Pass |
| Type 1 TTY elevation plan | N/A (Type 0 only) |
| LPU / LPA | N/A |

## Priority remediation order

1. Closed this turn (Issues 1–5).
2. Open watch only: lessons L-* in `reviews/lessons.md` (not new defects).

## Related

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `reviews/requirement-test-matrix.md` | RTM |
| `reviews/test-plan.md` | TP map |
| `docs/requirements/requirement-domain-tmpl-to-prj.md` | Domain SSOT 1.6.0 |
| INC-20260910-001 | Dest specialized-folder wipe class |

**Written by:** requirement review + sufficient check (this turn)  
**Review status:** Findings closed
