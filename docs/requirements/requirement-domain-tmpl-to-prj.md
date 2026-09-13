**file**: docs/requirements/requirement-domain-tmpl-to-prj.md  
**Status**: Active (Version 1.6.0)  
**Area**: domain  
**Key**: `requirement-domain-tmpl-to-prj`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **current domain SSOT** for tmpl-to-prj: copy **portable harness docs** from a **genesis-template or subclass** (template-name) into a **named dest project** (project-name), **preserving dest specialized `docs/` folders**.

### 1.1 Human-facing

**In one sentence:** You name a template kit and a project; this CLI copies the kit’s `docs/` onto the project and puts the project’s own specialized docs folders back.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Operator who names both trees | `tmpl-to-prj apply sh-cli-template grok-cli` |
| The other role | Sibling `folder-backup` when globally installed | Durable dest archive |
| Not this file | Type 0 install / help printers | `requirement-shell-cli-interface` |

| Includes | Excludes |
|----------|----------|
| RAM-first resolve of both names | Overlay of dest `src/`, tests, root README, `AGENTS.md` |
| `mv` dest specialized `docs/` folders aside before copy | Emptying dest product law, postmortems, filled checklists, live grants, or housekeeping summaries to match genesis |
| folder-backup dest backup when the gate passes | This product emitting its own sudoers |

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/tmpl-to-prj` | ship unit | live behavior |
| `tmpl-to-prj apply …` | command | the hop |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Preview roots | No writes | `tmpl-to-prj plan sh-cli-template grok-cli` |
| Apply the hop | Dest docs replaced; dest specialized docs folders kept | `tmpl-to-prj apply --force sh-cli-template grok-cli` |
| Pick from lists | Terminal shows unspecialized kits, then current folder / `~/prjs`; **0** returns to the main menu | `tmpl-to-prj` then `2` then `0` |

---

## 2. Core Rules (Mandatory)

### 2.1 Specialized CLI subcommands

| Command | Handler | Type | Behavior |
|---------|---------|------|----------|
| `plan` | `t2p_plan` | Type 0 | Resolve names, detect hosts, folder-backup gate, counts. **No** `mv` / `rm` / copy |
| `apply` | `t2p_apply` | Type 0 | Confirm (unless `--force`) → backup dest → overlay docs → restore dest specialized docs folders |
| `menu` / `main` | `app_default` | Type 0 | Numbered list; then TTY template list and project list |
| `list-templates` | `t2p_cmd_list_templates` | Type 0 test-purpose | Print genesis-shaped kits; no writes |
| `list-projects` | `t2p_cmd_list_projects` | Type 0 test-purpose | Print current folder (if a project) and `PROJECTS_ROOT` children |

Dual mention: these tokens **MUST** also appear on `requirement-shell-cli-interface`.

Operands / flags:

| Token | Meaning |
|-------|---------|
| **template-name** | Genesis-template or subclass basename, or an existing absolute directory |
| **project-name** | Dest project basename, or an existing absolute directory |
| `--template NAME` | Same as template-name |
| `--project NAME` | Same as project-name |
| `--dry-run` | `apply` **MUST** behave as `plan` |

**MUST NOT** silently default dest to `$PWD`. Missing names:

| Mode | MUST |
|------|------|
| Interactive TTY | Numbered list of **templates** (unspecialized kits under RAM + `PROJECTS_ROOT`), then numbered list of **projects**: current folder if it is a project, **and** children of `PROJECTS_ROOT` (RAM-first). Pick a number (or a listed basename). Current-folder pick **MUST** use that absolute path. Each picker **MUST** end with **exactly one** numbered back row: **0. Back to main menu**. **MUST NOT** also print **9** / **99** as a second Back row. Choosing **0**, the all-nines number when it is not an item (**9** when eight or fewer rows, **99** when ninety-eight or fewer), `exit`, `quit`, or `back` **MUST** return to the numbered main menu and **MUST NOT** exit the process and **MUST NOT** apply. |
| Non-interactive / `--json` | Fail closed; **MUST NOT** hang. Next: pass both names |

Test-purpose (help lists **apart** from operational): `list-templates`, `list-projects` print the same numbered inventories and return (no pick, no writes).

### 2.2 Specialized features

#### Host resolve (RAM-drive first)

For each basename:

1. If operand is an existing absolute directory → use it (`host_version=explicit-path`).  
2. Else if `${T2P_RAM_ROOT}/{{NAME}}` exists (default `T2P_RAM_ROOT=/dev/shm`) → that root (`ram-drive`).  
3. Else if `${PROJECTS_ROOT}/{{NAME}}` exists (default `${HOME}/prjs`) → that root (`hard-disk`).  
4. Else **fail closed**. **MUST NOT** invent a path. **MUST NOT** dual-write RAM and hard-disk.

**MUST** print both resolved roots and host versions on `plan` and human `apply`.

Refuse: `$HOME`, `/`, `/home`, `/dev`, `/dev/shm` (the mount), `${T2P_RAM_ROOT}` itself. Source ≠ dest.

Template **MUST** be an **unspecialized** kit. All of:

1. `docs/` exists.  
2. **0** `docs/requirements/requirement-*.md`.  
3. **0** incident bodies (files under `docs/incidents/` other than `README.md`).  
4. **0** product tests (files under `tests/` other than `README.md`).

`docs/requirements/README.md` and `docs/incidents/README.md` **MAY** exist (genesis placeholders). **MUST NOT** treat `docs/README.md` mentioning genesis / stripped-genesis / Template name as sufficient — specialized products keep that map after a hop and **MUST NOT** appear on the template list.

Project **MUST** have `docs/` or `AGENTS.md`.

#### folder-backup gate

Sibling binary `{{GLOBAL_BIN}}/folder-backup` (override `T2P_FOLDER_BACKUP`). Corresponding sudoers for **this** `id -un` — **sibling dest first** (from sibling `print-sudoers`):

| Probe (in order) | Override |
|------------------|----------|
| `/etc/sudoers.d/folder-backup-{{username}}` | `T2P_SUDOERS_D_DIR` replaces `/etc/sudoers.d` (tests) |
| Legacy `/etc/sudoers.d/folder-backup` | same |
| Optional harness path `/etc/{{username}}/folder-backup` | skipped when `T2P_SUDOERS_D_DIR` is set |
| `sudo -n -l` listing `folder-backup backup *` | skipped when `T2P_SUDOERS_FILE` or `T2P_SUDOERS_D_DIR` is set |
| Explicit file | `T2P_SUDOERS_FILE` (tests; exclusive) |

| Gate | Meaning | apply |
|------|---------|-------|
| **missing** | Global binary not executable / version fails | Local dest-docs snapshot under dest `.t2p-docs-backup-<stamp>`; honest that it dies with `$HOME` wipe |
| **narrow** | Binary exists; a readable fragment or `sudo -l` listing **shows** verb-only `backup` (no `*`) | **Fail closed**. Next: sibling `folder-backup print-sudoers` |
| **unproven** | Binary exists; no `backup *` and no observed verb-only; off-TTY / `--json` | **Fail closed**. Honest Next: TTY `sudo folder-backup backup {{DEST_ROOT}}`. **MUST NOT** call this verb-only. **MUST NOT** treat a missing `/etc/{{username}}/folder-backup` as narrow |
| **pass** | Fragment or `sudo -n -l` allows `folder-backup backup *`, **or** TTY (not JSON) and not observed verb-only | `sudo {{GLOBAL_BIN}}/folder-backup backup {{DEST_ROOT}}`; require success. Matching NOPASSWD → `sudo -n` allowed. **MUST NOT** also create `.t2p-docs-backup-*` |

**MUST NOT** auto-write `/etc`. **MUST NOT** invent `sudo cp` / `mkdir` / `tar`. **MUST NOT** use host `(ALL:ALL) ALL` from a non-TTY session. Another user’s sudoers file is **not** sufficient.

In-tool sudo **MUST** go through `util_sudo` (`requirement-shell-sudo-command`).

v1 backs up **dest** (the mutated tree). Help **MAY** mention optional source backup: `sudo folder-backup backup <template-root>`. A source archive **MUST NOT** be reported as the dest backup.

#### Overlay (sacred preserve)

Specialized dest `docs/` folders (keep when dest **had** that directory):

| Dest folder | Why keep |
|-------------|----------|
| `docs/requirements/` | Product law |
| `docs/incidents/` | Postmortems (`INC-20260910-001`) |
| `docs/checklists/` | Filled audit runs (not blank `docs/templates/checklists/`) |
| `docs/whitelists/` | Live exception grants |
| `docs/housekeeping/` | Local cadence summaries |
| `docs/reviews/` | Dest TP map when it lives under `docs/` (product-root `reviews/` is already outside overlay) |

Recipe:

1. `mv` dest `docs/requirements/` aside (storage tmp) when that directory exists.  
2. For each other specialized dest folder in the table: `mv` dest `docs/<name>/` aside when that directory exists.  
3. Remove dest `docs/`.  
4. Copy template `docs/` to dest `docs/`.  
5. Remove the **copied** `docs/requirements/` (template registry **MUST NOT** remain).  
6. `mv` dest requirements back when dest had that directory.  
7. For each other specialized folder dest **had**: remove the **copied** `docs/<name>/` (kit placeholder **MUST NOT** replace dest bodies) and `mv` dest folder back. If dest had **no** such directory, keep the copied template placeholder.  
8. On failure after aside: restore every asided dest folder; fail closed.

Portable dest folders **MUST** be replaced from the kit: `docs/skills/`, `docs/terminologies/`, `docs/templates/`, `docs/policies/`, `docs/human-intro/`, dest `docs/README.md` (then warn: rebind maps).

**MUST NOT** copy dest `AGENTS.md`, `src/`, `tests/`, product-root `reviews/`, root README/CHANGELOG/LICENSE/SECURITY.

**MUST NOT** wipe dest `incident-*.md` bodies (or dest `docs/incidents/README.md`) while leaving dest `AGENTS.md` (which may list those IDs). That split is the INC-20260910-001 class (grok-cli dest map vs disk). The same class applies to dest filled checklists, live whitelist grants, housekeeping summaries, and dest `docs/reviews/` when dest had those directories.

After apply, dest `docs/README.md` **MAY** still describe the source kit. **MUST** warn: rebind dest maps in an agent session. This CLI **MUST NOT** impersonate that rebind.

### 2.3 Specialized project help items

`help` **MUST** list `plan`, `apply`, `menu`/`main` with one-line purposes, `--template` / `--project` / `--dry-run`, RAM-first env (`T2P_RAM_ROOT`, `PROJECTS_ROOT`), and keep Type 0 lifecycle rows. **MUST** list test-purpose under a heading **apart**: `list-templates`, `list-projects`. **MUST NOT** advertise this product’s own `backup` / `restore` / `print-sudoers` verbs.

### 2.4 Specialized project about items

`about` **MUST** keep Type 0 diagnostics **and** show RAM-drive root, projects root, and a one-line domain note. JSON **MUST** include `ram_root`, `projects_root`, `domain`.

### 2.5 Implementation Notes (this project)

| Item | Value |
|------|--------|
| Product / APP_NAME | `tmpl-to-prj` |
| Ship unit | `src/tmpl-to-prj` |
| Domain prefix | `t2p_` |
| Default RAM parent | `/dev/shm` (`T2P_RAM_ROOT`) |
| Default projects parent | `${HOME}/prjs` (`PROJECTS_ROOT`) |
| Sibling backup CLI | `folder-backup` at `GLOBAL_BIN` |
| Sudo wrap | `util_sudo` → only `folder-backup backup <dest-root>` |
| Test overrides | `T2P_FOLDER_BACKUP`, `T2P_SUDOERS_FILE`, `T2P_SUDOERS_D_DIR`, `T2P_BACKUP_NOSUDO=1` |

Invocation samples:

```text
tmpl-to-prj plan sh-cli-template grok-cli
tmpl-to-prj apply --force --template sh-cli-template --project grok-cli
tmpl-to-prj apply --dry-run genesis-template tmpl-to-prj
tmpl-to-prj menu
```

### 2.6 Why This Requirement Exists (CIAO)

- **Principle 1 – Caution**: Detect existence; sudoers exact argv; refuse home/root.  
- **Principle 2 – Intentional**: Two names; mv dest specialized docs folders so genesis overlay cannot own dest law, postmortems, filled audits, live grants, or housekeeping summaries.  
- **Principle 5 – Output SSOT**: `out_*`.  
- **Principle 12 – Backup**: Prefer sibling global backup of dest.  
- **Principle 16 – Interactive**: Guided names; no hang under JSON.

---

## Under command line for normal user only

When the ship unit detects Termux, Git Bash, Windows cmd, or the same class:

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same `plan` / `apply`; dest backup is the local dest-docs snapshot | Call `sudo folder-backup`; wrap `apt`; write `/etc` |
| RAM-first still applies; missing `/dev/shm` uses `${PROJECTS_ROOT}` | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** dest hop stays user-local on Termux.

Detect (typical): Termux — `PREFIX` contains `com.termux`; `TERMUX_VERSION` set; `/data/data/com.termux/files/usr` exists. Git Bash — `MSYSTEM` is `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`. Windows cmd — `OS` is `Windows_NT` or `COMSPEC` names `cmd.exe` (after excluding Git Bash, Cygwin, WSL).

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Fail closed on missing names, refused paths, grant-too-narrow.  
- **Intentional:** Recipe is dest-docs replace + restore dest specialized docs folders.  
- **Anti-fragile:** Restore those dest folders if copy fails; local snapshot only when binary missing.  
- **Over-protect:** Never delete dest project root; never emit sudoers.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Default dest to `$PWD` instead of **project-name**.  
2. Overlay dest `docs/requirements/` with the template registry.  
2a. Overlay dest `docs/incidents/` (bodies or dest README) with the template genesis incidents placeholder when dest had that directory.  
2b. Overlay dest `docs/checklists/`, `docs/whitelists/`, `docs/housekeeping/`, or dest `docs/reviews/` with the kit placeholder when dest had that directory.  
3. Skip the folder-backup gate when the global binary exists.  
4. Treat verb-only sudoers `backup` as authorizing `backup <folder>`.  
5. Treat a missing `/etc/{{username}}/folder-backup` as verb-only / grant-too-narrow when sibling dest is `/etc/sudoers.d/folder-backup-<user>`.  
6. Skip TTY `sudo folder-backup backup <dest>` after a grep miss at a guessed path.  
7. Dual-write RAM and hard-disk for the same basename.  
8. Copy dest `AGENTS.md` / ship unit from the template.  
9. Invent OS-tool sudo or this product’s `print-sudoers`.  
10. Archive the template and call that the apply dest backup.  
11. List a specialized product as a template because `docs/README.md` still says Template name / genesis-template.  
12. Omit **0. Back to main menu** on TTY template or project pickers, print a second all-nines Back row, or treat that choice as Exit of the process.

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention / flags |
| `docs/requirements/requirement-shell-cli-default-interaction.md` | Main menu |
| `docs/requirements/requirement-shell-sudo-command.md` | `util_sudo` |
| `docs/requirements/requirement-shell-termux-ish.md` | Termux: local snapshot, no `sudo` |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv split |
| `./src/tmpl-to-prj` | Ship unit |

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-TMPL-TO-PRJ-01..23** | `tests/test_domain_tmpl_to_prj.sh` | have (14–16: sibling dest / unproven; 17–19: unspecialized kit filter + picker back; **20–21**: dest incidents preserved / template placeholder only when dest had none; **22–23**: dest checklists / whitelists / housekeeping / docs/reviews preserved / kit placeholder only when dest had none) |
| **TP-TX-06** | `tests/test_termux.sh` | have (Termux apply: no `sudo`; local snapshot) |

**Last Updated**: 2026-09-10 (1.6.0 specialized dest docs folders)  
**Owner**: project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **CIAO** (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
