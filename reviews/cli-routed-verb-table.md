# CLI routed-verb table — tmpl-to-prj

**Last updated:** 2026-10-04  
**Ship unit:** `src/tmpl-to-prj`

Human-readable column is `{{short-descript}}: {{explain}}` (short description = routed-verb).

| Verb | Handler | Privilege | Last modified | Human-readable | Purpose class | Live? |
|------|---------|-----------|---------------|----------------|---------------|-------|
| install | `inst_local_install` | Type 0 | 2026-09-02 | `install: Place the CLI in your bin directory` | operational | live |
| uninstall | `inst_local_uninstall` | Type 0 | 2026-09-02 | `uninstall: Remove the managed binary` | operational | live |
| where-is-me | `app_where_is_me` | Type 0 | 2026-09-02 | `where-is-me: Show running and install paths` | operational | live |
| version | `app_version` | Type 0 | 2026-09-02 | `version: Show local version` | operational | live |
| about | `app_about` | Type 0 | 2026-09-02 | `about: Show diagnostics` | operational | live |
| help | `app_help` | Type 0 | 2026-09-02 | `help: Show usage` | operational | live |
| self-install | `inst_self_install` | Type 0 | 2026-10-04 | `self-install: place this CLI only (copy when $0 is a script; download when piped)` | operational | live |
| version-check | `ver_check` | Type 0 | 2026-10-04 | `version-check: compare local vs remote version` | operational | live |
| self-update | `inst_self_update` | Type 0 | 2026-10-04 | `self-update: update tmpl-to-prj to a newer remote version` | operational | live |
| self-uninstall | `inst_self_uninstall` | Type 0 | 2026-10-04 | `self-uninstall: remove tmpl-to-prj` | operational | live |
| plan | `t2p_plan` | Type 0 | 2026-09-02 | `plan: Show template and project roots (no writes)` | operational | live |
| apply | `t2p_apply` | Type 0 | 2026-09-10 | `apply: Copy harness docs from the template into the project (keep dest specialized docs folders)` | operational | live |
| menu | `app_default` | Type 0 | 2026-10-04 | `menu: Numbered list (1 plan, 2 apply, 8 self-management, 9 Exit)` | operational | live |
| main | `app_default` | Type 0 | 2026-09-02 | `main: Alias of menu` | operational | live |
| list-templates | `t2p_cmd_list_templates` | Type 0 | 2026-10-07 | `list-templates: Numbered kits under RAM, the current folder, and PROJECTS_ROOT (0 requirement-*.md)` | test-purpose | live |
| list-projects | `t2p_cmd_list_projects` | Type 0 | 2026-09-02 | `list-projects: Numbered dest candidates (current folder and ~/prjs)` | test-purpose | live |

Front board: **plan**, **apply**, **self-management** (8), Exit **9**. Under 8: **82** version, **83** about, **84** version-check, **85** self-update, **86** self-uninstall, **87** self-install, **0** Back. **81** install is hidden. After plan or apply, TTY pickers list **unspecialized** kits then projects; **0** returns to this menu (all-nines accepted when free, not printed). Test-purpose verbs stay off the menu. `install` stays a command and is not a front-board row.
