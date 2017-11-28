#!/usr/bin/env bash.origin.script

echo -e "\n########## RUN SCRIPT ON DOCKER IMAGE ##########\n"

echo "BO_PREFIX_DIR: ${BO_PREFIX_DIR}"
echo "BO_ASSUME_NODE: ${BO_ASSUME_NODE}"
echo "BO_VERSION_NODE: ${BO_VERSION_NODE}"

BO_run_node --version

BO_run_node --eval '
    const LIB = require("bash.origin.workspace").LIB;
    console.log(JSON.stringify(LIB.LODASH.merge({
        "foo": "bar"
    }, {
        "key": "value"
    })));
'

BO_cecho "OK" GREEN
