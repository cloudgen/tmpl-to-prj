# =============================================================================
# tests/test_domain_tmpl_to_prj.sh — harness-docs hop (TP-TMPL-TO-PRJ-*)
# =============================================================================
# Primary REQs: requirement-domain-tmpl-to-prj, requirement-shell-cli-interface
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

t2p_mk_kit() {
    _root="$1"
    mkdir -p "${_root}/docs/skills" "${_root}/docs/requirements"
    printf '# kit\n\n**Template name** | genesis-template\n' >"${_root}/docs/README.md"
    printf 'FROM-KIT\n' >"${_root}/docs/skills/from-kit.md"
    printf '# genesis empty\n' >"${_root}/docs/requirements/README.md"
}

t2p_mk_proj() {
    _root="$1"
    mkdir -p "${_root}/docs/skills" "${_root}/docs/requirements" "${_root}/src"
    printf 'PRODUCT-README-KEEP\n' >"${_root}/README.md"
    printf 'AGENTS-KEEP\n' >"${_root}/AGENTS.md"
    printf 'OLD-SKILL\n' >"${_root}/docs/skills/old.md"
    printf 'KEEP-ME\n' >"${_root}/docs/requirements/requirement-keep.md"
    printf 'SHIP-KEEP\n' >"${_root}/src/not-the-cli"
}

run_test_domain_tmpl_to_prj() {
    t_header "Domain tmpl-to-prj (TP-TMPL-TO-PRJ)"

    require_cmd sh
    require_cmd grep

    ci_isolated_env
    T2P_RAM_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/t2p-ram.XXXXXX")
    PROJECTS_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/t2p-prjs.XXXXXX")
    export T2P_RAM_ROOT PROJECTS_ROOT HOME="${CI_HOME}"

    # TP-TMPL-TO-PRJ-01 missing names
    _err=$(sh "${SCRIPT}" --json apply 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-TMPL-TO-PRJ-01 apply without names exit 1" 1 "$_ec"
    assert_contains "TP-TMPL-TO-PRJ-01 names required" "$_err" "template-name"

    # TP-TMPL-TO-PRJ-02 missing template
    _err=$(sh "${SCRIPT}" apply no-such-kit dest-x 2>&1 >/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-02 missing template exit 1" 1 "$?"
    assert_contains "TP-TMPL-TO-PRJ-02 not found" "$_err" "not found"

    t2p_mk_kit "${PROJECTS_ROOT}/kit-a"
    t2p_mk_proj "${PROJECTS_ROOT}/proj-a"

    # TP-TMPL-TO-PRJ-03 RAM wins over hard-disk
    t2p_mk_kit "${T2P_RAM_ROOT}/kit-a"
    printf 'RAM-HOST\n' >"${T2P_RAM_ROOT}/kit-a/docs/skills/from-kit.md"
    printf 'DISK-HOST\n' >"${PROJECTS_ROOT}/kit-a/docs/skills/from-kit.md"
    _out=$(sh "${SCRIPT}" --json plan kit-a proj-a 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-03 plan exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-03 ram-drive host" "$_out" '"template_host":"ram-drive"'
    assert_contains "TP-TMPL-TO-PRJ-03 ram root" "$_out" "${T2P_RAM_ROOT}/kit-a"

    # TP-TMPL-TO-PRJ-04 plan does not mutate dest
    _out=$(sh "${SCRIPT}" plan kit-a proj-a 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-04 plan exit 0" 0 "$?"
    assert_file_exists "TP-TMPL-TO-PRJ-04 dest old skill remains" "${PROJECTS_ROOT}/proj-a/docs/skills/old.md"
    assert_contains "TP-TMPL-TO-PRJ-04 keep req" "$(cat "${PROJECTS_ROOT}/proj-a/docs/requirements/requirement-keep.md")" "KEEP-ME"

    # TP-TMPL-TO-PRJ-05 apply overlay + preserve requirements + root README
    _out=$(sh "${SCRIPT}" apply --force kit-a proj-a 2>&1)
    _ec=$?
    assert_eq "TP-TMPL-TO-PRJ-05 apply exit 0" 0 "$_ec"
    assert_contains "TP-TMPL-TO-PRJ-05 dest req kept" "$(cat "${PROJECTS_ROOT}/proj-a/docs/requirements/requirement-keep.md")" "KEEP-ME"
    assert_contains "TP-TMPL-TO-PRJ-05 kit skill copied" "$(cat "${PROJECTS_ROOT}/proj-a/docs/skills/from-kit.md")" "RAM-HOST"
    assert_file_missing "TP-TMPL-TO-PRJ-05 old dest skill gone" "${PROJECTS_ROOT}/proj-a/docs/skills/old.md"
    assert_contains "TP-TMPL-TO-PRJ-05 root README kept" "$(cat "${PROJECTS_ROOT}/proj-a/README.md")" "PRODUCT-README-KEEP"
    assert_contains "TP-TMPL-TO-PRJ-05 AGENTS kept" "$(cat "${PROJECTS_ROOT}/proj-a/AGENTS.md")" "AGENTS-KEEP"
    assert_contains "TP-TMPL-TO-PRJ-05 ship kept" "$(cat "${PROJECTS_ROOT}/proj-a/src/not-the-cli")" "SHIP-KEEP"

    # TP-TMPL-TO-PRJ-06 template requirements README must not remain as dest law
    assert_file_missing "TP-TMPL-TO-PRJ-06 no genesis requirements README as dest law" "${PROJECTS_ROOT}/proj-a/docs/requirements/README.md"
    assert_file_exists "TP-TMPL-TO-PRJ-06 dest requirement file" "${PROJECTS_ROOT}/proj-a/docs/requirements/requirement-keep.md"

    # TP-TMPL-TO-PRJ-07 grant-too-narrow (observed verb-only)
    t2p_mk_proj "${PROJECTS_ROOT}/proj-b"
    _stub="${CI_HOME}/folder-backup-stub"
    printf '#!/bin/sh\nexit 0\n' >"${_stub}"
    chmod +x "${_stub}"
    printf 'user ALL=(root) NOPASSWD: /usr/local/bin/folder-backup backup\n' >"${CI_HOME}/narrow-sudoers"
    _err=$(T2P_FOLDER_BACKUP="${_stub}" T2P_SUDOERS_FILE="${CI_HOME}/narrow-sudoers" \
        sh "${SCRIPT}" apply --force kit-a proj-b 2>&1 >/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-07 narrow sudoers exit 1" 1 "$?"
    assert_contains "TP-TMPL-TO-PRJ-07 too narrow" "$_err" "verb-only"
    assert_file_exists "TP-TMPL-TO-PRJ-07 dest not overlaid" "${PROJECTS_ROOT}/proj-b/docs/skills/old.md"

    # TP-TMPL-TO-PRJ-14 backup * at T2P_SUDOERS_FILE → pass (INC-20260902-001)
    printf 'user ALL=(root) NOPASSWD: /usr/local/bin/folder-backup backup *\n' >"${CI_HOME}/star-sudoers"
    _out=$(T2P_FOLDER_BACKUP="${_stub}" T2P_SUDOERS_FILE="${CI_HOME}/star-sudoers" \
        sh "${SCRIPT}" --json plan kit-a proj-b 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-14 star file plan exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-14 gate pass" "$_out" '"folder_backup_gate":"pass"'

    # TP-TMPL-TO-PRJ-15 sibling dest /etc/sudoers.d/folder-backup-<user>
    _sdd="${CI_HOME}/sudoers.d"
    mkdir -p "${_sdd}"
    printf 'user ALL=(root) NOPASSWD: /usr/local/bin/folder-backup backup *\n' \
        >"${_sdd}/folder-backup-$(id -un)"
    _out=$(T2P_FOLDER_BACKUP="${_stub}" T2P_SUDOERS_D_DIR="${_sdd}" \
        sh "${SCRIPT}" --json plan kit-a proj-b 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-15 sudoers.d dest plan exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-15 gate pass" "$_out" '"folder_backup_gate":"pass"'

    # TP-TMPL-TO-PRJ-16 missing guessed path is unproven, not verb-only
    _empty_sd="${CI_HOME}/empty-sudoers.d"
    mkdir -p "${_empty_sd}"
    t2p_mk_proj "${PROJECTS_ROOT}/proj-u"
    _err=$(T2P_FOLDER_BACKUP="${_stub}" T2P_SUDOERS_D_DIR="${_empty_sd}" \
        sh "${SCRIPT}" apply --force kit-a proj-u 2>&1 >/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-16 unproven exit 1" 1 "$?"
    assert_contains "TP-TMPL-TO-PRJ-16 unproven text" "$_err" "not proven"
    assert_not_contains "TP-TMPL-TO-PRJ-16 not claiming is verb-only" "$_err" "sudoers is verb-only"
    assert_file_exists "TP-TMPL-TO-PRJ-16 dest not overlaid" "${PROJECTS_ROOT}/proj-u/docs/skills/old.md"

    # TP-TMPL-TO-PRJ-08 missing folder-backup → local snapshot + apply
    t2p_mk_proj "${PROJECTS_ROOT}/proj-c"
    _out=$(sh "${SCRIPT}" apply --force kit-a proj-c 2>&1)
    assert_eq "TP-TMPL-TO-PRJ-08 missing fb apply exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-08 local snapshot note" "$_out" "Local dest-docs snapshot"
    _snaps=$(find "${PROJECTS_ROOT}/proj-c" -maxdepth 1 -type d -name '.t2p-docs-backup-*' | wc -l)
    if [ "${_snaps}" -ge 1 ]; then
        t_pass "TP-TMPL-TO-PRJ-08 snapshot dir created"
    else
        t_fail "TP-TMPL-TO-PRJ-08 snapshot dir missing"
    fi

    # TP-TMPL-TO-PRJ-09 source equals dest
    _err=$(sh "${SCRIPT}" apply --force kit-a kit-a 2>&1 >/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-09 same folder exit 1" 1 "$?"
    assert_contains "TP-TMPL-TO-PRJ-09 same folder text" "$_err" "same folder"

    # TP-TMPL-TO-PRJ-10 non-interactive menu is help
    _out=$(sh "${SCRIPT}" menu 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-10 menu off-TTY exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-10 menu is help" "$_out" "Usage:"

    # TP-TMPL-TO-PRJ-11 help lists plan/apply apart from testers
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-TMPL-TO-PRJ-11 operational heading" "$_out" "Harness docs"
    assert_contains "TP-TMPL-TO-PRJ-11 test-purpose heading" "$_out" "Test-purpose"
    assert_contains "TP-TMPL-TO-PRJ-11 menu Exit hint" "$_out" "numbered menu"
    assert_contains "TP-TMPL-TO-PRJ-11 list-templates" "$_out" "list-templates"
    assert_contains "TP-TMPL-TO-PRJ-11 list-projects" "$_out" "list-projects"

    # TP-TMPL-TO-PRJ-12 numbered template inventory (no hang)
    _out=$(sh "${SCRIPT}" --json list-templates 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-12 list-templates exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-12 type" "$_out" '"type":"list-templates"'
    assert_contains "TP-TMPL-TO-PRJ-12 kit-a listed" "$_out" "kit-a"
    _human=$(sh "${SCRIPT}" list-templates 2>/dev/null)
    assert_contains "TP-TMPL-TO-PRJ-12 numbered row" "$_human" "1. kit-a:"
    assert_not_contains "TP-TMPL-TO-PRJ-12 hop dest is not a template" "$_out" "proj-a"

    # TP-TMPL-TO-PRJ-17 specialized product (README still says Template name) is not a kit
    printf '# product\n\n**Template name** | genesis-template\n**Project nature** | software-development\n' \
        >"${PROJECTS_ROOT}/proj-a/docs/README.md"
    mkdir -p "${PROJECTS_ROOT}/kit-inc/docs/incidents" "${PROJECTS_ROOT}/kit-tests/tests"
    t2p_mk_kit "${PROJECTS_ROOT}/kit-inc"
    t2p_mk_kit "${PROJECTS_ROOT}/kit-tests"
    printf '# INC\n' >"${PROJECTS_ROOT}/kit-inc/docs/incidents/INC-20260903-001.md"
    printf '#!/bin/sh\necho test\n' >"${PROJECTS_ROOT}/kit-tests/tests/test_foo.sh"
    _out=$(sh "${SCRIPT}" --json list-templates 2>/dev/null)
    assert_contains "TP-TMPL-TO-PRJ-17 kit-a still listed" "$_out" "kit-a"
    assert_not_contains "TP-TMPL-TO-PRJ-17 specialized README not a kit" "$_out" "proj-a"
    assert_not_contains "TP-TMPL-TO-PRJ-17 incident body not a kit" "$_out" "kit-inc"
    assert_not_contains "TP-TMPL-TO-PRJ-17 product tests not a kit" "$_out" "kit-tests"
    _err=$(sh "${SCRIPT}" apply --force proj-a kit-a 2>&1 >/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-17 specialized-as-template exit 1" 1 "$?"
    assert_contains "TP-TMPL-TO-PRJ-17 specialized-as-template text" "$_err" "0 requirement"

    # TP-TMPL-TO-PRJ-18 list-templates does not print Back (print-only)
    _human=$(sh "${SCRIPT}" list-templates 2>/dev/null)
    assert_not_contains "TP-TMPL-TO-PRJ-18 list-templates has no back row" "$_human" "Back to main menu"

    # TP-TMPL-TO-PRJ-19 TTY picker 0 returns to main menu (does not exit)
    _out=$(printf '2\n0\n9\n' | TTY=1 sh "${SCRIPT}" 2>&1)
    assert_eq "TP-TMPL-TO-PRJ-19 menu apply then 0 then Exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-19 template picker title" "$_out" "Choose a template"
    assert_contains "TP-TMPL-TO-PRJ-19 back row 0" "$_out" "0. Back to main menu"
    assert_contains "TP-TMPL-TO-PRJ-19 back info" "$_out" "Back to main menu"
    assert_contains "TP-TMPL-TO-PRJ-19 returned to main menu" "$_out" "numbered list of live commands"
    assert_not_contains "TP-TMPL-TO-PRJ-19 specialized not on template picker" "$_out" "proj-a:"
    assert_not_contains "TP-TMPL-TO-PRJ-19 no duplicate 9 back row" "$_out" "9. Back to main menu"

    # all-nines still accepted when free (not printed as a second Back row)
    _out=$(printf '2\n9\n9\n' | TTY=1 sh "${SCRIPT}" 2>&1)
    assert_eq "TP-TMPL-TO-PRJ-19 menu apply then 9-back then Exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-19 all-nines returns to main menu" "$_out" "numbered list of live commands"
    assert_not_contains "TP-TMPL-TO-PRJ-19 all-nines not printed" "$_out" "9. Back to main menu"

    # TP-TMPL-TO-PRJ-13 numbered project inventory: current folder + PROJECTS_ROOT
    _out=$(sh "${SCRIPT}" --json list-projects 2>/dev/null)
    assert_eq "TP-TMPL-TO-PRJ-13 list-projects exit 0" 0 "$?"
    assert_contains "TP-TMPL-TO-PRJ-13 type" "$_out" '"type":"list-projects"'
    assert_contains "TP-TMPL-TO-PRJ-13 proj-a listed" "$_out" "proj-a"
    _human=$(sh "${SCRIPT}" list-projects 2>/dev/null)
    assert_contains "TP-TMPL-TO-PRJ-13 current-folder row" "$_human" "current-folder"
    assert_contains "TP-TMPL-TO-PRJ-13 prjs child" "$_human" "proj-a"

    rm -rf "${T2P_RAM_ROOT}" "${PROJECTS_ROOT}"
    ci_cleanup_env
}
