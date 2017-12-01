#!/usr/bin/env bash

echo -e "\n########## RUN INSTALL ON DOCKER IMAGE ##########\n"

echo "VERBOSE: ${VERBOSE}"
echo "BO_VERBOSE: ${BO_VERBOSE}"
echo "UID: ${UID}"
echo "EUID: ${EUID}"
echo "GROUPS: ${GROUPS}"

echo "Install workspace package ..."

# '--unsafe-perm' is needed to not use the 'nobody' group.
export BO_WORKSPACE_INSTALL_MINIMAL=1
npm install --unsafe-perm bash.origin.workspace --production
