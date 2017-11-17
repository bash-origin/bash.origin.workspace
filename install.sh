#!/usr/bin/env bash

. "node_modules/bash.origin/bash.origin"

BO_cecho "[bash.origin.workspace] ----- START INSTALL ----- (pwd: $(pwd))" WHITE BOLD

COMMON_PACKAGE_URI_ORG_REPO="bash-origin/bash.origin.workspace"
COMMON_PACKAGE_URI="github.com/${COMMON_PACKAGE_URI_ORG_REPO}"
COMMON_PACKAGE_VERSION=$(BO_getLatestTagForURI "${COMMON_PACKAGE_URI}")
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


# Make sure the dependencies are installed
binSubPath="node_modules/.bin";
pushd "${COMMON_PACKAGE_ROOT}" > /dev/null
    NODE_MAJOR_VERSION="$(node --version 2>&1 | perl -pe 's/^v(\d+).+$/$1/')"
    BO_cecho "[bash.origin.workspace] NODE_MAJOR_VERSION: ${NODE_MAJOR_VERSION}" WHITE BOLD

    VERSIONED_DEPENDENCIES_PATH="dependencies/.node-v${NODE_MAJOR_VERSION}"
    [ -e "${VERSIONED_DEPENDENCIES_PATH}" ] || mkdir "${VERSIONED_DEPENDENCIES_PATH}"

    pushd "${VERSIONED_DEPENDENCIES_PATH}" > /dev/null
        if [ ! -e ".installed" ]; then
            BO_cecho "[bash.origin.workspace] Installing dependencies in: $(pwd)" WHITE BOLD

            cp "../package.json" "package.json"
            npm install --production

            ln -s "${COMMON_PACKAGE_ROOT}/interface.js" "${VERSIONED_DEPENDENCIES_PATH}/${binSubPath}/bash.origin.workspace.inf.js"

            touch ".installed"
        fi
    popd > /dev/null
popd > /dev/null


# Link bin files
workspaceRootPath="$(pwd)"
pushd "${COMMON_PACKAGE_ROOT}/${VERSIONED_DEPENDENCIES_PATH}" > /dev/null

    BO_cecho "[bash.origin.workspace] Linking commands from bin '$(pwd)/${binSubPath}':" WHITE BOLD
    for subpath in ${binSubPath}/*; do
        BO_cecho "[bash.origin.workspace]   ${subpath}" WHITE BOLD

        [ -e "${workspaceRootPath}/${subpath}" ] ||
            ln -s "${COMMON_PACKAGE_ROOT}/${VERSIONED_DEPENDENCIES_PATH}/${subpath}" "${workspaceRootPath}/${subpath}"
    done
popd > /dev/null
