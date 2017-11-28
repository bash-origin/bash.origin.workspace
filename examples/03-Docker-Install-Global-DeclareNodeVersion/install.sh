#!/usr/bin/env bash

echo -e "\n########## RUN INSTALL ON DOCKER IMAGE ##########\n"

echo "VERBOSE: ${VERBOSE}"
echo "BO_VERBOSE: ${BO_VERBOSE}"
echo "UID: ${UID}"
echo "EUID: ${EUID}"
echo "GROUPS: ${GROUPS}"

# Allow NPM running as 'nobody' access to 'root' home.
# Handy for development!
# NOTE: Do NOT do this when running in production!
chmod -Rf 777 /root

# Allow dynamic installation of packages by setting
# global cache directory group writable.
# Handy for development!
# NOTE: Do NOT do this when running in production!
mkdir /usr/local/lib/bash.origin.cache || true
chmod g+w /usr/local/lib/bash.origin.cache


echo "Install workspace package ..."

# '--unsafe-perm' is needed to not use the 'nobody' group.
export BO_WORKSPACE_INSTALL_MINIMAL=1
npm install --unsafe-perm -g bash.origin.workspace --production
