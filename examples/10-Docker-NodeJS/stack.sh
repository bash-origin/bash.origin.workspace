#!/bin/bash
# Source https://github.com/bash-origin/bash.origin
. "$HOME/.bash.origin"

BO_format "${BO_VERBOSE}" "HEADER" "stack.sh $@"


BO_ensure_node


BO_format "${BO_VERBOSE}" "FOOTER"
