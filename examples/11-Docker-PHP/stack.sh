#!/bin/bash
# Source https://github.com/bash-origin/bash.origin
. "$HOME/.bash.origin"

BO_format "${BO_VERBOSE}" "HEADER" "stack.sh $@"


# @see https://ubuntuforums.org/showthread.php?t=1346581
locale-gen en_US.UTF-8
dpkg-reconfigure locales


BO_ensure_node

echo "$(printenv)" > "$HOME/.env"

cat "$HOME/.env"


BO_format "${BO_VERBOSE}" "FOOTER"
