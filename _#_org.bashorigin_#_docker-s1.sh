#!/usr/bin/env bash.origin.script

local IMAGE_ID="org.bashorigin.workspace.0"
# TODO: Make port configurable
local PORT="8001"

depend {
    "vm": {
        "@com.github/bash-origin/bash.origin.docker#s1": "localhost"
    }
}

function EXPORTS_status {

    BO_log "1" "Bash.Origin.Workspace Server running at: http://${DOCKER_CONTAINER_HOST_IP}:${PORT}"

}

function EXPORTS_is_running {

		local requestID=`uuidgen`
    local testUrl="http://${DOCKER_CONTAINER_HOST_IP}:${PORT}/status?rid=${requestID}"
		local command="curl -s "$testUrl""

    BO_log "$VERBOSE" "Running: ${command}"
		local response=`${command}`
    BO_log "$VERBOSE" "Response: ${response}"

		if [ "${response}" != "OK:${requestID}" ]; then
        return 1
		fi

    return 0
}


function EXPORTS_ensure {

    # TODO: Check source checksum and if changed trigger build and restart.
    local forceBuild=0

		local requestID=`uuidgen`
    local testUrl="http://${DOCKER_CONTAINER_HOST_IP}:${PORT}/status?rid=${requestID}"
		local command="curl -s "$testUrl""

    BO_log "$VERBOSE" "Running: ${command}"
		local response=`${command}`
    BO_log "$VERBOSE" "Response: ${response}"

		if [ $forceBuild == 1 ] || ! EXPORTS_is_running; then
        # NOTE: This will also re-build the image if '--compile' is specified.
        EXPORTS_start "$@"
    else
        # TODO: Ensure that source checksum is same as checksum from status. If not trigger a build as source has changed.
        BO_log "$VERBOSE" "Bash.Origin.Workspace Server already running at: http://${DOCKER_CONTAINER_HOST_IP}:${PORT}"
		fi
}

function EXPORTS_start {

    BO_log "$VERBOSE" "Starting Bash.Origin.Workspace Server at: http://${DOCKER_CONTAINER_HOST_IP}:${PORT}"

    cp -f "${BO_ROOT_SCRIPT_PATH}" ".bash.origin"

    # TODO: Include MAJOR version number in image tag name dynamically.
    # TODO: Check for '--compile' flag using helper instead of using '_BO_OPTIMIZED'.
		if [ $_BO_OPTIMIZED == 0 ]; then
        CALL_vm force_build "$(pwd)" "${IMAGE_ID}"
    else
        CALL_vm build "$(pwd)" "${IMAGE_ID}"
    fi

    EXPORTS_just_start "$@"
}

function EXPORTS_just_start {

    BO_log "$VERBOSE" "Starting Bash.Origin.Workspace Server at: http://${DOCKER_CONTAINER_HOST_IP}:${PORT}"

    if [ -e "${1}" ]; then
        pushd "${1}" > /dev/null
	           CALL_vm ensure_directory_mounted_into_docker_machine "$(pwd)"

             CALL_vm start "${IMAGE_ID}" "${PORT}" -v "$(pwd):/workspace" -w "/workspace" -p 2222:22
        popd > /dev/null
    else
        CALL_vm start "${IMAGE_ID}" "${PORT}" -p 2222:22
    fi

    BO_log "$VERBOSE" "Started Bash.Origin.Workspace Server at: http://${DOCKER_CONTAINER_HOST_IP}:${PORT}"

    if [ ! -z "$VERBOSE" ]; then
		    CALL_vm logs "${IMAGE_ID}"
    fi
}

function EXPORTS_expect_started {

		if ! EXPORTS_is_running; then
        echo "ERROR: Bash.Origin.Workspace is not running!"
        exit 1
    fi

}

function EXPORTS_login {

    ssh -p 2222 "root@${DOCKER_CONTAINER_HOST_IP}"

}

function EXPORTS_run {

    function  runRemote {

#        script=$1
#        script=$(echo -e "set +e\\n. \$HOME/.bash.origin\\nBO_ensure_node\n\nset -e\\n$script")

        ssh -p 2222 "root@${DOCKER_CONTAINER_HOST_IP}" "bash -s" << EOF

. \$HOME/.env

echo "Sourcing .profile"
. \$HOME/.profile

printenv

echo "Sourcing .bash.origin"
. \$HOME/.bash.origin

echo "PATH: $PATH"

printenv

#BO_ensure_node

echo "PATH: $PATH"

BO_run_node --version

pwd

ls -al ~/

#cat .profile
#cat .bashrc

EOF
    }

    runRemote "$2"
}

function EXPORTS_stop {

    CALL_vm stop "${IMAGE_ID}"

}

function EXPORTS_follow_logs {

		CALL_vm logs "${IMAGE_ID}" --follow

}
