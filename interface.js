#!/usr/bin/env node

const PATH = require("path");


exports.node_modules = PATH.join(
    __dirname,
    "dependencies/.node-" + process.version.split(".")[0],
    "node_modules"
);
