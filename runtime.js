
const PATH = require("path");
const FS = require("fs");

const NODE_MODULES_PATH = require("node_modules/.bin/bash.origin.workspace.inf").node_modules;


const LIB = exports.LIB = {};
FS.readdirSync(NODE_MODULES_PATH).map(function (path) {

    console.log("path IN NODE_MODULES_PATH", path);

});

