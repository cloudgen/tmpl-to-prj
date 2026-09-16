# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface + domain help rows (no public network)
# =============================================================================
# Covers: syntax, version, help (Type 0 + plan/apply), about, unknown command,
# quiet/json, SCRIPT_URL listed, CHECKSUM absent, domain verbs, trimmed parent verbs,
# TTY menu header, self-uninstall --json fail-closed, Type O empty-argv failure.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- syntax ---
    sh -n "${SCRIPT}"
    _syn=$?
    assert_eq "sh -n tmpl-to-prj (syntax)" 0 "$_syn"

    # --- companion digest matches ship unit ---
    if [ -f "${REPO_ROOT}/tmpl-to-prj.sha256" ]; then
        _expected=$(tr -d ' \n\r\t' < "${REPO_ROOT}/tmpl-to-prj.sha256")
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "tmpl-to-prj.sha256 matches ./tmpl-to-prj" "$_expected" "$_actual"
    else
        t_fail "tmpl-to-prj.sha256 missing at repo root"
    fi

    # --- version (human) ---
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "version exit 0" 0 "$_ec"
    assert_contains "version human mentions version" "$_out" "${PRODUCT_VERSION}"
    assert_contains "version human mentions app" "$_out" "tmpl-to-prj"

    # --- version (json) ---
    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "version --json exit 0" 0 "$_ec"
    assert_contains "version --json type" "$_out" '"type":"version"'
    assert_contains "version --json app" "$_out" '"app":"tmpl-to-prj"'
    assert_contains "version --json version field" "$_out" "\"version\":\"${PRODUCT_VERSION}\""
    # app_version is the live dispatcher target (M1); no dual inline path
    assert_contains "version human via app_version" "$(sh "${SCRIPT}" version 2>/dev/null)" "${PRODUCT_VERSION}"

    # --- help (human): commands present, CHECKSUM absent ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "help exit 0" 0 "$_ec"
    assert_contains "help lists install" "$_out" "install"
    assert_contains "help lists version-check" "$_out" "version-check"
    assert_contains "help lists self-update" "$_out" "self-update"
    assert_contains "help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "help lists about" "$_out" "about"
    assert_contains "help lists --json" "$_out" "--json"
    assert_contains "help lists --force" "$_out" "--force"
    assert_contains "help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "help lists REPO_NAME" "$_out" "REPO_NAME"
    assert_contains "help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_contains "TP-CLI-04 help lists plan" "$_out" "plan <template-name>"
    assert_contains "TP-CLI-04 help lists apply" "$_out" "apply <template-name>"
    assert_contains "TP-CLI-04 help lists menu" "$_out" "menu"
    assert_contains "TP-CLI-04 help lists list-templates" "$_out" "list-templates"
    assert_contains "TP-CLI-04 help lists list-projects" "$_out" "list-projects"
    assert_contains "TP-CLI-04 help lists T2P_RAM_ROOT" "$_out" "T2P_RAM_ROOT"
    assert_not_contains "help must not list CHECKSUM" "$_out" "CHECKSUM"
    assert_not_contains "TP-CLI-04 no print-sudoers" "$_out" "print-sudoers"
    assert_not_contains "TP-CLI-04 no where-is-me" "$_out" "where-is-me"
    assert_not_contains "TP-CLI-04 no backup verb" "$_out" "backup <"
    assert_not_contains "TP-CLI-04 no restore verb" "$_out" "restore <"

    # --- help (json): short object, not full prose ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "help --json exit 0" 0 "$_ec"
    assert_contains "help --json type success" "$_out" '"type":"success"'
    assert_contains "help --json command help" "$_out" '"command":"help"'

    # --- about (json): no CHECKSUM field; storage resolve fields ---
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "about --json exit 0" 0 "$_ec"
    assert_contains "about --json type" "$_out" '"type":"about"'
    assert_contains "about --json app" "$_out" '"app":"tmpl-to-prj"'
    assert_not_contains "about --json must not include CHECKSUM" "$_out" "CHECKSUM"
    assert_contains "about --json effective_storage" "$_out" '"effective_storage"'
    assert_contains "about --json storage_dir" "$_out" '"storage_dir"'
    assert_contains "about --json storage includes app name" "$_out" "${APP_NAME:-tmpl-to-prj}"
    assert_contains "about --json ram_root" "$_out" '"ram_root"'
    assert_contains "about --json projects_root" "$_out" '"projects_root"'
    assert_contains "about --json domain" "$_out" '"domain":"tmpl-to-prj"'

    # --- storage resolve isolation (EFFECTIVE_STORAGE_DIR via util_resolve_storage) ---
    ci_isolated_env 2>/dev/null || true
    if [ -n "${CI_HOME:-}" ]; then
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN:-${CI_HOME}/.local/bin}" GLOBAL_BIN="${CI_GLOBAL_BIN:-${CI_HOME}/global-bin}" \
            sh "${SCRIPT}" --json about 2>/dev/null)
        assert_contains "isolated about effective_storage has app" "$_out" "${APP_NAME:-tmpl-to-prj}"
        case "$_out" in
            *'"effective_storage":"'*"${APP_NAME:-tmpl-to-prj}"*) t_pass "effective_storage path contains ${APP_NAME:-tmpl-to-prj}" ;;
            *) t_fail "effective_storage missing app isolation in: $_out" ;;
        esac
        assert_contains "storage_dir field present under isolation" "$_out" '"storage_dir"'
        _custom="${CI_HOME}/custom-storage-root"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" STORAGE_DIR="${_custom}" \
            sh "${SCRIPT}" --json about 2>/dev/null)
        # STORAGE_DIR env appears on storage_dir config field (tier-3 / override field)
        assert_contains "storage_dir honors STORAGE_DIR env" "$_out" "custom-storage-root"
        _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
        if [ -n "$_eff" ] && [ -d "$_eff" ]; then
            t_pass "effective_storage directory exists after resolve"
        else
            t_fail "effective_storage missing or not a directory: '${_eff:-empty}'"
        fi
        _who=$(id -un 2>/dev/null || echo "unknown")
        case "$_out" in
            *'"effective_storage":"'*"${_who}"*|*'"effective_storage":"'*"unknown"*) \
                t_pass "effective_storage includes user segment" ;;
            *) t_fail "effective_storage missing user segment for '${_who}': $_out" ;;
        esac
        ci_cleanup_env 2>/dev/null || true
    else
        # Fallback without full CI isolation helpers
        _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
        _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
        if [ -n "$_eff" ] && [ -d "$_eff" ]; then
            t_pass "effective_storage directory exists after resolve"
        else
            t_fail "effective_storage missing or not a directory: '${_eff:-empty}'"
        fi
    fi

    # --- unknown command ---
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "unknown command exit 1" 1 "$_ec"
    assert_contains "unknown command error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "unknown command --json exit 1" 1 "$_ec"
    assert_contains "unknown command --json type error" "$_err" '"type":"out_error"'

    # --- quiet: version should not print info banners ---
    # Contract: --quiet suppresses non-error chatter; version uses out_info → suppressed.
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "version --quiet exit 0" 0 "$_ec"
    # out_info is suppressed under quiet → empty or near-empty stdout is correct
    if [ -z "$_out" ]; then
        t_pass "version --quiet suppresses human info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "version --quiet suppresses human info"
        else
            t_fail "version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi

    # --- HOME unset under set -u (INC-20260713-001) ---
    # Must not abort with "HOME: parameter not set"; defaults HOME then USER_BIN.
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "env -u HOME version exit 0" 0 "$_ec"
    assert_contains "env -u HOME version still reports version" "$_out" "${PRODUCT_VERSION}"

    # --- zero-arg auto-install propagates failure (not exit 0 on download fail) ---
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/tmpl-to-prj-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "zero-arg failed install exits non-zero"
    else
        t_fail "zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "zero-arg failed install left no binary" "${CI_USER_BIN}/tmpl-to-prj"
    ci_cleanup_env

    # --- self-uninstall --json without force when binary present (isolated) ---
    # Fail-closed confirm_required (INC-20260713-002 contract).
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    # Place a stub install so uninstall path runs without network
    cp "${SCRIPT}" "${CI_USER_BIN}/tmpl-to-prj"
    chmod +x "${CI_USER_BIN}/tmpl-to-prj"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "self-uninstall --json without --force exit 1" 1 "$_ec"
    assert_contains "self-uninstall --json confirm_required code" "$_err" '"code":"confirm_required"'
    assert_contains "self-uninstall --json out_error type" "$_err" '"type":"out_error"'
    assert_not_contains "self-uninstall --json must not fake success cancel" "$_out$_err" "cancelled by user"
    assert_file_exists "binary remains without --force" "${CI_USER_BIN}/tmpl-to-prj"
    ci_cleanup_env

    # --- TP-JSON-RAW-01 / TP-CLI-12: out_json @key inserts raw nested JSON ---
    ci_isolated_env
    ci_source_ship_unit
    JSON=1
    _out=$(out_json "success" "" "count" "2" "@items" '["a","b"]')
    _ec=$?
    assert_eq "TP-JSON-RAW-01 out_json @key exit 0" 0 "$_ec"
    assert_contains "TP-JSON-RAW-01 type success" "$_out" '"type":"success"'
    assert_contains "TP-JSON-RAW-01 string count stays quoted" "$_out" '"count":"2"'
    assert_contains "TP-JSON-RAW-01 raw nested array unquoted" "$_out" '"items":["a","b"]'
    assert_not_contains "TP-JSON-RAW-01 must not stringify the array" "$_out" '"items":"[\"a\",\"b\"]"'
    _out=$(out_json "success" "" "@meta" '{"n":1}')
    assert_contains "TP-JSON-RAW-01 raw nested object unquoted" "$_out" '"meta":{"n":1}'
    JSON=0
    _silent=$(out_json "success" "" "@items" '["x"]')
    if [ -z "$_silent" ]; then
        t_pass "TP-JSON-RAW-01 out_json no-ops when JSON=0"
    else
        t_fail "TP-JSON-RAW-01 expected empty when JSON=0, got '$(_trunc "$_silent")'"
    fi
    ci_cleanup_env

    # TP-CLI-13 trimmed parent domain / sudoers verbs fail closed
    for _verb in backup restore print-sudoers print-sudoers-install-script remove-project-sudoers setup; do
        _err=$(sh "${SCRIPT}" "${_verb}" 2>&1 >/dev/null)
        _ec=$?
        assert_eq "TP-CLI-13 ${_verb} exit 1" 1 "$_ec"
        assert_contains "TP-CLI-13 ${_verb} unknown" "$_err" "Unknown command"
    done

    # TP-CLI-17 main-menu header is APP_NAME(VERSION); TTY bold name / italic version
    _esc=$(printf '\033')
    _out=$(printf '9\n' | TTY=1 sh "${SCRIPT}" menu 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-17 TTY menu exit 0" 0 "$_ec"
    _plain=$(printf '%s' "$_out" | sed "s/${_esc}\\[[0-9;]*m//g")
    assert_contains "TP-CLI-17 header token APP_NAME(APP_VERSION)" "$_plain" "${APP_NAME}(${APP_VERSION})"
    assert_contains "TP-CLI-17 board title" "$_plain" "numbered list of live commands"
    assert_contains "TP-CLI-17 bold SGR 1" "$_out" "${_esc}[1m"
    assert_contains "TP-CLI-17 italic SGR 3" "$_out" "${_esc}[3m"
    assert_contains "TP-CLI-17 plan row" "$_plain" "1. plan: Show template and project roots (no writes)"
    assert_contains "TP-CLI-17 apply row" "$_plain" "2. apply: Copy harness docs from the template into the project"
    assert_contains "TP-CLI-17 Exit 9" "$_plain" "9. Exit"
    assert_not_contains "TP-CLI-17 no CSI in stripped header" "$_plain" "${_esc}"

}
