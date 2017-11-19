#!/usr/bin/env bash

# Make sure the dependencies are installed
workspaceRootPath="$(pwd)"
pushd "${COMMON_PACKAGE_ROOT}" > /dev/null

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
            export __BO_WORKSPACE_INSTALL="${COMMON_PACKAGE_ROOT}"
            BO_LOADED= npm install --production
            export __BO_WORKSPACE_INSTALL=

            if [ ! -e "${binSubPath}" ]; then
                mkdir -p "${binSubPath}"
            fi

            touch ".installed"
        fi
    popd > /dev/null
popd > /dev/null

if [ "${npm_package_name}" == "bash.origin.workspace" ]; then
    BO_run_recent_node --eval '
        const PATH = require("path");
        const FS = require("'${COMMON_PACKAGE_ROOT}'/'${VERSIONED_DEPENDENCIES_PATH}'/node_modules/fs-extra");
        if (require("./package.json").name === "bash.origin.workspace") {
            if (
                "'${COMMON_PACKAGE_ROOT}'" !== "'${workspaceRootPath}'" &&
                FS.existsSync("'${COMMON_PACKAGE_ROOT}'/'${VERSIONED_DEPENDENCIES_PATH}'/package-lock.json")
            ) {
                
                if (!FS.existsSync("'${workspaceRootPath}'/'${VERSIONED_DEPENDENCIES_PATH}'")) {
                    FS.mkdirSync("'${workspaceRootPath}'/'${VERSIONED_DEPENDENCIES_PATH}'");
                }

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
rm -Rf "${binSubPath}/bash.origin.workspace.inf.js" || true
ln -s "${COMMON_PACKAGE_ROOT}/interface.js" "${binSubPath}/bash.origin.workspace.inf.js"
