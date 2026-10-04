# Lessons — tmpl-to-prj

Durable failure modes. **Always re-check on product review.**

| ID | Mode | Prevention | Status |
|----|------|------------|--------|
| L-TYPE-N-01 | Documented `curl \| sh` shows help because law, TP-CLI-07, and review all said Type N. **CL-ONLINE-INSTALL-SCRIPT** §2 stopped when the label was Type N. `sh path` is not the pipe (`$0` is the file) | Non-interactive 0-argv is Type O-S (`inst_self_install`). TP-CLI-07 copy; TP-CLI-31 stdin pipe, not `Usage:`. A Type N label does not waive the one-liner. **INC-20261004-003** | closed 2026-10-04 |
| L-ONLINE-01 | Online verbs treated as a trim leak after channel law landed | TP-CLI-04 (self-install listed; no `CHECKSUM` token) | closed 2026-10-04 — channel self-management is law in **1.5.0**. `SCRIPT_URL` stays this product. |
| L-ONLINE-02 | Channel points at another product, or `help`/`about` prints `CHECKSUM` | requirement-shell-self-management · requirement-shell-automatic-checksum; TP-CLI-04 | open watch |
| L-UNIN-01 | Non-interactive uninstall succeeds without force | TP-LC-05 confirm fail-closed | open watch |
| L-INST-MODE-01 | Install leaves `0711`/`0700` (chmod +x after mktemp) so non-owners cannot run shell ship unit | absolute `chmod 0755` + heal on reinstall; TP-LC-09/10; local-self-management §2.3.1 | open watch |
| L-TRIM-01 | Backup / restore / sudoers verbs reintroduced as if still product law | bootstrap-chain (absent domain); TP-CLI-04/13 | open watch |
| L-PUSH-VAULT-01 | Bare `git push` uses wrong active SSH vault when default face ≠ repository-user | Pre-git report + bound SSH transport; incident 20260810-001 | open watch |
| L-SETU-01 | `set -u` crash with unset HOME | TP-CLI-11 | open watch |
| L-STOR-01 | Shared world-writable storage | util_resolve_storage; TP-CLI-12 | open watch |
| L-FB-GATE-01 | Guess `/etc/<user>/folder-backup` and call a miss “verb-only too narrow” while sibling dest `/etc/sudoers.d/folder-backup-<user>` has `backup *` | Probe sibling dest + `sudo -n -l`; split narrow vs unproven; TP-TMPL-TO-PRJ-14..16; INC-20260902-001. Do **not** treat a TTY as a grant (**INC-20261004-001**) | open watch |
| L-FB-GATE-02 | `apply` runs password `sudo folder-backup backup` because the session has a TTY and no NOPASSWD fragment | Existence of `folder-backup` first, else skip; then root or NOPASSWD `backup *` only (`sudo -n`); else stop and name `submit-sudoer-request` plus the fragment; TP-TMPL-TO-PRJ-24..25; **INC-20261004-001** | open watch |
| L-FB-GATE-03 | After gate pass, a failed `folder-backup backup` is told to check sudoers argv | Next names the child error, not sudoers; still no overlay; TP-TMPL-TO-PRJ-26; **INC-20261004-002**. The 1421 != 1418 symlink count stays on sibling folder-backup | open watch |
| L-T2P-INC-01 | Apply `rm -rf dest/docs` after saving only requirements: dest incident bodies gone, dest `AGENTS.md` still lists them | Aside+restore dest `docs/incidents/` with requirements; TP-TMPL-TO-PRJ-20/21; **INC-20260910-001** | open watch |
| L-T2P-KIT-01 | Template picker lists every `~/prjs` child because `docs/README.md` still says Template name after a hop | Unspecialized kit only: 0 `requirement-*.md`, no incident bodies, no product tests; TP-TMPL-TO-PRJ-17 | open watch |
| L-T2P-BACK-01 | TTY name pickers have no numbered return to the main menu (9 collides with item 9 on long lists) | Print **only 0. Back to main menu**; accept all-nines when free (do not print a second Back row); TP-TMPL-TO-PRJ-19 | open watch |
| L-T2P-ID-01 | Implementation Notes still say `cli-template` / `src/cli-template` after A→B | Retarget notes to `tmpl-to-prj`; AC-2 ship unit `src/tmpl-to-prj`; registry honesty | closed 2026-09-06 |
| L-TX-SUDO-01 | Termux / Git Bash still invoke `sudo folder-backup` or recommend `sudo install` | Detect class; `util_sudo` skip; gate missing; TP-TX-06..08 | open watch |

**Related-product only (do not re-apply as this origin’s law):** L-DEPOSIT-01, L-SUDOERS-01..05, L-OVERWRITE-01 stay on folder-backup. Channel self-management is this product’s law (L-ONLINE-02).

**This origin’s kept surfaces:** output SSOT, no basename gate on entry, storage isolation, TTY menu, non-interactive 0-argv self-install (not help).
