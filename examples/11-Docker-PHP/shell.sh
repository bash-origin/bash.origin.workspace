#!/bin/bash
# Source https://github.com/bash-origin/bash.origin
. "$HOME/.bash.origin"

BO_format "${BO_VERBOSE}" "HEADER" "stack.sh $@"



echo "[shell.sh] AUTHORIZED_KEYS: ${AUTHORIZED_KEYS}"


# @see https://github.com/tutumcloud/tutum-ubuntu/blob/master/trusty/run.sh
if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    set +e
    mkdir -p /root/.ssh || true
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
    set -e
fi
exec /usr/sbin/sshd -D &



set +e

echo "[shell.sh] BO_VERBOSE: ${BO_VERBOSE}"
echo "[shell.sh] VERBOSE: ${VERBOSE}"


echo "[shell.sh] pwd: $(pwd)"

ls -al

echo "[shell.sh] Linking app directory"

ln -s "$(pwd)" "/app"

echo "[shell.sh] Run PHP"

set -e

/run.sh

BO_format "${BO_VERBOSE}" "FOOTER"
