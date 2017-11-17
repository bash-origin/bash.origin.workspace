#!/usr/bin/env node

const PATH = require("path");
const FS = require("fs");

const BASE_PATH = PATH.dirname(FS.realpathSync(__filename));


console.log("[interface.js] __dirname", __dirname);
console.log("[interface.js] PWD", process.cwd);
console.log("[interface.js] BASE_PATH", BASE_PATH);


exports.version = require(PATH.join(
    BASE_PATH,
    "package.json"
)).version;

exports.node_modules = PATH.join(
    BASE_PATH,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);
