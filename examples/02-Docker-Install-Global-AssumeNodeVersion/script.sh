#!/usr/bin/env bash.origin.script

echo -e "\n########## RUN SCRIPT ON DOCKER IMAGE ##########\n"

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
