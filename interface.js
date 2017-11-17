#!/usr/bin/env node

const PATH = require("path");

exports.version = require("./package.json").version;

exports.node_modules = PATH.join(
    __dirname,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);
