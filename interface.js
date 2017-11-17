#!/usr/bin/env node

const PATH = require("path");


console.log("[interface.js] __dirname", __dirname);
console.log("[interface.js] PWD", process.cwd);


exports.version = require(PATH.join(
    __dirname,
    "package.json"
)).version;

exports.node_modules = PATH.join(
    __dirname,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);
