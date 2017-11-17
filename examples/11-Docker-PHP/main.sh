#!/usr/bin/env bash.origin.script

echo ">>>SKIP_TEST<<<"
exit 0


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
    "electron": "@com.github/bash-origin/bash.origin.electron#1",
    "workspace": "@com.github/bash-origin/bash.origin.workspace#docker-s1",
    "c9": "@com.github/bash-origin/bash.origin.c9#1"
}


# https://www.linode.com/docs/applications/containers/how-to-install-docker-and-deploy-a-lamp-stack

#-e MYSQL_PASS="mypass"
#mysql -uadmin -p"mypass"


# TODO: Remove need for '.'


#CALL_workspace ensure .
#CALL_workspace just_start .

#CALL_workspace follow_logs .

echo "NodeJS Version in Workspace:"
#CALL_workspace run . "BO_run_node --version"
#CALL_workspace run . "printenv"


#CALL_electron open_url "http://192.168.99.100:8001/"


#CALL_c9 open_in_electron


#CALL_workspace login .

#sleep 3

#CALL_workspace expect_started .

#CALL_workspace stop .

# docker login <ContainerId>

#cat $(docker logs <ContainerId>) | grep 'mysql -uadmin -pOy87MP143RRd -h<host> -P<port>'

echo "<<<TEST_MATCH_IGNORE"

echo "OK"
