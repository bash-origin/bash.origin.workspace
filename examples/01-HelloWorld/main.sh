#!/usr/bin/env bash.origin.script


# TODO: Relocate into test helper
if ! BO_if_os "osx"; then
		echo "TODO: Support other operating systems."
		echo "which docker: $(which docker)"
		if BO_has docker; then
				echo "docker --version: $(docker --version)"
		fi
		echo ">>>SKIP_TEST<<<"
		exit 0
fi


echo "TEST_MATCH_IGNORE>>>"
depend {
    "workspace": "@com.github/bash-origin/bash.origin.workspace#1"
}


CALL_workspace ensure .

CALL_workspace expect_started .

CALL_workspace stop .

echo "<<<TEST_MATCH_IGNORE"

echo "OK"
