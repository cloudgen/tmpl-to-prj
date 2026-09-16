# Tests — tmpl-to-prj

## Run

```sh
./tests/run.sh
# or
sh tests/run.sh
```

Exit **0** when all assertions pass; **1** on failure; **2** if ship unit missing.

## Layout

| File | Focus | TP families |
|------|--------|-------------|
| `run.sh` | Entrypoint | — |
| `helpers.sh` | Asserts + isolated HOME + local HTTP channel | — |
| `test_cli.sh` | CLI surface, Type O empty argv, online verbs, trimmed-verb reject, TTY menu header | **TP-CLI-*** |
| `test_install_lifecycle.sh` | install / version-check / self-update / self-uninstall / checksum (local channel) | **TP-LC-*** / **TP-CSUM** |
| `test_domain_tmpl_to_prj.sh` | RAM-first resolve, plan/apply overlay, dest specialized docs preserve, folder-backup gate | **TP-TMPL-TO-PRJ-*** |
| `test_termux.sh` | Termux detect, empty `pkg` table, skip `sudo` | **TP-TX-*** |

## Isolation

- Temp `HOME` + `USER_BIN` + redirected `GLOBAL_BIN` for install tests  
- Local HTTP channel for online install (no public network)  
- **No** write to `/etc` or `/var/backup`

## Ship unit under test

`src/tmpl-to-prj` (published copy `./tmpl-to-prj`)

## Maps

Product TP map: `reviews/test-plan.md`  
RTM: `reviews/requirement-test-matrix.md`
