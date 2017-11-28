#!/usr/bin/env bash

binSubPath="node_modules/.bin";

if [ ! -z "$__BO_WORKSPACE_INSTALL" ]; then
    # We only need one copy (the first one) of 'bash.origin.workspace' available which will install
    # everything, link its bin files and interface file. 

    # The only thing we have to do is link the interface file.
    echo >&2 "[bash.origin.workspace] Linking interface file to '$(pwd)/${binSubPath}/bash.origin.workspace.inf.js'"
    rm -Rf "${binSubPath}/bash.origin.workspace.inf.js" || true
    mkdir -p "${binSubPath}" || true
    ln -s "${__BO_WORKSPACE_INSTALL}/interface-common.js" "${binSubPath}/bash.origin.workspace.inf.js"

    echo >&2 "[bash.origin.workspace] ----- SKIP INSTALL (already installing) ----- (pwd: $(pwd))"
    exit 0
fi

set +e

boRootScriptPath="$(node --eval 'process.stdout.write(
    require("path").join(require.resolve("bash.origin/package.json"), "../bash.origin")
);')"

if [ ! -e "${boRootScriptPath}" ]; then
    echo >&2 "[bash.origin.workspace] ----- ERROR STARTING INSTALL ('bash.origin/package.json' not found) ----- (pwd: $(pwd))"
    exit 1
fi


NODE_MAJOR_VERSION="$(node --version 2>&1 | perl -pe 's/^v(\d+).+$/$1/')"
echo "[bash.origin.workspace] NODE_MAJOR_VERSION: ${NODE_MAJOR_VERSION}"

export BO_VERSION_RECENT_NODE="${NODE_MAJOR_VERSION}"
export BO_VERSION_NVM_NODE="${NODE_MAJOR_VERSION}"

VERSIONED_DEPENDENCIES_PATH="dependencies/.node-v${NODE_MAJOR_VERSION}"


BO_LOADED=
. "${boRootScriptPath}"

BO_cecho "[bash.origin.workspace] ----- START INSTALL ----- (pwd: $(pwd))" WHITE BOLD

BO_cecho "[bash.origin.workspace] UID: ${UID}" WHITE BOLD
BO_cecho "[bash.origin.workspace] EUID: ${EUID}" WHITE BOLD
BO_cecho "[bash.origin.workspace] GROUPS: ${GROUPS}" WHITE BOLD

COMMON_PACKAGE_URI_ORG_REPO="bash-origin/bash.origin.workspace"
COMMON_PACKAGE_URI="github.com/${COMMON_PACKAGE_URI_ORG_REPO}"
COMMON_PACKAGE_VERSION=$(BO_getLatestTagForURI "${COMMON_PACKAGE_URI}")

BO_cecho "[bash.origin.workspace] COMMON_PACKAGE_URI: ${COMMON_PACKAGE_URI}" WHITE BOLD
BO_cecho "[bash.origin.workspace] COMMON_PACKAGE_VERSION: ${COMMON_PACKAGE_VERSION}" WHITE BOLD

if [ -z "$COMMON_PACKAGE_ROOT" ]; then

    BO_systemCachePath "COMMON_PACKAGE_ROOT" "${COMMON_PACKAGE_URI}" "${COMMON_PACKAGE_VERSION}"

    BO_cecho "[bash.origin.workspace] COMMON_PACKAGE_ROOT: ${COMMON_PACKAGE_ROOT}" WHITE BOLD

    # Make sure the latest source code is available.
    if [ ! -e "${COMMON_PACKAGE_ROOT}" ]; then
        COMMON_PACKAGE_VERSION_URL="https://github.com/${COMMON_PACKAGE_URI_ORG_REPO}/archive/$COMMON_PACKAGE_VERSION.zip"
        BO_cecho "[bash.origin.workspace] Downloading from '${COMMON_PACKAGE_VERSION_URL}'" WHITE BOLD

        BO_ALLOW_DOWNLOADS=1 BO_ensureInSystemCache "COMMON_PACKAGE_ROOT_EXTRACTED" "${COMMON_PACKAGE_URI}" "${COMMON_PACKAGE_VERSION}" "${COMMON_PACKAGE_VERSION_URL}"

        if [ "${COMMON_PACKAGE_ROOT_EXTRACTED}" != "${COMMON_PACKAGE_ROOT}" ]; then
            BO_exit_error "Extracted root '${COMMON_PACKAGE_ROOT_EXTRACTED}' not in the expected location '${COMMON_PACKAGE_ROOT}'"
        fi
    fi
else
    if [ ! -e "${COMMON_PACKAGE_ROOT}" ]; then
        BO_exit_error "No extracted root found at '${COMMON_PACKAGE_ROOT_EXTRACTED}'"
    fi
fi



if [ "${npm_package_name}" == "bash.origin.workspace" ]; then
    BO_run_recent_node --eval '
        const PATH = require("path");
        const FS = require("fs");
        if (require("./package.json").name === "bash.origin.workspace") {
            FS.writeFileSync(
                "'${COMMON_PACKAGE_ROOT}'/dependencies/postinstall.sh",
                FS.readFileSync("dependencies/postinstall.sh")
            );
        }
    '
fi

BO_cecho "[bash.origin.workspace] Calling postinstall at '${COMMON_PACKAGE_ROOT}/dependencies/postinstall.sh'" WHITE BOLD

. "${COMMON_PACKAGE_ROOT}/dependencies/postinstall.sh"
