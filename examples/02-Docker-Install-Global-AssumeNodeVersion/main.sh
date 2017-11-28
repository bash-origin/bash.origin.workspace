#!/usr/bin/env bash.origin.script

if ! BO_if_os "osx"; then
	BO_exit_error "You are not on macOS!"
fi

echo "TEST_MATCH_IGNORE>>>"

depend {
    "docker": {
		"@com.github/bash-origin/bash.origin.docker#s1": "localhost"
	}
}


CALL_docker build . "bo-workspace-02"

echo "<<<TEST_MATCH_IGNORE"


CALL_docker run "bo-workspace-02"
