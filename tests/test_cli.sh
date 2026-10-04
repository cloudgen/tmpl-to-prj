# =============================================================================
# tests/test_cli.sh — CLI surface (no public network; channel miss uses 127.0.0.1)
# =============================================================================
# Primary REQs: requirement-shell-cli-interface, requirement-shell-cli-zero-arguments,
# requirement-shell-output-requirements, requirement-shell-cli-storage
# TP family: TP-CLI-*
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface (TP-CLI)"

    require_cmd sh
    require_cmd grep

    # TP-CLI-01 syntax
    sh -n "${SCRIPT}"
    assert_eq "TP-CLI-01 sh -n ship unit" 0 "$?"

    # TP-CLI-02 version human
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version mentions app" "$_out" "${APP_NAME}"
    assert_contains "TP-CLI-02 version mentions VERSION" "$_out" "${PRODUCT_VERSION}"

    # TP-CLI-03 version json
    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 version --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 type version" "$_out" '"type":"version"'
    assert_contains "TP-CLI-03 app field" "$_out" "\"app\":\"${APP_NAME}\""
    assert_contains "TP-CLI-03 version field" "$_out" "\"version\":\"${PRODUCT_VERSION}\""

    # TP-CLI-04 help lists local lifecycle; not online; not trimmed parent domain
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 help install" "$_out" "install"
    assert_contains "TP-CLI-04 help uninstall" "$_out" "uninstall"
    assert_contains "TP-CLI-04 help where-is-me" "$_out" "where-is-me"
    assert_contains "TP-CLI-04 help plan" "$_out" "plan"
    assert_contains "TP-CLI-04 help apply" "$_out" "apply"
    assert_contains "TP-CLI-04 help --json" "$_out" "--json"
    assert_contains "TP-CLI-04 help self-install" "$_out" "self-install"
    assert_contains "TP-CLI-04 help self-update" "$_out" "self-update"
    assert_contains "TP-CLI-04 help self-uninstall" "$_out" "self-uninstall"
    assert_contains "TP-CLI-04 help version-check" "$_out" "version-check"
    assert_contains "TP-CLI-04 help SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_not_contains "TP-CLI-04 no backup verb" "$_out" "backup <"
    assert_not_contains "TP-CLI-04 no restore verb" "$_out" "restore <"
    assert_not_contains "TP-CLI-04 no print-sudoers" "$_out" "print-sudoers"
    assert_not_contains "TP-CLI-04 no CHECKSUM" "$_out" "CHECKSUM"

    # TP-CLI-05 help json
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    assert_eq "TP-CLI-05 help --json exit 0" 0 "$?"
    assert_contains "TP-CLI-05 help json success" "$_out" '"type":"success"'

    # TP-CLI-06 about json cache folders + persistence, no channel, no domain backup fields
    _home_orig="${HOME:-}"
    ci_isolated_env
    _out=$(HOME="${CI_HOME}" sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-06 type about" "$_out" '"type":"about"'
    assert_contains "TP-CLI-06 cache_used" "$_out" '"cache_used"'
    assert_contains "TP-CLI-06 cache_preferred" "$_out" '"cache_preferred"'
    assert_contains "TP-CLI-06 cache_fallback" "$_out" '"cache_fallback"'
    assert_contains "TP-CLI-06 cache_fallback_2" "$_out" '"cache_fallback_2"'
    assert_contains "TP-CLI-06 persistence_storage" "$_out" '"persistence_storage"'
    assert_contains "TP-CLI-06 effective_storage" "$_out" '"effective_storage"'
    _hum=$(HOME="${CI_HOME}" sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-06 human Cache folder used" "$_hum" "Cache folder used:"
    assert_contains "TP-CLI-06 human Cache folder preferred" "$_hum" "Cache folder (preferred):"
    assert_contains "TP-CLI-06 human Cache folder 1st fallback" "$_hum" "Cache folder (1st fallback):"
    assert_contains "TP-CLI-06 human Cache folder 2nd fallback" "$_hum" "Cache folder (2nd fallback):"
    assert_contains "TP-CLI-06 human Persistence storage" "$_hum" "Persistence storage:"
    assert_not_contains "TP-CLI-06 no Storage (effective) label" "$_hum" "Storage (effective)"
    assert_not_contains "TP-CLI-06 no Storage (fallback) label" "$_hum" "Storage (fallback)"
    assert_not_contains "TP-CLI-06 no backup_notation" "$_out" '"backup_notation"'
    assert_not_contains "TP-CLI-06 no deposit_dir" "$_out" '"deposit_dir"'
    assert_not_contains "TP-CLI-06 no restore_host_default" "$_out" '"restore_host_default"'
    assert_not_contains "TP-CLI-06 no CHECKSUM" "$_out" "CHECKSUM"
    assert_not_contains "TP-CLI-06 no SCRIPT_URL" "$_out" "SCRIPT_URL"
    ci_cleanup_env
    if [ -n "${_home_orig}" ]; then
        export HOME="${_home_orig}"
    fi

    # TP-CLI-07 non-interactive 0-argv copies ($0 is the script). Not help.
    # stdin is /dev/null so a TTY test run cannot open the menu.
    _home_orig="${HOME:-}"
    ci_isolated_env
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" </dev/null 2>&1)
    _ec=$?
    assert_eq "TP-CLI-07 empty argv exit 0" 0 "$_ec"
    assert_contains "TP-CLI-07 empty argv self-installs" "$_out" "no download"
    assert_contains "TP-CLI-07 empty argv placed" "$_out" "successfully installed"
    assert_not_contains "TP-CLI-07 empty argv is not help" "$_out" "Usage:"
    assert_file_exists "TP-CLI-07 placed binary" "${CI_USER_BIN}/${APP_NAME}"
    _mode=$(stat -c '%a' "${CI_USER_BIN}/${APP_NAME}" 2>/dev/null || stat -f '%OLp' "${CI_USER_BIN}/${APP_NAME}")
    case "${_mode}" in
        700|0700) t_pass "TP-CLI-07 self-install mode 0700" ;;
        *) t_fail "TP-CLI-07 self-install mode 0700 (got ${_mode})" ;;
    esac
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" </dev/null 2>&1)
    _ec=$?
    assert_eq "TP-CLI-07 second empty argv exit 0" 0 "$_ec"
    assert_contains "TP-CLI-07 already installed" "$_out" "already installed"
    assert_not_contains "TP-CLI-07 second run is not help" "$_out" "Usage:"
    if [ -n "${_home_orig}" ]; then
        export HOME="${_home_orig}"
    fi
    ci_cleanup_env

    # TP-CLI-31 stdin pipe ($0 is sh, 0 argv) downloads. Not help.
    # `sh "$SCRIPT"` does not reproduce curl | sh. The pipe does.
    _home_orig="${HOME:-}"
    ci_isolated_env
    _stage=$(mktemp -d "${CI_HOME}/channel.XXXXXX")
    cp "${SCRIPT}" "${_stage}/tmpl-to-prj"
    _url="file://${_stage}/tmpl-to-prj"
    _out=$(cat "${SCRIPT}" | HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        GLOBAL_BIN="${CI_GLOBAL_BIN}" SCRIPT_URL="${_url}" sh 2>&1)
    _ec=$?
    assert_eq "TP-CLI-31 pipe empty argv exit 0" 0 "$_ec"
    assert_contains "TP-CLI-31 pipe placed" "$_out" "successfully installed"
    assert_not_contains "TP-CLI-31 pipe is not help" "$_out" "Usage:"
    assert_file_exists "TP-CLI-31 placed binary" "${CI_USER_BIN}/${APP_NAME}"
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="${_url}" "${CI_USER_BIN}/${APP_NAME}" </dev/null 2>&1)
    _ec=$?
    assert_eq "TP-CLI-31 second pipe-installed argv exit 0" 0 "$_ec"
    assert_contains "TP-CLI-31 already installed" "$_out" "already installed"
    assert_not_contains "TP-CLI-31 second run is not help" "$_out" "Usage:"
    rm -f "${CI_USER_BIN}/${APP_NAME}"
    _err=$(cat "${SCRIPT}" | HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/tmpl-to-prj-missing" sh 2>&1)
    _ec=$?
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-31 unreachable pipe exit non-zero"
    else
        t_fail "TP-CLI-31 unreachable pipe exit non-zero (got 0)"
    fi
    assert_contains "TP-CLI-31 unreachable pipe loud" "$_err" "Download failed"
    assert_not_contains "TP-CLI-31 unreachable pipe is not help" "$_err" "Usage:"
    assert_file_missing "TP-CLI-31 unreachable leaves no binary" "${CI_USER_BIN}/${APP_NAME}"
    if [ -n "${_home_orig}" ]; then
        export HOME="${_home_orig}"
    fi
    ci_cleanup_env

    # TP-CLI-08 unknown command fail-closed
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 unknown exit 1" 1 "$_ec"
    assert_contains "TP-CLI-08 unknown error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 unknown --json exit 1" 1 "$_ec"
    assert_contains "TP-CLI-08 unknown --json type" "$_err" '"type":"out_error"'

    # TP-CLI-09 quiet suppresses version info
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-09 quiet version exit 0" 0 "$_ec"
    _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
    if [ -z "$_trim" ]; then
        t_pass "TP-CLI-09 quiet suppresses human version"
    else
        t_fail "TP-CLI-09 quiet expected empty stdout, got '$(_trunc "$_out")'"
    fi

    # TP-CLI-10 channel miss fails loud (does not pretend already-latest, does not write)
    _err=$(SCRIPT_URL="http://127.0.0.1:1/tmpl-to-prj-missing" sh "${SCRIPT}" self-update 2>&1 >/dev/null)
    assert_eq "TP-CLI-10 self-update unreachable exit 1" 1 "$?"
    assert_contains "TP-CLI-10 self-update fail loud" "$_err" "Failed to fetch latest version"

    _err=$(SCRIPT_URL="http://127.0.0.1:1/tmpl-to-prj-missing" sh "${SCRIPT}" version-check 2>&1 >/dev/null)
    assert_eq "TP-CLI-10 version-check unreachable exit 1" 1 "$?"
    assert_contains "TP-CLI-10 version-check fail loud" "$_err" "Failed to fetch remote version"

    # TP-CLI-11 set -u HOME unset still works for version
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-11 env -u HOME version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-11 env -u HOME version text" "$_out" "${PRODUCT_VERSION}"

    # TP-CLI-12 cache isolation under temp HOME (per login + process id)
    _home_orig="${HOME:-}"
    ci_isolated_env
    _login=$(id -un 2>/dev/null || echo "unknown")
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-12 isolated about has app in cache" "$_out" "${APP_NAME}"
    _pref=$(printf '%s' "$_out" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _pid="${_pref##*-}"
    case "${_pref}" in
        /dev/shm/cache/cache-"${APP_NAME}"-"${_login}"-[0-9]*)
            t_pass "TP-CLI-12 cache_preferred is shm login process leaf"
            ;;
        *) t_fail "TP-CLI-12 cache_preferred unexpected: '${_pref:-empty}'" ;;
    esac
    _fb=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_fallback 1st" "/tmp/cache/cache-${APP_NAME}-${_login}-${_pid}" "${_fb}"
    _fb2=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_fallback 2nd" "${CI_HOME}/.cache/cache-${APP_NAME}-${_pid}" "${_fb2}"
    _used=$(printf '%s' "$_out" | sed -n 's/.*"cache_used":"\([^"]*\)".*/\1/p' | head -n1)
    _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 cache_used matches effective" "${_eff}" "${_used}"
    if [ -n "$_eff" ] && [ -d "$_eff" ]; then
        t_pass "TP-CLI-12 effective cache directory exists"
    else
        t_fail "TP-CLI-12 effective cache missing: '${_eff:-empty}'"
    fi
    case "${_eff}" in
        /dev/shm/"${APP_NAME}"|/dev/shm/"${APP_NAME}"-*)
            t_fail "TP-CLI-12 effective cache must not be ram-drive project shape: '${_eff}'"
            ;;
        *) t_pass "TP-CLI-12 effective cache is not a ram-drive project shape" ;;
    esac
    _err=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" T2P_CACHE_SKIP=preferred \
        sh "${SCRIPT}" about 2>&1 >/dev/null)
    assert_not_contains "TP-CLI-12 silent cache fallback" "${_err}" "fallback"
    assert_not_contains "TP-CLI-12 silent cache fallback error" "${_err}" "Cannot create cache"
    _skip=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" T2P_CACHE_SKIP=preferred \
        sh "${SCRIPT}" --json about 2>/dev/null)
    _skip_eff=$(printf '%s' "$_skip" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    _skip_fb=$(printf '%s' "$_skip" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 skipped preferred uses 1st fallback" "${_skip_fb}" "${_skip_eff}"
    _gb=$(HOME="${CI_HOME}" T2P_CACHE_HOST=gitbash sh "${SCRIPT}" --json about 2>/dev/null)
    _gb_pref=$(printf '%s' "$_gb" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _gb_pid="${_gb_pref##*-}"
    assert_eq "TP-CLI-12 gitbash preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_gb_pid}" "${_gb_pref}"
    _gb_fb=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 gitbash 1st fallback" "${CI_HOME}/AppData/Local/Temp/cache-${APP_NAME}-${_gb_pid}" "${_gb_fb}"
    assert_contains "TP-CLI-12 gitbash json has cache_fallback_2" "${_gb}" '"cache_fallback_2":""'
    _gb_fb2=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 gitbash no 2nd fallback" "" "${_gb_fb2}"
    _mac=$(HOME="${CI_HOME}" T2P_CACHE_HOST=mac sh "${SCRIPT}" --json about 2>/dev/null)
    _mac_pref=$(printf '%s' "$_mac" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _mac_pid="${_mac_pref##*-}"
    assert_eq "TP-CLI-12 mac preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_mac_pid}" "${_mac_pref}"
    _mac_fb=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 mac 1st fallback" "${CI_HOME}/Library/Caches/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb}"
    _mac_fb2=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 mac 2nd fallback" "${CI_HOME}/cache/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb2}"
    _mode=$(stat -c %a "${_eff}" 2>/dev/null || echo "")
    assert_eq "TP-CLI-12 effective cache mode 0700" "700" "${_mode}"
    _hum_l=$(HOME="${CI_HOME}" sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-12 linux about used" "${_hum_l}" "Cache folder used:"
    assert_contains "TP-CLI-12 linux about preferred path" "${_hum_l}" "/dev/shm/cache/cache-${APP_NAME}-${_login}-"
    assert_contains "TP-CLI-12 linux about 2nd path" "${_hum_l}" "/.cache/cache-${APP_NAME}-"
    _hum_gb=$(HOME="${CI_HOME}" T2P_CACHE_HOST=gitbash sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-12 gitbash about 1st" "${_hum_gb}" "AppData/Local/Temp/cache-${APP_NAME}-"
    assert_not_contains "TP-CLI-12 gitbash about omits 2nd" "${_hum_gb}" "Cache folder (2nd fallback)"
    _hum_mac=$(HOME="${CI_HOME}" T2P_CACHE_HOST=mac sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-12 mac about 1st" "${_hum_mac}" "Library/Caches/cache-${APP_NAME}-"
    assert_contains "TP-CLI-12 mac about 2nd path" "${_hum_mac}" "Cache folder (2nd fallback): ${CI_HOME}/cache/cache-${APP_NAME}-"
    _persist=$(printf '%s' "$_out" | sed -n 's/.*"persistence_storage":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-12 persistence_storage path" "${CI_HOME}/.local/${APP_NAME}" "$_persist"
    if [ -n "$_persist" ] && [ -d "$_persist" ]; then
        t_pass "TP-CLI-12 persistence storage directory exists"
    else
        t_fail "TP-CLI-12 persistence storage missing: '${_persist:-empty}'"
    fi
    case "${_persist}" in
        */.local/bin|*/.local/bin/) t_fail "TP-CLI-12 persistence must not be USER_BIN: '${_persist}'" ;;
        *) t_pass "TP-CLI-12 persistence is not the install bin directory" ;;
    esac
    ci_cleanup_env
    if [ -n "${_home_orig}" ]; then
        export HOME="${_home_orig}"
    fi

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
    assert_contains "TP-CLI-17 self-management row" "$_plain" "8. self-management: this CLI install, version, update, uninstall"
    assert_not_contains "TP-CLI-17 no 81 on front" "$_plain" "81."
    assert_not_contains "TP-CLI-17 no CSI in stripped header" "$_plain" "${_esc}"

    # TP-CLI-26 self-management board 82-87 and 0 Back; 81 hidden; 0 returns to front
    _out=$(printf '8\n0\n9\n' | TTY=1 sh "${SCRIPT}" menu 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-26 menu 8 then 0 exit 0" 0 "$_ec"
    _plain=$(printf '%s' "$_out" | sed "s/${_esc}\\[[0-9;]*m//g")
    assert_contains "TP-CLI-26 row 82" "$_plain" "82. version: show current version"
    assert_contains "TP-CLI-26 row 87" "$_plain" "87. self-install:"
    assert_contains "TP-CLI-26 back" "$_plain" "0. Back"
    assert_not_contains "TP-CLI-26 no 81" "$_plain" "81."
    assert_contains "TP-CLI-26 returned to front" "$_plain" "1. plan: Show template and project roots (no writes)"

    # TP-CLI-27 finished leaf redisplays the front board
    _out=$(printf '82\n9\n' | TTY=1 sh "${SCRIPT}" menu 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-27 version leaf exit 0" 0 "$_ec"
    _plain=$(printf '%s' "$_out" | sed "s/${_esc}\\[[0-9;]*m//g")
    assert_contains "TP-CLI-27 version text" "$_plain" "${APP_VERSION}"
    assert_contains "TP-CLI-27 front after leaf" "$_plain" "numbered list of live commands"

    # TP-CLI-28 bad pick reprints this layer and does not die
    _out=$(printf 'x\n9\n' | TTY=1 sh "${SCRIPT}" menu 2>&1)
    _ec=$?
    assert_eq "TP-CLI-28 bad pick exit 0" 0 "$_ec"
    assert_contains "TP-CLI-28 names the pick" "$_out" "Not a menu choice 'x'"
    _plain=$(printf '%s' "$_out" | sed "s/${_esc}\\[[0-9;]*m//g")
    assert_contains "TP-CLI-28 reprints front" "$_plain" "8. self-management:"

    # TP-CLI-29 self-install copies $0 (no download) at mode 0700; install stays 0755
    ci_isolated_env
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" self-install --force 2>&1)
    _ec=$?
    assert_eq "TP-CLI-29 self-install exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 no download" "$_out" "no download"
    assert_file_exists "TP-CLI-29 placed binary" "${CI_USER_BIN}/${APP_NAME}"
    _mode=$(stat -c '%a' "${CI_USER_BIN}/${APP_NAME}" 2>/dev/null || stat -f '%OLp' "${CI_USER_BIN}/${APP_NAME}")
    case "${_mode}" in
        700|0700) t_pass "TP-CLI-29 self-install mode 0700" ;;
        *) t_fail "TP-CLI-29 self-install mode 0700 (got ${_mode})" ;;
    esac
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" install --force 2>&1)
    assert_eq "TP-CLI-29 local install still exit 0" 0 "$?"
    _mode=$(stat -c '%a' "${CI_USER_BIN}/${APP_NAME}" 2>/dev/null || stat -f '%OLp' "${CI_USER_BIN}/${APP_NAME}")
    case "${_mode}" in
        755|0755) t_pass "TP-CLI-29 install heals mode 0755" ;;
        *) t_fail "TP-CLI-29 install heals mode 0755 (got ${_mode})" ;;
    esac

    # TP-CLI-30 downgrade refused; newer file:// channel replaces; JSON uninstall needs --force
    _old=$(mktemp "${CI_HOME}/old.XXXXXX")
    _new=$(mktemp "${CI_HOME}/new.XXXXXX")
    printf '#!/bin/sh\nVERSION="0.0.1"\n' >"${_old}"
    printf '#!/bin/sh\nVERSION="9.9.9"\n' >"${_new}"
    _err=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="file://${_old}" sh "${SCRIPT}" self-update 2>&1 >/dev/null)
    assert_eq "TP-CLI-30 downgrade exit 1" 1 "$?"
    assert_contains "TP-CLI-30 downgrade text" "$_err" "Refusing silent downgrade"
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        SCRIPT_URL="file://${_new}" sh "${SCRIPT}" self-update 2>&1)
    assert_eq "TP-CLI-30 update exit 0" 0 "$?"
    assert_contains "TP-CLI-30 updated" "$_out" "9.9.9"
    _got=$(grep '^VERSION="' "${CI_USER_BIN}/${APP_NAME}" | cut -d'"' -f2)
    assert_eq "TP-CLI-30 installed version" "9.9.9" "${_got}"
    _err=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${CI_GLOBAL_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>&1 >/dev/null)
    assert_eq "TP-CLI-30 json uninstall exit 1" 1 "$?"
    assert_contains "TP-CLI-30 confirm required" "$_err" "confirm_required"
    assert_file_exists "TP-CLI-30 binary remains" "${CI_USER_BIN}/${APP_NAME}"
    ci_cleanup_env
}
