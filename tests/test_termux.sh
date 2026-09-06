# =============================================================================
# tests/test_termux.sh — Termux target + command line for normal user only
# =============================================================================
# Primary REQs: requirement-shell-termux-ish, requirement-shell-sudo-command
# TP family: TP-TX-*
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

t2p_stub_bin() {
    _dir="$1"
    _name="$2"
    _log="$3"
    mkdir -p "${_dir}"
    printf '#!/bin/sh\nprintf "%%s\\n" "%s $*" >> "%s"\nexit 0\n' "${_name}" "${_log}" >"${_dir}/${_name}"
    chmod 0755 "${_dir}/${_name}"
}

run_test_termux() {
    t_header "Termux target (TP-TX)"

    require_cmd sh
    require_cmd grep
    require_cmd chmod

    ci_isolated_env
    _stub=$(mktemp -d "${TMPDIR:-/tmp}/t2p-tx.XXXXXX")
    _pkglog="${_stub}/pkg.log"
    _sudolog="${_stub}/sudo.log"
    t2p_stub_bin "${_stub}" pkg "${_pkglog}"
    t2p_stub_bin "${_stub}" sudo "${_sudolog}"
    : >"${_pkglog}"
    : >"${_sudolog}"

    T2P_RAM_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/t2p-tx-ram.XXXXXX")
    PROJECTS_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/t2p-tx-prjs.XXXXXX")
    export T2P_RAM_ROOT PROJECTS_ROOT HOME="${CI_HOME}"
    export PATH="${_stub}:${PATH}"

    t2p_mk_kit() {
        _root="$1"
        mkdir -p "${_root}/docs/skills" "${_root}/docs/requirements"
        printf '# kit\n' >"${_root}/docs/README.md"
        printf 'FROM-KIT\n' >"${_root}/docs/skills/from-kit.md"
        printf '# genesis empty\n' >"${_root}/docs/requirements/README.md"
    }
    t2p_mk_proj() {
        _root="$1"
        mkdir -p "${_root}/docs/requirements" "${_root}/src"
        printf 'KEEP\n' >"${_root}/README.md"
        printf 'KEEP-REQ\n' >"${_root}/docs/requirements/requirement-keep.md"
        printf 'SHIP\n' >"${_root}/src/x"
    }

    # TP-TX-01 not Termux-ish: stub pkg MUST NOT be invoked
    unset PREFIX TERMUX_VERSION MSYSTEM OS ComSpec COMSPEC WSL_DISTRO_NAME 2>/dev/null || true
    : >"${_pkglog}"
    sh "${SCRIPT}" version >/dev/null 2>&1
    if [ -s "${_pkglog}" ]; then
        t_fail "TP-TX-01 pkg not invoked off Termux (log=$(_trunc "$(cat "${_pkglog}")"))"
    else
        t_pass "TP-TX-01 pkg not invoked off Termux"
    fi

    # TP-TX-02 Termux mock: empty named list → stub pkg still not invoked on install
    PREFIX="/data/data/com.termux/files/usr"
    TERMUX_VERSION="0.118.0"
    export PREFIX TERMUX_VERSION
    : >"${_pkglog}"
    sh "${SCRIPT}" install --force >/dev/null 2>&1
    _ec=$?
    assert_eq "TP-TX-02 Termux install exit 0" 0 "$_ec"
    if [ -s "${_pkglog}" ]; then
        t_fail "TP-TX-02 empty table does not call pkg (log=$(_trunc "$(cat "${_pkglog}")"))"
    else
        t_pass "TP-TX-02 empty table does not call pkg"
    fi

    t2p_mk_kit "${PROJECTS_ROOT}/kit-tx"
    t2p_mk_proj "${PROJECTS_ROOT}/proj-tx"

    # TP-TX-06 Termux detect: even with a folder-backup stub, sudo MUST NOT run
    _fb="${_stub}/folder-backup"
    printf '#!/bin/sh\n[ "$1" = version ] && { echo 1.0.0; exit 0; }\nprintf "fb %%s\\n" "$*" >> "%s"\nexit 0\n' "${_stub}/fb.log" >"${_fb}"
    chmod 0755 "${_fb}"
    : >"${_stub}/fb.log"
    : >"${_sudolog}"
    T2P_FOLDER_BACKUP="${_fb}"
    export T2P_FOLDER_BACKUP
    _out=$(PREFIX="${PREFIX}" TERMUX_VERSION="${TERMUX_VERSION}" T2P_FOLDER_BACKUP="${_fb}" \
        T2P_RAM_ROOT="${T2P_RAM_ROOT}" PROJECTS_ROOT="${PROJECTS_ROOT}" HOME="${CI_HOME}" \
        PATH="${_stub}:${PATH}" \
        sh "${SCRIPT}" apply --force kit-tx proj-tx 2>&1)
    _ec=$?
    assert_eq "TP-TX-06 Termux apply exit 0" 0 "$_ec"
    assert_contains "TP-TX-06 dest req kept" "$(cat "${PROJECTS_ROOT}/proj-tx/docs/requirements/requirement-keep.md")" "KEEP-REQ"
    if [ -s "${_sudolog}" ]; then
        t_fail "TP-TX-06 sudo not invoked on Termux (log=$(_trunc "$(cat "${_sudolog}")"))"
    else
        t_pass "TP-TX-06 sudo not invoked on Termux"
    fi
    if [ -s "${_stub}/fb.log" ]; then
        t_fail "TP-TX-06 folder-backup not invoked on Termux (log=$(_trunc "$(cat "${_stub}/fb.log")"))"
    else
        t_pass "TP-TX-06 folder-backup not invoked on Termux"
    fi
    case "${_out}" in
        *"sudo "*) t_fail "TP-TX-06 apply output does not recommend sudo" ;;
        *) t_pass "TP-TX-06 apply output does not recommend sudo" ;;
    esac

    # TP-TX-07 Git Bash: MSYSTEM freeze — sudo unused
    unset PREFIX TERMUX_VERSION 2>/dev/null || true
    MSYSTEM=MINGW64
    export MSYSTEM
    t2p_mk_kit "${PROJECTS_ROOT}/kit-gb"
    t2p_mk_proj "${PROJECTS_ROOT}/proj-gb"
    : >"${_sudolog}"
    : >"${_stub}/fb.log"
    _out=$(MSYSTEM=MINGW64 T2P_FOLDER_BACKUP="${_fb}" \
        T2P_RAM_ROOT="${T2P_RAM_ROOT}" PROJECTS_ROOT="${PROJECTS_ROOT}" HOME="${CI_HOME}" \
        PATH="${_stub}:${PATH}" \
        sh "${SCRIPT}" apply --force kit-gb proj-gb 2>&1)
    _ec=$?
    assert_eq "TP-TX-07 Git Bash apply exit 0" 0 "$_ec"
    if [ -s "${_sudolog}" ]; then
        t_fail "TP-TX-07 sudo not invoked on Git Bash (log=$(_trunc "$(cat "${_sudolog}")"))"
    else
        t_pass "TP-TX-07 sudo not invoked on Git Bash"
    fi
    unset MSYSTEM 2>/dev/null || true

    # TP-TX-08 Termux install --global fails without recommending sudo
    PREFIX="/data/data/com.termux/files/usr"
    TERMUX_VERSION="0.118.0"
    export PREFIX TERMUX_VERSION
    _err=$(PREFIX="${PREFIX}" TERMUX_VERSION="${TERMUX_VERSION}" \
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="/proc/t2p-no-global" \
        PATH="${_stub}:${PATH}" \
        sh "${SCRIPT}" install --global 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-TX-08 Termux --global exit 1" 1 "$_ec"
    assert_contains "TP-TX-08 Next is user-bin install" "$_err" "do not use sudo"
    assert_not_contains "TP-TX-08 no sudo install recipe" "$_err" "sudo ${APP_NAME} install"

    rm -rf "${_stub}" "${T2P_RAM_ROOT}" "${PROJECTS_ROOT}" 2>/dev/null || true
    unset PREFIX TERMUX_VERSION MSYSTEM T2P_FOLDER_BACKUP 2>/dev/null || true
}
