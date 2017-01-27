#!/bin/bash
# Source https://github.com/bash-origin/bash.origin
. "$HOME/.bash.origin"

BO_format "${BO_VERBOSE}" "HEADER" "stack.sh $@"


echo "[shell.sh] BO_VERBOSE: ${BO_VERBOSE}"
echo "[shell.sh] VERBOSE: ${VERBOSE}"

ls -al

echo "[shell.sh] Run server.js"

BO_run_node "server.js"

BO_format "${BO_VERBOSE}" "FOOTER"
