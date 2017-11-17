
const PATH = require("path");
const FS = require("fs");

const INTERFACE = require("./node_modules/.bin/bash.origin.workspace.inf.js");


const LIB = exports.LIB = {};
FS.readdirSync(INTERFACE.node_modules).map(function (path) {

    console.log("path IN NODE_MODULES_PATH", path);

});

