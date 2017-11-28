#!/usr/bin/env bash

echo -e "\n########## RUN TEST ON DOCKER IMAGE ##########\n"

echo "VERBOSE: ${VERBOSE}"
echo "BO_VERBOSE: ${BO_VERBOSE}"
echo "UID: ${UID}"
echo "EUID: ${EUID}"
echo "GROUPS: ${GROUPS}"

echo "package source: $(node --eval 'process.stdout.write(require.resolve("bash.origin.workspace"));')"

echo "which bash.origin: $(which bash.origin)"
echo "which bash.origin.script: $(which bash.origin.script)"
echo "which bash.origin.test: $(which bash.origin.test)"
echo "which bash.origin.workspace.inf.js: $(which bash.origin.workspace.inf.js)"


function showInfo {
    pushd "$1"
        ls
    popd
}

showInfo .
showInfo node_modules
showInfo node_modules/.bin
showInfo /usr/local/bin
showInfo /usr/local/lib
showInfo /usr/local/lib/bash.origin.cache


#export BO_VERBOSE=1
export BO_PLUGIN_SEARCH_DIRPATHS=$(node --eval 'process.stdout.write(require("'$(which bash.origin.workspace.inf.js)'").node_modules);')

./script.sh
