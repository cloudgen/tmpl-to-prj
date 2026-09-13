# CLI routed-verb table — tmpl-to-prj

**Last updated:** 2026-09-13  
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
| plan | `t2p_plan` | Type 0 | 2026-09-02 | `plan: Show template and project roots (no writes)` | operational | live |
| apply | `t2p_apply` | Type 0 | 2026-09-13 | `apply: Copy harness docs from the template into the project` | operational | live |
| menu | `app_default` | Type 0 | 2026-09-02 | `menu: Numbered list of plan and apply` | operational | live |
| main | `app_default` | Type 0 | 2026-09-02 | `main: Alias of menu` | operational | live |
| list-templates | `t2p_cmd_list_templates` | Type 0 | 2026-09-02 | `list-templates: Numbered genesis-template (or subclass) kits` | test-purpose | live |
| list-projects | `t2p_cmd_list_projects` | Type 0 | 2026-09-02 | `list-projects: Numbered dest candidates (current folder and ~/prjs)` | test-purpose | live |

Main-menu eligible rows: **plan**, **apply**. Exit **9**. After those, TTY pickers list **unspecialized** kits then projects; **0** returns to this menu (all-nines accepted when free, not printed). Test-purpose verbs stay off the main menu.
