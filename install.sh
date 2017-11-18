#!/usr/bin/env bash

if [ ! -z "$__BO_WORKSPACE_INSTALL" ]; then
    echo "[bash.origin.workspace] ----- SKIP INSTALL (already installing) ----- (pwd: $(pwd))"
    exit 0
fi

set +e

. "node_modules/bash.origin/bash.origin"

BO_cecho "[bash.origin.workspace] ----- START INSTALL ----- (pwd: $(pwd))" WHITE BOLD

COMMON_PACKAGE_URI_ORG_REPO="bash-origin/bash.origin.workspace"
COMMON_PACKAGE_URI="github.com/${COMMON_PACKAGE_URI_ORG_REPO}"
COMMON_PACKAGE_VERSION=$(BO_getLatestTagForURI "${COMMON_PACKAGE_URI}")

if [ -z "$COMMON_PACKAGE_ROOT" ]; then

    BO_systemCachePath "COMMON_PACKAGE_ROOT" "${COMMON_PACKAGE_URI}" "${COMMON_PACKAGE_VERSION}"

    BO_cecho "[bash.origin.workspace] COMMON_PACKAGE_ROOT: ${COMMON_PACKAGE_ROOT}" WHITE BOLD

    # Make sure the latest source code is available.
    if [ ! -e "${COMMON_PACKAGE_ROOT}" ]; then
        COMMON_PACKAGE_VERSION_URL="https://github.com/${COMMON_PACKAGE_URI_ORG_REPO}/archive/$COMMON_PACKAGE_VERSION.zip"
        BO_cecho "[bash.origin.workspace] Downloading from '${COMMON_PACKAGE_VERSION_URL}'" WHITE BOLD

        BO_ensureInSystemCache "COMMON_PACKAGE_ROOT_EXTRACTED" "${COMMON_PACKAGE_URI}" "${COMMON_PACKAGE_VERSION}" "${COMMON_PACKAGE_VERSION_URL}"

        if [ "${COMMON_PACKAGE_ROOT_EXTRACTED}" != "${COMMON_PACKAGE_ROOT}" ]; then
            BO_exit_error "Extracted root '${COMMON_PACKAGE_ROOT_EXTRACTED}' not in the expected location '${COMMON_PACKAGE_ROOT}'"
        fi
    fi
else
    if [ ! -e "${COMMON_PACKAGE_ROOT}" ]; then
        BO_exit_error "No extracted root found at '${COMMON_PACKAGE_ROOT_EXTRACTED}'"
    fi
fi

NODE_MAJOR_VERSION="$(node --version 2>&1 | perl -pe 's/^v(\d+).+$/$1/')"
BO_cecho "[bash.origin.workspace] NODE_MAJOR_VERSION: ${NODE_MAJOR_VERSION}" WHITE BOLD

export BO_VERSION_RECENT_NODE="${NODE_MAJOR_VERSION}"
export BO_VERSION_NVM_NODE="${NODE_MAJOR_VERSION}"

# Make sure the dependencies are installed
workspaceRootPath="$(pwd)"
binSubPath="node_modules/.bin";
pushd "${COMMON_PACKAGE_ROOT}" > /dev/null

    VERSIONED_DEPENDENCIES_PATH="dependencies/.node-v${NODE_MAJOR_VERSION}"
    [ -e "${VERSIONED_DEPENDENCIES_PATH}" ] || mkdir "${VERSIONED_DEPENDENCIES_PATH}"

    pushd "${VERSIONED_DEPENDENCIES_PATH}" > /dev/null

        if BO_has_cli_arg "--force"; then
            BO_cecho "[bash.origin.workspace] Forcing install of dependencies in: $(pwd)" MAGENTA BOLD
            rm ".installed" || true
            rm "package-lock.json" || true
            rm -Rf "node_modules" || true
        fi

        if [ ! -e ".installed" ]; then
            BO_cecho "[bash.origin.workspace] Installing dependencies in: $(pwd)" WHITE BOLD

            rm -Rf "package.json" || true
            if [ "${npm_package_name}" == "bash.origin.workspace" ]; then
                cp "${workspaceRootPath}/dependencies/package.json" "package.json"
            else
                cp "../package.json" "package.json"
            fi
            export __BO_WORKSPACE_INSTALL=1
            npm install --production
            export __BO_WORKSPACE_INSTALL=

            if [ ! -e "${binSubPath}" ]; then
                mkdir -p "${binSubPath}"
            fi
            #rm -Rf "${binSubPath}/bash.origin.workspace.inf.js" || true
            #ln -s "${COMMON_PACKAGE_ROOT}/interface.js" "${binSubPath}/bash.origin.workspace.inf.js"

            #echo "${COMMON_PACKAGE_ROOT}" > "${binSubPath}/.bash.origin.workspace.path"

            touch ".installed"
        fi
    popd > /dev/null
popd > /dev/null

if [ "${npm_package_name}" == "bash.origin.workspace" ]; then
    BO_run_recent_node --eval '
        const PATH = require("path");
        const FS = require("'${COMMON_PACKAGE_ROOT}'/'${VERSIONED_DEPENDENCIES_PATH}'/node_modules/fs-extra");
        if (FS.existsSync(PATH.join(process.cwd(), "package.json"))) {
            if (FS.existsSync("'${COMMON_PACKAGE_ROOT}'/'${VERSIONED_DEPENDENCIES_PATH}'/package-lock.json")) {
                FS.copySync(
                    "'${COMMON_PACKAGE_ROOT}'/'${VERSIONED_DEPENDENCIES_PATH}'/package-lock.json",
                    "'${workspaceRootPath}'/'${VERSIONED_DEPENDENCIES_PATH}'/package-lock.json"
                );
            }
        }
    '
fi


# Link bin files
pushd "${COMMON_PACKAGE_ROOT}/${VERSIONED_DEPENDENCIES_PATH}" > /dev/null

    BO_cecho "[bash.origin.workspace] Linking commands from bin '$(pwd)/${binSubPath}':" WHITE BOLD
    for subpath in ${binSubPath}/*; do
        BO_cecho "[bash.origin.workspace]   ${subpath}" WHITE BOLD

        rm -f "${workspaceRootPath}/${subpath}" || true
        ln -s "${COMMON_PACKAGE_ROOT}/${VERSIONED_DEPENDENCIES_PATH}/${subpath}" "${workspaceRootPath}/${subpath}"
    done
popd > /dev/null


# Link interface path
echo "${COMMON_PACKAGE_ROOT}/interface-common.js" > "${binSubPath}/.bash.origin.workspace.inf.js.path"

