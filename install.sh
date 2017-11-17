#!/usr/bin/env bash

. "node_modules/bash.origin/bash.origin"

BO_cecho "[bash.origin.workspace] ----- START INSTALL ----- (pwd: $(pwd))" WHITE BOLD

COMMON_PACKAGE_URI="github.com/bash-origin/bash.origin.workspace"
COMMON_PACKAGE_VERSION=$(BO_getLatestTagForURI "${COMMON_PACKAGE_URI}")
BO_systemCachePath "COMMON_PACKAGE_ROOT" "${COMMON_PACKAGE_URI}" "${COMMON_PACKAGE_VERSION}"

echo "COMMON_PACKAGE_ROOT: $COMMON_PACKAGE_ROOT"


if [ ! -e "dependencies/.installed" ]; then

    pushd "dependencies" > /dev/null

#        npm install

#        touch ".installed"

    popd > /dev/null

fi
